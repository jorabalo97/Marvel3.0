//
//  ComicsModel.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste
//

import Foundation
import UIKit

struct Comic {
    let id: Int
    var title: String
    var issueNumber: Int?
    var thumbnail: ThumbnailUrl?
    let variantDescription: String?
}

struct ComicsDataModel: Decodable {
    var data: ComicsResultModel?
}

struct ComicsResultModel: Decodable  {
    var results: [ComicsModel]?
}

struct ComicsModel: Decodable {
    var title: String?
    var issueNumber: Int?
    var thumbnail: ThumbnailUrl?
}
