//
//  SeriesModel.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste on 8/1/24.
//

import Foundation

struct SeriesModel: Decodable {
    var title: String?
    var issueNumber: Int?
    var thumbnail: ThumbnailUrl?
}
