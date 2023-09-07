//
//  ReelsLikeViewModel.swift
//  Vooconnect
//
//  Created by Vooconnect on 17/12/22.
//

import Foundation

struct ReelsLikeDataModel {
    
    var userUUID: String = ""
    var postID: Int = 0
    var reactionType: Int = 0
    
}

struct BlockPostDataModel {
    
    var uuid: String = ""
    var postID: Int = 0
    
    var successMessage: String = String()
    var isPresentingSuccess: Bool = false
    
}

struct AbuseReportPostDataModel {
    
    var uuid: String = ""
    var postID: Int = 0
    
    var successMessage: String = String()
    var isPresentingSuccess: Bool = false
    
}

struct BookMarkDataModel {
    
    var userUUID: String = ""
    var postID: Int = 0
    
    var successMessage: String = String()
    var isPresentingSuccess: Bool = false
    
}

struct CommentDataModel {
    
    var userUUID: String = ""
    var postID: Int = 0
    var commentText: String = ""
    var replyText: String = ""
    var replyToCommentId: Int = 0
    var showEmoji: Bool = false
    var showAtTheRate: Bool = false
    
}


class ReelsLikeViewModel: ObservableObject {
    
    @Published var reelsLikeDataModel: ReelsLikeDataModel = ReelsLikeDataModel()
    @Published var blockPostDataModel: BlockPostDataModel = BlockPostDataModel()
    @Published var abuseReportPostDataModel: AbuseReportPostDataModel = AbuseReportPostDataModel()
    @Published var bookMarkDataModel: BookMarkDataModel = BookMarkDataModel()
    @Published var commentDataModel: CommentDataModel = CommentDataModel()
    @Published var postComments: [CommentResponse] = []
        @Published var interestCategory: [InterestCateg] = []
        @Published var userInterestCategory: [UserInterestCateg] = []
    
    private let reelsLikeResource = ReelsLikeResource()
    
    init(){
            fetchCommentsApi()
            fetchInterestCategoryApi()
            fetchUICategoryApi()
        }
    
    func reelsLikeApi(reactionType: Int, postID: Int) {
        
        let uuid = UserDefaults.standard.string(forKey: "uuid") ?? ""
        
        let request = LikeRequest(user_uuid: uuid, post_id: postID, reaction_type: reactionType)
        
        print("REQUEST=========",request)
        
        reelsLikeResource.hittingLikeApi(likeRequest: request) { isSuccess, sussesMessage in
            if isSuccess {
                DispatchQueue.main.async {
                    print("Success=========")
                    
                }
                
            } else {
                DispatchQueue.main.async {
                    print("Faileur===========")
                    
                }
                
            }
        }
        
    }
    func reelsReactionApi(reactionType: Int, postID: Int) {
        
        let uuid = UserDefaults.standard.string(forKey: "uuid") ?? ""
        
        let request = LikeRequest(user_uuid: uuid, post_id: postID, reaction_type: reactionType)
        
        print("REQUEST=========",request)
        
        reelsLikeResource.hittingReactionApi(likeRequest: request) { isSuccess, sussesMessage in
            if isSuccess {
                DispatchQueue.main.async {
                    print("Success=========")
                    
                }
                
            } else {
                DispatchQueue.main.async {
                    print("Faileur===========")
                    
                }
                
            }
        }
        
    }
    
