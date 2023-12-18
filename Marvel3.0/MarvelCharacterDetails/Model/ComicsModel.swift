//
//  ComicsModel.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste 
//


import UIKit


//  Decoder
struct ComicsDataModel: Decodable {
    
    var data: ComicsResultModel?
}

struct ComicsResultModel: Decodable {
    
    var results: [ComicsModel]?
    
}

struct ComicsModel: Decodable {
    
    var title: String?
    var issueNumber: Int?
    var thumbnail: ThumbnailUrl?
    
}
