//
//  NetworkConstants.swift
//  LiveCheff
//
//  Created by Online Developer on 02/09/2022.
//

import Foundation

/// Constant values that will be used specifically for network calls and values
enum NetworkConstants {
    
    /// Keys for authenticated user token and backup refresh token
    enum AuthenticationKeys: String {
        case jwtKey = "jwtKey"
        case refreshJwtKey = "refreshJwtKey"
        case id = "idKey"
    }
    
    /// Product definition environment string constants
    struct ProductDefinition {
        static let domain = "http://meetapp.vigoroustechnologies.com/"
        
        /// - Note: These will be toggled between 'staging' and 'prod' once the app is setup for multiple environments
        
        enum AppDomain: String {
            case prod = "com.skillr.app"
            case staging = "com.skillr.staging.app"
            case development = "com.skillr.development.app"
        }
        
        enum BaseAPI: String {
            case userAPIsUrl = "https://api.vooconnect.com:9450/api/v1"
            case postsAPIsUrl = "https://api.vooconnect.com:9451/api/v1"
            case assetsAPIsUrl = "https://api.vooconnect.com:9452/api/v1"
            case getImageVideoBaseURL = "https://api.vooconnect.com:9452/uploads/"
            case getFilterBaseURL = "https://apis.argear.io/api/v3"
        }
        static let deviceType = "ios"
    }
    
    /// Request method values to determine call type
    enum RequestMethod: String {
        case options = "OPTIONS"
        case get = "GET"
        case head = "HEAD"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
        case trace = "TRACE"
        case connect = "CONNECT"
        case none = ""
    }
    
    /// API call request content type
    enum HeaderContentType {
        static let applicationContentTypeKey = "Content-Type"
        
        enum Value: String {
            case applicationJSON = "application/json"
            case webFormUrlEncoded = "application/x-www-form-urlencoded"
            case allValues = "application/json, text/plain, */*"
        }
    }
    
    /// Static request parameter keys
    enum RequestParamKey: String {
        case deviceToken
        case deviceType
    }
    
    /// API endpoints that will be used by the Network Manager
    enum Endpoint: CustomStringConvertible {
        
        /// Refresh auth token that is either expired or invalid: [.../app/refreshtoken]
        case refreshToken
        /// Get User Detail
        case userDetail
        /// Get User Stats
        case getUserStats
        /// Update User Location
        case updateUserLocation
        /// Follow User
        case follow
        /// Unfollow User
        case unfollow
        /// Remove Follower
        case removeFollower
        /// Get Posts
        case getPosts
        /// Get Bookmarked Posts
        case getBookmarkedPosts
        /// Get Favorite Posts
        case getFavoritePosts
        /// Get Private Posts
        case getPrivatePosts
        /// Get Followers
        case getFollowers
        /// Get Following
        case getFollowing
        /// Get Suggested Users
        case getSuggestedUsers
        /// Report User
        case reportUser
        /// Block User
        case blockUser
        /// Upload file
        case uploadFile
        /// Update Profile
        case updateProfile
        /// Find Users By Phone
        case findUsersByPhone
        /// Profile Viewed
        case profileViewed
        /// Get Profile Viewers
        case getProfileViewers
        
        case getFilterData
        
        /// Returns string values of the endpoint cases
        var value: String {
            switch self {
            case .refreshToken:
                return "/refreshtoken"
            case .userDetail:
                return "/user-detail"
            case .getUserStats:
                return "/get-user-stats"
            case .updateUserLocation:
                return "/update-user-location"
            case .follow:
                return "/follow"
            case .unfollow:
                return "/unfollow"
            case .removeFollower:
                return "/remove-follower"
            case .getPosts:
                return "/get-posts"
            case .getBookmarkedPosts:
                return "/get-bookmarked-posts"
            case .getFavoritePosts:
                return "/get-liked-posts"
            case .getPrivatePosts:
                return "/get-private-posts"
            case .getFollowers:
                return "/get-followers"
            case .getFollowing:
                return "/get-followings"
            case .getSuggestedUsers:
                return "/get-suggested-users"
            case .reportUser:
                return "/report-abuse-user"
            case .blockUser:
                return "/block-user"
            case .uploadFile:
                return "/upload-file"
            case .updateProfile:
                return "/update-user-profile"
            case .findUsersByPhone:
                return "/find-users-by-phone"
            case .profileViewed:
                return "/profile-viewed"
            case .getProfileViewers:
                return "/get-profile-viewers"
            case .getFilterData:
                return "/605d8f982a3b640e638894d0?dev=true"
            }
        }
        
        var description: String{
            switch self {
            case .refreshToken:
                return "Referesh a token"
            case .userDetail:
                return "Get User Detail"
            case .getUserStats:
                return "Get User Stats"
            case .updateUserLocation:
                return "Update User Location"
            case .follow:
                return "Follow User"
            case .unfollow:
                return "Unfollow User"
            case .removeFollower:
                return "Remove Follower"
            case .getPosts:
                return "Get Posts"
            case .getBookmarkedPosts:
                return "Get Bookmarked Posts"
            case .getFavoritePosts:
                return "Get Favorite Posts"
            case .getPrivatePosts:
                return "Get Private Posts"
            case .getFollowers:
                return "Get Followers"
            case .getFollowing:
                return "Get Following"
            case .getSuggestedUsers:
                return "Get Suggested Users"
            case .reportUser:
                return "Report Abused User"
            case .blockUser:
                return "Block User"
            case .uploadFile:
                return "Upload File"
            case .updateProfile:
                return "Update Profile"
            case .findUsersByPhone:
                return "Find Users By Phone"
            case .profileViewed:
                return "Profile Viewed by Current User"
            case .getProfileViewers:
                return "Get Profile Viewers"
            case .getFilterData:
                return "Get Filter Data"
            }
        }
        
        /// Let request method know to include bearer token in current endpoint call
        var includeBearerToken: Bool {
            switch self {
            case .refreshToken:
                return false
            default:
                return true
            }
        }
        
        /// Get baseUrl for endpoints
        var getBaseUrl: String{
            switch self{
            case .getPosts,
                    .getBookmarkedPosts,
                    .getFavoritePosts,
                    .getFollowers,
                    .getFollowing,
                    .getSuggestedUsers,
                    .getUserStats,
                    .getPrivatePosts:
                return ProductDefinition.BaseAPI.postsAPIsUrl.rawValue
            case .uploadFile:
                return ProductDefinition.BaseAPI.assetsAPIsUrl.rawValue
            case .getFilterData:
                return ProductDefinition.BaseAPI.getFilterBaseURL.rawValue
            default:
                return ProductDefinition.BaseAPI.userAPIsUrl.rawValue
            }
        }
    }
    
}
