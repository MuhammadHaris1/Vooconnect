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
    let musicTrack, location, visibility,musicUUID, musicURL: String?
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
        case musicUUID = "music_uuid"
        case musicURL = "music_url"
        case content
        case allowComment = "allow_comment"
        case allowDuet = "allow_duet"
        case allowStitch = "allow_stitch"
        case tags
//        case subtitle_apply = "subtitle_apply"
//        case subtitleLang
    }

//    var content: [ContentDetail]?
//    var title: String?
//    var category: Int?
//    var tags: [String]?
//    var musicTrack: String?
//    var allowDuet: Bool?
//    var visibility: String?
//    var allowStitch: Bool?
//    var location: String?
//    var allowComment: Bool?
//    var userUuid: String?
//    var contentType: String?
//    var descriptionValue: String?
//    var musicUrl: String?
}

// MARK: - Content
struct ContentDetail: Codable {
    let name, size: String?
    
}
