//
//  ReelsLikeResource.swift
//  Vooconnect
//
//  Created by Vooconnect on 17/12/22.
// commentRequest

import Foundation

class ReelsLikeResource {
    
    func hittingReactionApi(likeRequest: LikeRequest, complitionHandler : @escaping(Bool, String?) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string: getBaseURL + EndPoints.reaction)!)
                
        urlRequest.httpMethod = "post"
//        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.httpBody = try? JSONEncoder().encode(likeRequest)
        
        if let tokenData = UserDefaults.standard.string(forKey: "accessToken") {
            urlRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(tokenData)"]
            urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
            print("Access Token============",tokenData)
        }
        
        
        
        HttpUtility.shared.postApiData(request: urlRequest) { result in
            
            switch result  {
            case .success(let response) :
                
                do {
                    let data : [String:Any] = try JSONSerialization.jsonObject(with: response, options: .mutableContainers) as! [String : Any]
                    
                    debugPrint("The LOGIN Response", data)
                    
                    if data["status"] as! Int == 1 {
                        // Sussess
                        print("Susses===========")

//                       if let records = data["data"] as? [String: Any] {
//
//                           let uuid = records["uuid"] as? String
//                           UserDefaults.standard.set(uuid, forKey: "uuid")
//                           print("THE UUID is======", uuid ?? "not save")
//                        }

                        complitionHandler(true, "Susses")

                    } else {
                        print("Failed===========")
                        complitionHandler(false, "Failed")
                    }

                } catch {
                    complitionHandler(false, nil)
                    print("sakdjfhiuldasfhiuearf")
                }
                
            case .failure(let error) :
                debugPrint("The Error =====", error.localizedDescription)
            }
            
        }
        
    }
    func hittingLikeApi(likeRequest: LikeRequest, complitionHandler : @escaping(Bool, String?) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string: getBaseURL + EndPoints.like)!)
                
        urlRequest.httpMethod = "post"