    func blockUserApi() {  // postID
        
        let uuid = UserDefaults.standard.string(forKey: "uuid") ?? ""
        let user_uuid = UserDefaults.standard.string(forKey: "user_uuid") ?? ""
        
        let request = BlockUserRequest(uuid: uuid, user_uuid: user_uuid)
        
        print("REQUEST=========",request)
        
            reelsLikeResource.hittingBlockUserApi(blockUserRequest: request) { isSuccess, sussesMessage in
            if isSuccess {
                DispatchQueue.main.async {
                    print("Success=========")
                    
                    self.blockPostDataModel.isPresentingSuccess = true
                    self.blockPostDataModel.successMessage = sussesMessage ?? ""
                    
//                    likeVM.blockPostDataModel.isPresentingSuccess
                }
                
            } else {
                DispatchQueue.main.async {
                    print("Faileur===========")
                    
                }
                
            }
        }
        
    }
    func blockPostApi() {  // postID
        
        let uuid = UserDefaults.standard.string(forKey: "uuid") ?? ""
        let postID = UserDefaults.standard.integer(forKey: "postID")
        
        let request = BlockPostRequest(uuid: uuid, post_id: postID)
        
        print("REQUEST=========",request)
        
        reelsLikeResource.hittingBlockPostApi(blockPostRequest: request) { isSuccess, sussesMessage in
            if isSuccess {
                DispatchQueue.main.async {
                    print("Success=========")
                    
                    self.blockPostDataModel.isPresentingSuccess = true
                    self.blockPostDataModel.successMessage = sussesMessage ?? ""
                    
//                    likeVM.blockPostDataModel.isPresentingSuccess
                }
                
            } else {
                DispatchQueue.main.async {
                    print("Faileur===========")
                    
                }
                
            }
        }
        
    }
    
    func abuseReportPostApi(desc: String) {
        
        let uuid = UserDefaults.standard.string(forKey: "uuid") ?? ""
        let postID = UserDefaults.standard.integer(forKey: "postID")
        
        let request = ReportPostRequest(uuid: uuid, post_id: postID, description: desc)
        
        print("REQUEST=========",request)
        
        reelsLikeResource.hittingAbuseReportPostApi(abusePostRequest: request) {  isSuccess, sussesMessage in
            if isSuccess {
                DispatchQueue.main.async {
                    print("Success=========")
                    
                    self.abuseReportPostDataModel.successMessage = sussesMessage ?? ""
                    
                }
                
            } else {
                DispatchQueue.main.async {
                    print("Faileur===========")
                    
                }
                
            }
        }
        
    }
    
    func bookMarkApi() {
        
        let uuid = UserDefaults.standard.string(forKey: "uuid") ?? ""
//        let postID = UserDefaults.standard.integer(forKey: "postID")
//
        let request = BookMarkRequest(user_uuid: uuid, post_id: bookMarkDataModel.postID)
        
        print("REQUEST=========",request)
        
        reelsLikeResource.hittingBookMarkApi(bookMarkRequest: request) { isSuccess, sussesMessage in
            if isSuccess {
                DispatchQueue.main.async {
                    print("Success=========")
                    
                    self.bookMarkDataModel.isPresentingSuccess = true
                    self.bookMarkDataModel.successMessage = sussesMessage ?? ""
                    
//                    likeVM.blockPostDataModel.isPresentingSuccess
                }
                
            } else {
                DispatchQueue.main.async {
                    print("Faileur===========")
                    
                }
                
            }
        }
        
    }
    
    func commentApi() {
            
            let uuid = UserDefaults.standard.string(forKey: "uuid") ?? ""
            let postID = UserDefaults.standard.integer(forKey: "postID")
            
            let request = CommentRequest(user_uuid: uuid, post_id: postID, comment: commentDataModel.commentText)
            
            print("REQUEST=========",request)
            
            reelsLikeResource.hittingCommentApi(commentRequest: request) { isSuccess, sussesMessage in
                if isSuccess {
                    DispatchQueue.main.async {
                        print("Success=========")
                        
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        print("Faileur===========")
                        
                    }
                    
                }
            }
            
        }
        
    func followApi(user_uuid: String) {
            
            let uuid = UserDefaults.standard.string(forKey: "uuid") ?? ""
//            let postID = UserDefaults.standard.integer(forKey: "postID")
            
            let request = FollowRequest(user_uuid: uuid, uuid: user_uuid)
            
            print("REQUEST=========",request)
            
            reelsLikeResource.hittingFollowApi(followRequest: request) { isSuccess, sussesMessage in
                if isSuccess {
                    DispatchQueue.main.async {
                        print("Success=========")
                        
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        print("Faileur===========")
                        
                    }
                    
                }
            }
            
        }
    func unFollowApi(user_uuid: String) {
            
            let uuid = UserDefaults.standard.string(forKey: "uuid") ?? ""
//            let postID = UserDefaults.standard.integer(forKey: "postID")
            
            let request = FollowRequest(user_uuid: uuid, uuid: user_uuid)
            
            print("REQUEST=========",request)
            
            reelsLikeResource.hittingUnFollowApi(followRequest: request) { isSuccess, sussesMessage in
                if isSuccess {
                    DispatchQueue.main.async {
                        print("Success=========")
                        
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        print("Faileur===========")
                        
                    }
                    
                }
            }
            
        }
        
