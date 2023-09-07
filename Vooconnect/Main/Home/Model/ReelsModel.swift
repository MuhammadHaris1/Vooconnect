//
//  ReelsModel.swift
//  Vooconnect
//
//  Created by Vooconnect on 03/12/22.
//

import Foundation
import AVKit

// MARK: - Welcome
struct ReelsModel: Codable {
    let status: Bool?
    let data: ReelsData?
}

// MARK: - DataClass
struct ReelsData: Codable {
    let nextPage: Int?
    var player: AVPlayer?
    let posts: [Post]?

    enum CodingKeys: String, CodingKey {
        case nextPage = "next_page"
        case posts
    }
}

// MARK: - Post
struct Post: Codable, Hashable {
    let postID: Int?
    let title, postDescription: String?
    let location: String?
    let contentURL: String?
    let contentType: String?
    let musicTrack: String?
    let musicURL: String?
    let musicUUID: String?;
    let allowComment, allowDuet, allowStitch: String?
    let creatorUUID: String?
    let creatorFirstName, creatorLastName, creatorUsername, creatorProfileImage: String?
    let isBookmarked: Int
    let isLiked: Int
    let reactionType: Int?
    var likeCount, shareCount, bookmarkCount, commentCount: Int?
    var player: AVPlayer?

    enum CodingKeys: String, CodingKey {
        case postID = "post_id"
        case title
        case postDescription = "description"
        case location
        case contentURL = "content_url"
        case contentType = "content_type"
        case musicUUID = "music_uuid"
        case musicTrack = "music_track"
        case musicURL = "music_url"
        case allowComment = "allow_comment"
        case allowDuet = "allow_duet"
        case allowStitch = "allow_stitch"
        case creatorUUID = "creator_uuid"
        case creatorFirstName = "creator_first_name"
        case creatorLastName = "creator_last_name"
        case creatorUsername = "creator_username"
        case creatorProfileImage = "creator_profile_image"
        case isBookmarked = "is_bookmarked"
        case isLiked = "is_liked"
        case reactionType = "reaction_type"
        case likeCount = "like_count"
        case shareCount = "share_count"
        case bookmarkCount = "bookmark_count"
        case commentCount = "comment_count"
    }
    
    var likeCountt: Int {
        return Int(likeCount ?? 0)
    }
    mutating func incrementLikeCount() {
        likeCount = likeCount! + 1
        }
    mutating func decrementLikeCount() {
        likeCount = likeCount! - 1
        }
    
}


struct LikeRequest: Encodable {
    let user_uuid: String
    let post_id, reaction_type: Int
}

struct BlockPostRequest: Encodable {
    let uuid: String
    let post_id: Int
}
struct BlockUserRequest: Encodable {
    let uuid: String
    let user_uuid: String
}

struct ReportPostRequest: Encodable {
    let uuid: String
    let post_id: Int
    let description: String
}

struct BookMarkRequest: Encodable {
    let user_uuid: String
    let post_id: Int
}

struct bookMarkSuccesResponse: Codable {
    let status: Bool?
    let message: String?
}

struct CommentRequest: Encodable {
    let user_uuid: String
    let post_id: Int
    let comment: String
}

struct FollowRequest: Encodable {
    let user_uuid: String
    let uuid: String
}

struct ReplyToCommentRequest: Encodable {
    let user_uuid: String
    let post_id: Int
    let comment: String
    let reply_to_comment_id: Int
}

struct ReplyToReplyRequest: Encodable {
    let user_uuid: String
    let post_id: Int
    let comment: String
    let reply_to_comment_id: Int
    let reply_to_reply: String
}

struct CommentResponse: Decodable {
    let id: Int
    let user_uuid: String
    let post_id: Int
    let reply_to_comment_id: Int
    let comment: String
    let reply_to_reply: String
}

struct InterestCateg: Decodable {
    let id: Int
    let category_name: String
}

struct UserInterestCateg: Decodable {
    let id: Int
    let user_uuid: String
    let category_id: Int
}

//"user_uuid": "{{user_uuid}}",
//    "post_id": 1,
//    "comment": "TEst comment"