//        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.httpBody = try? JSONEncoder().encode(likeRequest)
        
        if let tokenData = UserDefaults.standard.string(forKey: "accessToken") {
            urlRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(tokenData)"]
            urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
            print("Access Token============",tokenData)
        }
        
        
        
        HttpUtility.shared.postApiData(request: urlRequest) { result in
            
            switch result  {
            case .success(let response) :
                
                do {
                    let data : [String:Any] = try JSONSerialization.jsonObject(with: response, options: .mutableContainers) as! [String : Any]
                    
                    debugPrint("The LOGIN Response", data)
                    
                    if data["status"] as! Int == 1 {
                        // Sussess
                        print("Susses===========")

//                       if let records = data["data"] as? [String: Any] {
//
//                           let uuid = records["uuid"] as? String
//                           UserDefaults.standard.set(uuid, forKey: "uuid")
//                           print("THE UUID is======", uuid ?? "not save")
//                        }

                        complitionHandler(true, "Susses")

                    } else {
                        print("Failed===========")
                        complitionHandler(false, "Failed")
                    }

                } catch {
                    complitionHandler(false, nil)
                    print("sakdjfhiuldasfhiuearf")
                }
                
            case .failure(let error) :
                debugPrint("The Error =====", error.localizedDescription)
            }
            
        }
        
    }
    
    func hittingBlockPostApi(blockPostRequest: BlockPostRequest, complitionHandler : @escaping(Bool, String?) -> Void) {
            
            var urlRequest = URLRequest(url: URL(string: getBaseURL + EndPoints.blockPost)!)
            
            urlRequest.httpMethod = "post"
            //        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
            urlRequest.httpBody = try? JSONEncoder().encode(blockPostRequest)
            
            if let tokenData = UserDefaults.standard.string(forKey: "accessToken") {
                urlRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(tokenData)"]
                urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
                //            print("Access Token============",tokenData)
            }
            
            
            
            HttpUtility.shared.postApiData(request: urlRequest) { result in
                
                switch result  {
                case .success(let response) :
                    
                    do {
                        let data : [String:Any] = try JSONSerialization.jsonObject(with: response, options: .mutableContainers) as! [String : Any]
                        
                        debugPrint("The LOGIN Response", data)
                        
                        if data["status"] as! Int == 1 {
                            // Sussess
                            print("Susses===========")
                            
                            //                       if let records = data["data"] as? [String: Any] {
                            //
                            //                           let uuid = records["uuid"] as? String
                            //                           UserDefaults.standard.set(uuid, forKey: "uuid")
                            //                           print("THE UUID is======", uuid ?? "not save")
                            //                        }
                            
                            
                            complitionHandler(true, "Block sent.")
                            
                        } else {
                            print("Failed===========")
                            complitionHandler(false, "Failed")
                        }
                        
                    } catch {
                        complitionHandler(false, nil)
                        print("sakdjfhiuldasfhiuearf")
                    }
                    
                case .failure(let error) :
                    debugPrint("The Error =====", error.localizedDescription)
                }
                
            }
            
        }
    func hittingBlockUserApi(blockUserRequest: BlockUserRequest, complitionHandler : @escaping(Bool, String?) -> Void) {
            
            var urlRequest = URLRequest(url: URL(string: baseURL + EndPoints.blockUser)!)
            
            urlRequest.httpMethod = "post"
            //        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
            urlRequest.httpBody = try? JSONEncoder().encode(blockUserRequest)
            
            if let tokenData = UserDefaults.standard.string(forKey: "accessToken") {
                urlRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(tokenData)"]
                urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
                //            print("Access Token============",tokenData)
            }
            
            
            
            HttpUtility.shared.postApiData(request: urlRequest) { result in
                
                switch result  {
                case .success(let response) :
                    
                    do {
                        let data : [String:Any] = try JSONSerialization.jsonObject(with: response, options: .mutableContainers) as! [String : Any]
                        
                        debugPrint("The LOGIN Response", data)
                        
                        if data["status"] as! Int == 1 {
                            // Sussess
                            print("Susses===========")
                            
                            //                       if let records = data["data"] as? [String: Any] {
                            //
                            //                           let uuid = records["uuid"] as? String
                            //                           UserDefaults.standard.set(uuid, forKey: "uuid")
                            //                           print("THE UUID is======", uuid ?? "not save")
                            //                        }
                            
                            
                            complitionHandler(true, "Block sent.")
                            
                        } else {
                            print("Failed===========")
                            complitionHandler(false, "Failed")
                        }
                        
                    } catch {
                        complitionHandler(false, nil)
                        print("sakdjfhiuldasfhiuearf")
                    }
                    
                case .failure(let error) :
                    debugPrint("The Error =====", error.localizedDescription)
                }
                
            }
            
        }
        
        func hittingAbuseReportPostApi(abusePostRequest: ReportPostRequest, complitionHandler : @escaping(Bool, String?) -> Void) {
            
            var urlRequest = URLRequest(url: URL(string: getBaseURL + EndPoints.abuseReportPost)!)
            
            urlRequest.httpMethod = "post"
            //        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
            urlRequest.httpBody = try? JSONEncoder().encode(abusePostRequest)
            
            if let tokenData = UserDefaults.standard.string(forKey: "accessToken") {
                urlRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(tokenData)"]
                urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
                //            print("Access Token============",tokenData)
            }
            
            
            
            HttpUtility.shared.postApiData(request: urlRequest) { result in
                
                switch result  {
                case .success(let response) :
                    
                    do {
                        let data : [String:Any] = try JSONSerialization.jsonObject(with: response, options: .mutableContainers) as! [String : Any]
                        
                        debugPrint("The LOGIN Response", data)
                        
                        if data["status"] as! Int == 1 {
                            // Sussess
                            print("Susses===========")
                            
                            //                       if let records = data["data"] as? [String: Any] {
                            //
                            //                           let uuid = records["uuid"] as? String
                            //                           UserDefaults.standard.set(uuid, forKey: "uuid")
                            //                           print("THE UUID is======", uuid ?? "not save")
                            //                        } bookMarkSuccesResponse
                            
                            
                            complitionHandler(true, "Abuse report sent.")
                            
                        } else {
                            print("Failed===========")
                            complitionHandler(false, "Failed")
                        }
                        
                    } catch {
                        complitionHandler(false, nil)
                        print("sakdjfhiuldasfhiuearf")
                    }
                    
                case .failure(let error) :
                    debugPrint("The Error =====", error.localizedDescription)
                }
                
            }
            
        }
    
    func hittingBookMarkApi(bookMarkRequest: BookMarkRequest, complitionHandler : @escaping(Bool, String?) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string: getBaseURL + EndPoints.bookMark)!)
        
        urlRequest.httpMethod = "post"
        
        urlRequest.httpBody = try? JSONEncoder().encode(bookMarkRequest)
        
        if let tokenData = UserDefaults.standard.string(forKey: "accessToken") {
            urlRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(tokenData)"]
            urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
            print("Access Token============",tokenData)
        }
        
        
        HttpUtility.shared.postApiData(request: urlRequest) { result in
            
            switch result  {
            case .success(let response) :
                
                do {
                    let data : [String:Any] = try JSONSerialization.jsonObject(with: response, options: .mutableContainers) as! [String : Any]
                    
                    debugPrint("The Book mark Response", data)
                    
                    if data["status"] as! Int == 1 {
                        // Sussess
                        print("Susses===========")
                        
                        do {
                            let decodData = try JSONDecoder().decode(bookMarkSuccesResponse.self, from: response)
                            
                            complitionHandler(true, decodData.message ?? "")
                            
                        } catch {
                            debugPrint("The Error", error.localizedDescription)
                        }
                        
                        

//                        complitionHandler(true, "Susses")

                    } else {
                        print("Failed===========")
                        complitionHandler(false, "Failed")
                    }

                } catch {
                    complitionHandler(false, nil)
                    print("sakdjfhiuldasfhiuearf")
                }
                
            case .failure(let error) :
                debugPrint("The Error =====", error.localizedDescription)
            }
            
        }
        
        
    }
    
    func hittingCommentApi(commentRequest: CommentRequest, complitionHandler : @escaping(Bool, String?) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string: getBaseURL + EndPoints.comment)!)
                
        urlRequest.httpMethod = "post"
