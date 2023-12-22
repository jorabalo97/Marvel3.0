//
//  ComicsCollectionViewCell.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste 
//


import UIKit

class ComicsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var issueNumberLabel: UILabel!
    @IBOutlet weak var thumbnailImage: MarvelImageView!
    //Render data
    func renderDataToComicCell(_ model: ComicsModel?) {
        
        guard let comicModel = model else {
            return
        }
        
        Utils().setCornerRadius(view: self.thumbnailImage)
        
        
        self.titleLabel.text = comicModel.title
        if let issueNumber = comicModel.issueNumber {
            self.issueNumberLabel.text = "Issue number \(String(describing: issueNumber))"
        }
        
        let urlString = (comicModel.thumbnail?.path ?? "") + "." + (comicModel.thumbnail?.imageExtension ?? "")
        self.thumbnailImage.downloadImageFrom(urlString: urlString, imageMode: .scaleAspectFill)
        
    }
    
    
}
