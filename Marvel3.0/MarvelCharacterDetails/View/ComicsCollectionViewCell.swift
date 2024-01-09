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
   
    func renderDataToCell(_ model: Any?) {
        guard model != nil else {
            return
        }
        
        Utils().setCornerRadius(view: self.thumbnailImage)
               
               if let comicModel = model as? ComicsModel {
                   // Configuración para cómics
                   self.titleLabel.text = comicModel.title
                   if let issueNumber = comicModel.issueNumber {
                       self.issueNumberLabel.text = "Issue number \(issueNumber)"
                   }
                   let urlString = (comicModel.thumbnail?.path ?? "") + "." + (comicModel.thumbnail?.imageExtension ?? "")
                   self.thumbnailImage.downloadImageFrom(urlString: urlString, imageMode: .scaleAspectFill)
               } else if let seriesModel = model as? SeriesModel {
                  
                   self.titleLabel.text = seriesModel.title
                 
               }
           }
       }
