//
//  EventsModel.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste on 11/1/24.
//

import Foundation
struct EventsModel: Decodable {
    var title: String?
    var issueNumber: Int?
    var thumbnail: ThumbnailUrl?
}
