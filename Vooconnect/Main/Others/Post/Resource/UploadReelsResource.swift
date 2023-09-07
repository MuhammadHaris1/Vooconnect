//
//  UploadReelsResource.swift
//  Vooconnect
//
//  Created by Vooconnect on 12/12/22.
//

import Foundation
import UIKit

class UploadReelsResource {
    
    func uploadReels(imageUploadRequest: URL,paramName : String, fileName : String, subtitleLang : String, subtitle_apply : String,  complitionHandler : @escaping(Bool, String?) -> Void) {
        let session = URLSession.shared
        let boundary = UUID().uuidString
        var data = Data()

        var urlRequest = URLRequest(url: URL(string: assatEndPoint + EndPoints.uploadFile)!)
        urlRequest.httpMethod = "post"

        if let fileData = try? Data(contentsOf: imageUploadRequest) {
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)

            data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: video/mp4\r\n\r\n".data(using: .utf8)!)
            data.append(fileData)

            // Add subtitle_apply parameter
             data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
             data.append("Content-Disposition: form-data; name=\"subtitle_apply\"\r\n".data(using: .utf8)!)
             data.append("\r\n\(subtitle_apply)\r\n".data(using: .utf8)!)

             // Add subtitleLang parameter
             data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
             data.append("Content-Disposition: form-data; name=\"subtitleLang\"\r\n".data(using: .utf8)!)
             data.append("\r\n\(subtitleLang)\r\n".data(using: .utf8)!)

             data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        }


        if let tokenData = UserDefaults.standard.string(forKey: "accessToken") {

            urlRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(tokenData)"]
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "content-type")

            print("ACCESS TOKEN=========", tokenData)
            print(String(data: data, encoding: .utf8) ?? "")

        }

        session.uploadTask(with: urlRequest, from: data) { httpData, httpResponse, httpError in
//            print(String(data: httpData!, encoding: .utf8)!)
            if let data = httpData {

                do {
                            let data = try? JSONDecoder().decode(UploadRes.self, from: data)
                    if let data {
                        if data.status == true {
                            print(data.data)
                            let name = data.data.first?.name ?? ""
                            UserDefaults.standard.set(name, forKey: "imageName")

                            let size = data.data.first?.size ?? ""
                            UserDefaults.standard.set(size, forKey: "reelSize")

                            let reelsName = UserDefaults.standard.string(forKey: "imageName") ?? ""
                            print("THE reelsName is======", reelsName )

                            let reelsSize = UserDefaults.standard.string(forKey: "reelSize") ?? ""
                            print("THE reelsSize is=======", reelsSize)
                            complitionHandler(true, "done")
                        }
                    }else{
                        complitionHandler(false, httpError?.localizedDescription)
                    }
                } catch {
                    debugPrint("Error in decoding the model")
                    complitionHandler(false, "Please login first")
                }

            } else if let resposne = httpResponse {
            } else {
                print("Error: \(httpError?.localizedDescription)")
                complitionHandler(false, httpError?.localizedDescription)
                print("ther error")
            }
        }.resume()
    }
    
    func uploadPost(post: ReelsPostRequest, complitionHandler : @escaping(Bool, String?) -> Void) {
        let parameters = post.dict
        let postData = try? JSONSerialization.data(
            withJSONObject: parameters,
            options: [])

        var request = URLRequest(url: URL(string: getBaseURL + EndPoints.createNewPost)!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let tokenData = UserDefaults.standard.string(forKey: "accessToken") {
            request.addValue("Bearer \(tokenData)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            do {
                let res = try JSONDecoder().decode(PostRes.self, from: data)
                if res.status == true {
                    complitionHandler(true, "")
                }else{
                    complitionHandler(false, error?.localizedDescription)
                }
            }catch {
                print(error.localizedDescription)
            }
        }

        task.resume()
    }
    
}

struct UploadRes: Codable {
    let status: Bool
    let data: [Datum]
}

struct Datum: Codable {
    let name, size: String
}

struct PostRes: Codable {
    let status: Bool?
    let message: String?
}

func uploadCaption(imageUploadRequest: URL,paramName : String, fileName : String, complitionHandler : @escaping(Bool, String?) -> Void) {
    let session = URLSession.shared
    let boundary = UUID().uuidString
    var data = Data()
    
    let parameters : [String:Any]?
    parameters = ["upload_path" : "reels"]
    
    var urlRequest = URLRequest(url: URL(string: assatEndPoint + EndPoints.uploadFile)!)
    urlRequest.httpMethod = "post"

    if let fileData = try? Data(contentsOf: imageUploadRequest) {
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: video/mp4\r\n\r\n".data(using: .utf8)!)
        data.append(fileData)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
    }
    
    
    if let tokenData = UserDefaults.standard.string(forKey: "accessToken") {
        
        urlRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(tokenData)"]
        urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "content-type")
        
        print("ACCESS TOKEN=========", tokenData)
        
    }
    
    session.uploadTask(with: urlRequest, from: data) { httpData, httpResponse, httpError in
        
        if let data = httpData {
            
            do {
                        let data = try? JSONDecoder().decode(UploadRes.self, from: data)
                if let data {
                    if data.status == true {
                        let name = data.data.first?.name ?? ""
                        UserDefaults.standard.set(name, forKey: "imageName")

                        let size = data.data.first?.size ?? ""
                        UserDefaults.standard.set(size, forKey: "reelSize")

                        let reelsName = UserDefaults.standard.string(forKey: "imageName") ?? ""
                        print("THE reelsName is======", reelsName )

                        let reelsSize = UserDefaults.standard.string(forKey: "reelSize") ?? ""
                        print("THE reelsSize is=======", reelsSize)
                        complitionHandler(true, "")
                    }
                }else{
                    complitionHandler(false, httpError?.localizedDescription)
                }
            } catch {
                debugPrint("Error in decoding the model")
                complitionHandler(false, "Please login first")
            }
            
        } else if let resposne = httpResponse {
            
        } else {
            print("ther error")
        }
        
    }.resume()
    
    
    
    
}
