//
//  ComicsCollectionViewCell.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste
//


import UIKit

class ComicsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var issueNumberLabel: UILabel!
    @IBOutlet private weak var thumbnailImage: MarvelImageView!
    //Render data
        var viewType: String = ""
        func renderDataToCell(_ model: Any?, viewType: String ) {
            guard model != nil else {
                return
            }
            
            Utils().setCornerRadius(view: self.thumbnailImage)
            
            if let comicModel = model as? ComicsModel, viewType == "Comics" {
                // Configuración para cómics
                self.titleLabel.text = comicModel.title
                if let issueNumber = comicModel.issueNumber {
                    self.issueNumberLabel.text = "Issue number \(issueNumber)"
                    
                }
                let urlString = (comicModel.thumbnail?.path ?? "") + "." + (comicModel.thumbnail?.imageExtension ?? "")
                self.thumbnailImage.downloadImageFrom(urlString: urlString, imageMode: .scaleAspectFill)
                if viewType == "Comics" {
                    self.titleLabel.text = comicModel.title
                } else if let seriesModel = model as? SeriesModel, viewType == "Series"  {
                    
                    self.titleLabel.text = seriesModel.title
                    let urlString = (seriesModel.thumbnail?.path ?? "") + "." +     (seriesModel.thumbnail?.imageExtension ?? "")
                    self.thumbnailImage.downloadImageFrom(urlString: urlString, imageMode: .scaleAspectFill)
                    if viewType == "Series" {
                        self.titleLabel.text = seriesModel.title
                        
                    }else if let storiesModel = model as? StoriesModel, viewType == "Stories" {
                        self.titleLabel.text = storiesModel.title
                        let urlString = (storiesModel.thumbnail?.path ?? "") + "." + (storiesModel.thumbnail?.imageExtension ?? "")
                        self.thumbnailImage.downloadImageFrom(urlString: urlString, imageMode: .scaleAspectFill)
                        if viewType == "Stories" {
                            self.titleLabel.text = storiesModel.title
                        } else if let eventsModel = model as? EventsModel, viewType == "Events" {
                            
                            self.titleLabel.text = eventsModel.title
                            let urlString = (eventsModel.thumbnail?.path ?? "") + "." + (eventsModel.thumbnail?.imageExtension ?? "")
                            self.thumbnailImage.downloadImageFrom(urlString: urlString, imageMode: .scaleAspectFill)
                            if viewType == "Events" {
                                self.titleLabel.text = eventsModel.title
                            }
                        }
                    }
                }
            }
        }
        
    }
