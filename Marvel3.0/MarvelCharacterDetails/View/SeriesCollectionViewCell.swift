//
//  SeriesCollectionViewCell.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste on 8/1/24.
//

import Foundation
import UIKit

class SeriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var issueNumberLabel: UILabel!
    @IBOutlet weak var thumbnailImage: MarvelImageView!
    
    // Render data
    func renderDataToSeriesCell(_ model: SeriesModel?) {
        
        guard let seriesModel = model else {
            return
        }
        
        Utils().setCornerRadius(view: self.thumbnailImage)
        
        self.titleLabel.text = seriesModel.title
        if let issueNumber = seriesModel.issueNumber {
            self.issueNumberLabel.text = "Issue number \(issueNumber)"
        }
        
        let urlString = (seriesModel.thumbnail?.path ?? "") + "." + (seriesModel.thumbnail?.imageExtension ?? "")
        self.thumbnailImage.downloadImageFrom(urlString: urlString, imageMode: .scaleAspectFill)
    }
}
