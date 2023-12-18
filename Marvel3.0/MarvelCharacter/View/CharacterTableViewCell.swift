//
//  CharacterTableViewCell.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste
//



import UIKit

class CharacterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterDescriptionLabel: UILabel!
    @IBOutlet weak var thumbnailImage: MarvelImageView!
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var nameBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Comprobar parte delantera celda
        
        self.cellBackgroundView.bringSubviewToFront(nameBackgroundView)
        Utils().setCornerRadius(view: cellBackgroundView)
    }
    
    
    //Configuramos la celda con characterModel
    
    func renderDataToCell(_ model: CharacterModel?) {
        
        guard let characterModel = model else {
            return
        }
        
        self.characterDescriptionLabel.isHidden = characterModel.description ?? "" == "" ? true : false
        
        self.characterNameLabel.text = characterModel.name
        self.characterDescriptionLabel.text = characterModel.description
        
        let urlString = (characterModel.thumbnail?.path ?? "") + "." + (characterModel.thumbnail?.imageExtension ?? "")
        self.thumbnailImage.downloadImageFrom(urlString: urlString, imageMode: .scaleAspectFill)
      
    }
}
