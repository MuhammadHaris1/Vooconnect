//
//  ReelsPostModel.swift
//  Vooconnect
//
//  Created by Vooconnect on 15/12/22.
//

import Foundation

// MARK: - Welcome
struct ReelsPostRequest: Codable {
    let userUUID, title, description, contentType: String?
    let category: Int?
    let musicTrack, location, visibility, musicURL: String?
    let content: [ContentDetail]?
    let allowComment, allowDuet, allowStitch: Bool?
    let tags: [String]?

    enum CodingKeys: String, CodingKey {
        case userUUID = "user_uuid"
        case title, description
        case contentType = "content_type"
        case category
        case musicTrack = "music_track"
        case location, visibility
        case musicURL = "music_url"
        case content
        case allowComment = "allow_comment"
        case allowDuet = "allow_duet"
        case allowStitch = "allow_stitch"
        case tags
    }
}

// MARK: - Content
struct ContentDetail: Codable {
    let name, size: String
}
