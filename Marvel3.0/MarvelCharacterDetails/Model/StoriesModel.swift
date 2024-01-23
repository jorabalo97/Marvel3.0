//
//  StoriesModel.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste on 10/1/24.
//

import Foundation
struct Stories: Decodable {
    var Id: Int
    var title: String?
    var issueNumber: Int?
    var thumbnail: ThumbnailUrl?
}

struct StoriesDataModel: Decodable  {
    var data: StoriesResultModel?
}

struct StoriesResultModel: Decodable  {
    var results: [StoriesModel]?
}

struct StoriesModel: Decodable  {
    let id: Int
    var title: String?
    var issueNumber: Int?
    var thumbnail: ThumbnailUrl?
}