//        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.httpBody = try? JSONEncoder().encode(commentRequest)
        
        if let tokenData = UserDefaults.standard.string(forKey: "accessToken") {
            urlRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(tokenData)"]
            urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
            print("Access Token============",tokenData)
        }
        
        
        HttpUtility.shared.postApiData(request: urlRequest) { result in
            
            switch result  {
            case .success(let response) :
                
                do {
                    let data : [String:Any] = try JSONSerialization.jsonObject(with: response, options: .mutableContainers) as! [String : Any]
                    
                    debugPrint("The LOGIN Response", data)
                    
                    if data["status"] as! Int == 1 {
                        // Sussess
                        print("Susses===========")

//                       if let records = data["data"] as? [String: Any] {
//
//                           let uuid = records["uuid"] as? String
//                           UserDefaults.standard.set(uuid, forKey: "uuid")
//                           print("THE UUID is======", uuid ?? "not save")
//                        }


                        complitionHandler(true, "Susses")

                    } else {
                        print("Failed===========")
                        complitionHandler(false, "Failed")
                    }

                } catch {
                    complitionHandler(false, nil)
                    print("sakdjfhiuldasfhiuearf")
                }
                
            case .failure(let error) :
                debugPrint("The Error =====", error.localizedDescription)
            }
            
        }
        
    }
    
    func hittingUnFollowApi(followRequest: FollowRequest, complitionHandler : @escaping(Bool, String?) -> Void) {
           
           var urlRequest = URLRequest(url: URL(string: baseURL + EndPoints.unFollow)!)
           
           urlRequest.httpMethod = "post"
           //        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
           urlRequest.httpBody = try? JSONEncoder().encode(followRequest)
           
           if let tokenData = UserDefaults.standard.string(forKey: "accessToken") {
               urlRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(tokenData)"]
               urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
               print("Access Token============",tokenData)
           }
           print("URL Request============",urlRequest)
           
           HttpUtility.shared.postApiData(request: urlRequest) { result in
               
               switch result  {
               case .success(let response) :
                   
                   do {
                       let data : [String:Any] = try JSONSerialization.jsonObject(with: response, options: .mutableContainers) as! [String : Any]
                       
                       debugPrint("The LOGIN Response", data)
                       
                       if data["status"] as! Int == 1 {
                           // Sussess
                           print("Susses===========")
                           
                           //                       if let records = data["data"] as? [String: Any] {
                           //
                           //                           let uuid = records["uuid"] as? String
                           //                           UserDefaults.standard.set(uuid, forKey: "uuid")
                           //                           print("THE UUID is======", uuid ?? "not save")
                           //                        }
                           
                           
                           complitionHandler(true, "Susses")
                           
                       } else {
                           print("Failed===========")
                           complitionHandler(false, "Failed")
                       }
                       
                   } catch {
                       complitionHandler(false, nil)
                       print("sakdjfhiuldasfhiuearf")
                   }
                   
               case .failure(let error) :
                   debugPrint("The Error =====", error.localizedDescription)
               }
               
           }
           
       }
    func hittingFollowApi(followRequest: FollowRequest, complitionHandler : @escaping(Bool, String?) -> Void) {
           
           var urlRequest = URLRequest(url: URL(string: baseURL + EndPoints.follow)!)
           
           urlRequest.httpMethod = "post"
           //        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
           urlRequest.httpBody = try? JSONEncoder().encode(followRequest)
           
           if let tokenData = UserDefaults.standard.string(forKey: "accessToken") {
               urlRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(tokenData)"]
               urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
               print("Access Token============",tokenData)
           }
           print("URL Request============",urlRequest)
           
           HttpUtility.shared.postApiData(request: urlRequest) { result in
               
               switch result  {
               case .success(let response) :
                   
                   do {
                       let data : [String:Any] = try JSONSerialization.jsonObject(with: response, options: .mutableContainers) as! [String : Any]
                       
                       debugPrint("The LOGIN Response", data)
                       
                       if data["status"] as! Int == 1 {
                           // Sussess
                           print("Susses===========")
                           
                           //                       if let records = data["data"] as? [String: Any] {
                           //
                           //                           let uuid = records["uuid"] as? String
                           //                           UserDefaults.standard.set(uuid, forKey: "uuid")
                           //                           print("THE UUID is======", uuid ?? "not save")
                           //                        }
                           
                           
                           complitionHandler(true, "Susses")
                           
                       } else {
                           print("Failed===========")
                           complitionHandler(false, "Failed")
                       }
                       
                   } catch {
                       complitionHandler(false, nil)
                       print("sakdjfhiuldasfhiuearf")
                   }
                   
               case .failure(let error) :
                   debugPrint("The Error =====", error.localizedDescription)
               }
               
           }
           
       }
    
