//
//  StoriesCollectionViewCell.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste on 10/1/24.
//

import Foundation
import UIKit

class StoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var issueNumberLabel: UILabel!
    @IBOutlet weak var thumbnailImage: MarvelImageView!
    
    // Render data
    func renderDataToStoriesCell(_ model: StoriesModel?) {
        
        guard let storiesModel = model else {
            return
        }
        
        Utils().setCornerRadius(view: self.thumbnailImage)
        
        self.titleLabel.text = storiesModel.title
        if let issueNumber = storiesModel.issueNumber {
            self.issueNumberLabel.text = "Issue number \(issueNumber)"
        }
        
        let urlString = (storiesModel.thumbnail?.path ?? "") + "." + (storiesModel.thumbnail?.imageExtension ?? "")
        self.thumbnailImage.downloadImageFrom(urlString: urlString, imageMode: .scaleAspectFill)
    }
}

