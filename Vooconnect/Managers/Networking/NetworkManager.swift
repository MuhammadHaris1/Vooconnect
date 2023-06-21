//
//  NetworkManager.swift
//  LiveCheff
//
//  Created by Online Developer on 02/09/2022.
//

import Combine
import Foundation
import Network
import Swinject
import ARGear
/// enum for the media type object, currently there will be photo or video.
enum MediaType: String {
    case photo = "image/jpeg"
    case video = "video/mp4"
}

/// A media struct which is being used to pass in multipart request with some properties.
struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    init?(withMediaData data: Data, forKey key: String, withMimeType mediaType: MediaType) {
        self.key = key
        self.mimeType = mediaType.rawValue
        if mediaType == .photo {
            self.filename = "ImageFile\(Date().timeIntervalSince1970).jpg"
        } else {
            self.filename = "VideoFile\(Date().timeIntervalSince1970).mp4"
        }
        self.data = data
    }
}

/// Handles all network calls mad by the app
class NetworkManager {
    
    // Set global logger object
    static let netlogger = Logger()
    var argSession: ARGSession?
    /// Use this method to call your desired endpoint
    ///
    /// - Parameters:
    ///  - endpoint: The desired endpoint that will be used to make this call
    ///  - dataType: The data type you will expect back from the call (Optional, as all calls will not have a data type to send back
    static func makeEndpointCall<T: Decodable>(fromEndpoint endpoint: NetworkConstants.Endpoint,
                                               withDataType dataType: T.Type? = nil,
                                               parameters: [String: Any]? = nil,
                                               mediaData: Media? = nil,
                                               promise: @escaping (Result<T, Error>) -> ()) {
        
        NetworkManager.endpointCall(endpoint: endpoint,
                                    parameters: parameters,
                                    mediaData: mediaData,
                                    dataType: dataType)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                
                switch completion {
                case .finished:
                    logger.info("Endpoint call is complete: \(completion)", category: .network)
                case .failure(let error):
                    logger.error("Endpoint call has an error: \(error)", category: .network)
                    promise(.failure(error))
                }
                
            }, receiveValue: { value in
                promise(.success(value))
            })
            .store(in: &cancelables)
        
    }
    
    // MARK: - Private
    
    /// This counter is for how many times a refresh should happen: [n = n+1 times]
    private static var refreshAttempts = 2
    private static var cancelables = Set<AnyCancellable>()
    private static var networkAuthenticationModel = Container.default.resolver.resolve(NetworkAuthenticationModel.self)
    
    /// Main endpoint call that handles multiple endpoint strings and http request configurations
    ///
    /// - Parameters:
    ///  - endpoint: The desired endpoint that will be used to make this call
    ///  - parameters: Values that the endpoint may need to configure the call or may need to send (Optional)
    ///  - urlParameter: A single value that will be attached to an endpoint such as an 'id' (This may not be needed anymore)
    ///  - dataType: The data type you will expect back from the call (Optional, as all calls will not have a data type to send back
    private static func endpointCall<T: Decodable>(endpoint: NetworkConstants.Endpoint,
                                                   parameters: [String: Any]? = nil,
                                                   urlParameter: String? = nil,
                                                   mediaData: Media? = nil,
                                                   dataType: T.Type? = nil) -> Future<T, Error> {
        
        // Check for reachability just before the call is made
        checkReachability()
        
        return Future<T, Error> { promise in
            
            guard var url = URLComponents(string: endpoint.getBaseUrl.appending(endpoint.value)) else {
                return promise(.failure(NetworkError.invalidURL))
            }
            
            let request = setUrlRequest(url: &url,
                                        parameters: parameters,
                                        mediaData: mediaData,
                                        endpoint: endpoint)
            logger.debug("URL is \(url.url?.absoluteString ?? "")", category: .network)
            
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        
                        /// - Note: Needs to be logged and all codes handled here
                        logger.error("Failed with: \(response.description)", category: .network)
                        let statusCode = (response as? HTTPURLResponse)?.statusCode
                        logger.error("Failure status code: \(String(describing: statusCode))", category: .network)
                        
                        if statusCode == 500 {
                            logger.error("Error with status code 500", category: .network)
                            promise(.failure(NetworkError.serverError))
                            throw NetworkError.serverError
                        } else {
                            /// get request error that are defined on BE.
                            do {
                                let decodedData = try JSONDecoder().decode(RequestErrorModel.self, from: data)
                                throw RequestError(code: decodedData.status, message: decodedData.message)
                            }
                        }
                    }
                    
                    /// - Note: print out the json data
                     print(String(data: data, encoding: .utf8))
                    
                     return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            logger.error("There has been a DecodingError from \(#function)", category: .network)
                            promise(.failure(decodingError))
                        case let networkError as NetworkError:
                            
                            /// - Note: This cannot be removed although it seems like it does nothing. Removing it will not execute the full total recall for some reason and needs to be looked into more
                            
                            logger.error("There has been a NetworkError from \(#function), with error: \(String(describing: networkError.errorDescription))", category: .network)
                            
                            // get error code value
                            let errorCode = (error as NSError).code
                            logger.debug("The error code is: \(errorCode)", category: .network)
                            
                            /// - Note: if this is here it will kill whatever comes back from the original total recall from the unauth code. Keeping it here for reference

                        case let requestError as RequestError:
                            logger.error("There has been a RequestError from \(#function)", category: .network)
                            promise(.failure(requestError))
                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                    
                }, receiveValue: {
                    logger.info("Value was returned successfully from network call.", category: .network)
                    promise(.success($0))
                })
                .store(in: &self.cancelables)
            
        }
    }
    
    /// Set the HTTP (request) method by the endpoint being used
    ///
    /// - Parameters:
    ///  - endpoint: The endpoint needed to determine what request method gets returned
    ///
    /// - Returns: HTTP request method
    private static func setRequestMethod(forEndpoint endpoint: NetworkConstants.Endpoint) -> NetworkConstants.RequestMethod {
        switch endpoint {
        case .refreshToken,
                .follow,
                .unfollow,
                .removeFollower,
                .getUserStats,
                .getPosts,
                .getBookmarkedPosts,
                .getFavoritePosts,
                .getFollowers,
                .getFollowing,
                .getSuggestedUsers,
                .getPrivatePosts,
                .reportUser,
                .blockUser,
                .uploadFile,
                .findUsersByPhone,
                .userDetail,
                .profileViewed,
                .getProfileViewers:
            return .post
        case .getFilterData:
            return .get
        case .updateUserLocation,
            .updateProfile:
            return .put
        }
        
        
    }
    /// - Note: May need to build a method (or add to the one above to return a tuple) for default parameter settings
    
    /// Set the URL request that will be used by the endpoint call method
    ///
    ///  - Parameters:
    ///   - url: The URL component that will be set
    ///   - parameters: Values that will be added (optional)
    ///   - endpoint: Used to determine what HTTP request method will be used
    private static func setUrlRequest(url: inout URLComponents,
                                      parameters: [String: Any]? = nil,
                                      mediaData: Media? = nil,
                                      endpoint: NetworkConstants.Endpoint) -> URLRequest {
        
        var request = URLRequest(url: url.url ?? URL(fileURLWithPath: ""))
        request.httpMethod = setRequestMethod(forEndpoint: endpoint).rawValue
        let boundary = generateBoundary()
        if endpoint.includeBearerToken {
            request.addValue("Bearer \(networkAuthenticationModel?.jwt ?? "")", forHTTPHeaderField: "Authorization")
        }
        if mediaData != nil {
            //set content type
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.setValue(NetworkConstants.HeaderContentType.Value.applicationJSON.rawValue, forHTTPHeaderField: "Accept")
        }
        else {
            request.addValue(NetworkConstants.HeaderContentType.Value.applicationJSON.rawValue, forHTTPHeaderField: "Content-Type")
            request.addValue(NetworkConstants.HeaderContentType.Value.applicationJSON.rawValue, forHTTPHeaderField: "Accept")
        }
        
        if let realParams = parameters {
            
            if request.httpMethod == NetworkConstants.RequestMethod.post.rawValue || request.httpMethod == NetworkConstants.RequestMethod.put.rawValue {
                
                // set to httpBody (for POST)
                if mediaData != nil {
                    let dataBody = createDataBody(withParameters: parameters, media: mediaData, boundary: boundary)
                    request.httpBody = dataBody
                    request.addValue("\(dataBody.count)", forHTTPHeaderField: "content-length")
                } else {
                    let paramData = try? JSONSerialization.data(withJSONObject: realParams, options: .prettyPrinted)
                    request.httpBody = paramData
                }
            } else {
                
                // add to query items way (for not POST)
                var components = URLComponents(string: url.url?.absoluteString ?? "")
                
                components?.queryItems = realParams.map { (key, value) in
                    URLQueryItem(name: key, value: value as? String)
                }
                let replacingPlus = components?.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
                components?.percentEncodedQuery = replacingPlus
                request = URLRequest(url: components?.url ?? URL(fileURLWithPath: "") )
            }
        }
        if mediaData != nil {
            let dataBody = createDataBody(withParameters: parameters, media: mediaData, boundary: boundary)
            request.httpBody = dataBody
        }
        
        return request
        
    }
    
    // MARK: - Refresh user token
    
    /// - Note: This was a private method, but it will now be needed to refresh the token for the Skillr to complete session calls at a higher percentage when answered from either the lock screen or dead app.
    /// Refreshes the expired token that is stored for the logged in user
    ///  - Parameters: attempts - The number of times you want the method to retry requesting a updated token
    ///  - Returns: Bool - For success or failure
    static func refreshTokenMethod(withNumberOfAttempts attempts: Int,
                                   hasBeenRefreshed: @escaping (_ : Bool, _ : Error?) -> ()) {
        
        logger.info("Token has expired, attempting to refresh it \(attempts+1) time(s).", category: .network)
        
        self.endpointCall(endpoint: .refreshToken,
                          dataType: RefreshAuthenticationModel.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                
                switch completion {
                case .finished:
                    hasBeenRefreshed(true, nil)
                case .failure(let error):
                    
                    if attempts == 0 {
                        hasBeenRefreshed(false, error)
                    } else {
                        refreshTokenMethod(withNumberOfAttempts: attempts - 1) { tokenRefreshed, error in
                            hasBeenRefreshed(tokenRefreshed, error)
                        }
                    }
                    
                }
                
            }, receiveValue: { value in
                networkAuthenticationModel?.jwt = value.jwt
            })
            .store(in: &cancelables)
        
    }
    
    /// Recall entire API method only after a refresh token has been used to replace an expired jwt.
    ///  - Parameters: The same as the method [makeEndpointCall]
    ///  - Returns: Type requested and error if there is one
    private static func totalRecall<T: Decodable>(endpoint: NetworkConstants.Endpoint,
                                                  parameters: [String: Any]? = nil,
                                                  dataType: T.Type? = nil,
                                                  recalled: @escaping(_ : Bool, _ : T?, _ : Error?) -> Void) {
        
        NetworkManager.endpointCall(endpoint: endpoint,
                                    parameters: parameters,
                                    dataType: dataType)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                
                switch completion {
                case .finished:
                    print("")
                case .failure(let error):
                    recalled(false, NilModel.self as? T, error)
                }
                
            }, receiveValue: { value in
                recalled(true, value, nil)
            })
            .store(in: &cancelables)
        
    }
    
    // MARK: End refresh -
    
    /// func to create data and param body for multipart request.
    private static func createDataBody(withParameters params: [String: Any]?, media: Media?, boundary: String) -> Data {
        let lineBreak = "\r\n"
        let body = NSMutableData()
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)".data(using: .utf8)!)
                body.append("\(value as! String + lineBreak)".data(using: .utf8)!)
            }
        }
        
        if let media = media {
            /// loop in case we need an array later
            //      for photo in media {
            body.append("--\(boundary + lineBreak)".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(media.key)\"; filename=\"\(media.filename)\"\(lineBreak)".data(using: .utf8)!)
            body.append("Content-Type: \(media.mimeType) \(lineBreak + lineBreak)".data(using: .utf8)!)
            body.append(media.data)
        }
        body.append("\(lineBreak)--\(boundary)--\(lineBreak)" .data(using: .utf8)!)
        return body as Data
    }
    
    private static func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    // MARK: - Reachability
    
    /// Here is where the apps reachability will be checked before an API call is ran
    private static func checkReachability() {
//        if appEventsManager?.isConnectedToNetwork.value == false {
//            appEventsManager?.presentAlert.send((true, .network))
//        }
    }
}

extension NSMutableData {
    func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
