//
//  ApiUrl.swift
//  Vooconnect
//
//  Created by Voconnect on 11/11/22.

import Foundation

//getBaseURL + EndPoints.reels)

//var baseURL = "https://api.vooconnect.com:9450/api/v1"
//var assatEndPoint = "https://api.vooconnect.com:9452/api/v1"
////var userApiEndPoint = "https://api.vooconnect.com:9452/api/v1"
//var userApiEndPoint = "https://vooconnectasset.devssh.xyz/api/v1"//3002
//var getBaseURL = "https://api.vooconnect.com:9451/api/v1"
//var getImageVideoBaseURL = "https://api.vooconnect.com:9452/uploads/"
//var getImageVideoMarkedBaseURL = "https://api.vooconnect.com:9452/uploads/marked"//3002
//
//
//

var baseURL = "https://vooconnectuser.devssh.xyz/api/v1"//3000
var assatEndPoint = "https://vooconnectasset.devssh.xyz/api/v1"//3002
var userApiEndPoint = "https://vooconnectasset.devssh.xyz/api/v1"//3002
var getBaseURL = "https://vooconnectpost.devssh.xyz/api/v1"//3001
var getImageVideoBaseURL = "https://vooconnectasset.devssh.xyz/uploads"//3002
var getImageVideoMarkedBaseURL = "https://vooconnectasset.devssh.xyz"//3002

struct EndPoints {
    
    static var signUpWithEmail = "/register-with-email"
    static var signUpWithPhone = "/register-with-phone"
    static var sendOTPtoMail = "/send-otp-to-email"
    static var sendOTPtoPhone = "/send-otp-to-phone"
    static var otp = "/verify-otp"
    
    static var logInWithEmail = "/login-with-email"
    static var logInWithPhone = "/login-with-phone"
    
    static var genderUpdate = "/update-gender"
    static var birthDay = "/update-birthdate"
    
    static var forgotPassword = "/forgot-password"
    static var createNewPassword = "/create-new-password"
    static var createNewPost = "/create-new-post"
    
    static var uploadProfileData = "/update-profile"
    
    static var uploadFile = "/upload-file"
    static var subtitles = "/lang-for-subtitles"
    static var updateInterestList = "/update-interest-list"
    static var postInterest = "/get-interest-list"
    
    static var reels = "/post-stream?page=1&post_type=recommended"
    
    static var uploadReels = "/create-new-post"
    
    static var like = "/like-unlike-post"
    static var reaction = "/change-like-reaction"
    static var blockPost = "/block-post"
    static var blockUser = "/block-user"
    static var abuseReportPost = "/report-abuse-post"
    static var bookMark = "/bookmark-post"
    static var comment = "/comment-on-post"
    static var follow = "/follow"
    static var unFollow = "/unfollow"
    static var followingList = "/following-list"
    static var followerList = "/follower-list"
    static var replyToComment = "/reply-to-comment"
    static var comments = "/comments"
    static var users = "/users"
    static var interest_categ = "/int_categ"
    static var user_interest_categ = "/user_int_categ"
    static var mention = "/search-username"
    
}