    func replyToCommentApi(commentId: Int) {
            
            let uuid = UserDefaults.standard.string(forKey: "uuid") ?? ""
            let postID = UserDefaults.standard.integer(forKey: "postID")
            

            let request = ReplyToCommentRequest(user_uuid: uuid, post_id: postID, comment: commentDataModel.replyText, reply_to_comment_id: commentId)
            
            print("REQUEST=========",request)
            
            reelsLikeResource.hittingReplyToCommentApi(replyToCommentRequest: request) { isSuccess, sussesMessage in
                if isSuccess {
                    DispatchQueue.main.async {
                        print("Success=========")
                        
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        print("Faileur===========")
                        
                    }
                    
                }
            }
            
        }
        
    func replyToReplyApi(commentId: Int, reply_to_reply: String) {
            
            let uuid = UserDefaults.standard.string(forKey: "uuid") ?? ""
            let postID = UserDefaults.standard.integer(forKey: "postID")
            

            let request = ReplyToReplyRequest(user_uuid: uuid, post_id: postID, comment: commentDataModel.replyText, reply_to_comment_id: commentId, reply_to_reply: reply_to_reply)
            
            print("REQUEST=========",request)
            
            reelsLikeResource.hittingReplyToReplyApi(replyToReplyRequest: request) { isSuccess, sussesMessage in
                if isSuccess {
                    DispatchQueue.main.async {
                        print("Success=========")
                        
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        print("Faileur===========")
                        
                    }
                    
                }
            }
            
        }
        
    func fetchCommentsApi() {
            
            let urlRequest = URLRequest(url: URL(string: getBaseURL + EndPoints.comments)!)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    print("Request error: ", error)
                    return
                }

                guard let response = response as? HTTPURLResponse else { return }

                if response.statusCode == 200 {
                    guard let data = data else { return }
                    DispatchQueue.main.async {
                        do {
                            let decodedComments = try JSONDecoder().decode([CommentResponse].self, from: data)
                    
                            self.postComments = decodedComments
                        } catch let error {
                            print("Error decoding: ", error)
                        }
                    }
                }
            }

            dataTask.resume()
            
        }
        
    func fetchInterestCategoryApi() {
            
            let urlRequest = URLRequest(url: URL(string: getBaseURL + EndPoints.interest_categ)!)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    print("Request error: ", error)
                    return
                }

                guard let response = response as? HTTPURLResponse else { return }

                if response.statusCode == 200 {
                    guard let data = data else { return }
                    DispatchQueue.main.async {
                        do {
                            let decodedCategories = try JSONDecoder().decode([InterestCateg].self, from: data)
                    
                            self.interestCategory = decodedCategories
                        } catch let error {
                            print("Error decoding: ", error)
                        }
                    }
                }
            }

            dataTask.resume()
            
        }
        
    func fetchUICategoryApi() {
            
            let urlRequest = URLRequest(url: URL(string: getBaseURL + EndPoints.user_interest_categ)!)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    print("Request error: ", error)
                    return
                }

                guard let response = response as? HTTPURLResponse else { return }

                if response.statusCode == 200 {
                    guard let data = data else { return }
                    DispatchQueue.main.async {
                        do {
                            let decodedUICategories = try JSONDecoder().decode([UserInterestCateg].self, from: data)
                    
                            self.userInterestCategory = decodedUICategories
                        } catch let error {
                            print("Error decoding: ", error)
                        }
                    }
                }
            }

            dataTask.resume()
            
        }
    
}
