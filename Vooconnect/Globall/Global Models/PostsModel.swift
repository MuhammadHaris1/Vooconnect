//
//  PostsModel.swift
//  Vooconnect
//
//  Created by Online Developer on 25/03/2023.
//

import Foundation

struct PostsModel: Codable {
    let status: Bool
    let posts: [Post]?
}
