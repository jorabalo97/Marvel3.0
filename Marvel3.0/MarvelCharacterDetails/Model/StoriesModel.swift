//
//  StoriesModel.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste on 10/1/24.
//

import Foundation
struct StoriesModel: Decodable {
    var title: String?
    var issueNumber: Int?
    var thumbnail: ThumbnailUrl?
}