//    func hittingFolowingApi
       
    func hittingReplyToCommentApi(replyToCommentRequest: ReplyToCommentRequest, complitionHandler : @escaping(Bool, String?) -> Void) {
           
           var urlRequest = URLRequest(url: URL(string: getBaseURL + EndPoints.replyToComment)!)
           
           urlRequest.httpMethod = "post"
           //        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
           urlRequest.httpBody = try? JSONEncoder().encode(replyToCommentRequest)
           
           if let tokenData = UserDefaults.standard.string(forKey: "accessToken") {
               urlRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(tokenData)"]
               urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
               print("Access Token============",tokenData)
           }
           print("URL Request============",urlRequest)
           
           HttpUtility.shared.postApiData(request: urlRequest) { result in
               
               switch result  {
               case .success(let response) :
                   
                   do {
                       let data : [String:Any] = try JSONSerialization.jsonObject(with: response, options: .mutableContainers) as! [String : Any]
                       
                       debugPrint("The LOGIN Response", data)
                       
                       if data["status"] as! Int == 1 {
                           // Sussess
                           print("Susses===========")
                           
                           //                       if let records = data["data"] as? [String: Any] {
                           //
                           //                           let uuid = records["uuid"] as? String
                           //                           UserDefaults.standard.set(uuid, forKey: "uuid")
                           //                           print("THE UUID is======", uuid ?? "not save")
                           //                        }
                           
                           
                           complitionHandler(true, "Susses")
                           
                       } else {
                           print("Failed===========")
                           complitionHandler(false, "Failed")
                       }
                       
                   } catch {
                       complitionHandler(false, nil)
                       print("sakdjfhiuldasfhiuearf")
                   }
                   
               case .failure(let error) :
                   debugPrint("The Error =====", error.localizedDescription)
               }
               
           }
           
       }
       
    func hittingReplyToReplyApi(replyToReplyRequest: ReplyToReplyRequest, complitionHandler : @escaping(Bool, String?) -> Void) {
           
           var urlRequest = URLRequest(url: URL(string: getBaseURL + EndPoints.replyToComment)!)
           
           urlRequest.httpMethod = "post"
           //        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
           urlRequest.httpBody = try? JSONEncoder().encode(replyToReplyRequest)
           
           if let tokenData = UserDefaults.standard.string(forKey: "accessToken") {
               urlRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(tokenData)"]
               urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
               print("Access Token============",tokenData)
           }
           print("URL Request============",urlRequest)
           
           HttpUtility.shared.postApiData(request: urlRequest) { result in
               
               switch result  {
               case .success(let response) :
                   
                   do {
                       let data : [String:Any] = try JSONSerialization.jsonObject(with: response, options: .mutableContainers) as! [String : Any]
                       
                       debugPrint("The LOGIN Response", data)
                       
                       if data["status"] as! Int == 1 {
                           // Sussess
                           print("Susses===========")
                           
                           //                       if let records = data["data"] as? [String: Any] {
                           //
                           //                           let uuid = records["uuid"] as? String
                           //                           UserDefaults.standard.set(uuid, forKey: "uuid")
                           //                           print("THE UUID is======", uuid ?? "not save")
                           //                        }
                           
                           
                           complitionHandler(true, "Susses")
                           
                       } else {
                           print("Failed===========")
                           complitionHandler(false, "Failed")
                       }
                       
                   } catch {
                       complitionHandler(false, nil)
                       print("sakdjfhiuldasfhiuearf")
                   }
                   
               case .failure(let error) :
                   debugPrint("The Error =====", error.localizedDescription)
               }
               
           }
           
       }
}
