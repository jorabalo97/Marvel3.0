//
//  CharacterDetailViewController.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste 
//


import UIKit

class CharacterDetailViewController: UIViewController {
    
    // IBOutlets
    @IBOutlet weak var thumbnailImage: MarvelImageView!
    @IBOutlet weak var marvelImageView: MarvelImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var comicsCollectionView: UICollectionView!
    @IBOutlet weak var collectionBackgroundView: UIView!
    @IBOutlet var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
   
   
    var detailViewModel: CharacterDetailViewModel?
    var characterModel: CharacterModel?
    var comicModel: ComicsModel?
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewHeightConstraint.constant = 300
               flowLayout.itemSize = CGSize(width: 170, height: 300)
               
      
              
        
       // comicsCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewHeightConstraint.constant = 300
        flowLayout.itemSize = CGSize(width: 170, height: 300)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "transicionDesdeDetalleALista" {
            if let destinationVC = segue.destination as? ComicListViewController,
               let selectedComic = sender as? Comic {
                // Pasa el cómic seleccionado
                destinationVC.comicModel = ComicsModel(title: selectedComic.title, issueNumber: selectedComic.issueNumber, thumbnail: selectedComic.thumbnail)
            }
        }
    }






    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.detailViewModel?.delegate = self
        self.detailViewModel?.getRequestCharacterComicsAPI()
    }
    
    // set Data de Api
    func setData() {
        guard let characterModel = characterModel else {
            return
        }
        
        self.descriptionLabel.text = characterModel.description
        self.titleLabel.text = characterModel.name
        let urlString = (characterModel.thumbnail?.path ?? "") + "." + (characterModel.thumbnail?.imageExtension ?? "")
        self.marvelImageView.downloadImageFrom(urlString: urlString, imageMode: .scaleToFill)
    }
    
}

// CharacterDetailViewModelProtocol
extension CharacterDetailViewController: CharacterDetailViewModelProtocol {
    
    func getCharacterDetails() {
        self.setData()
        self.comicsCollectionView.reloadData()
    }
    
    func getError(_ error: String) {
        Utils().showAlertView(title: "Error", messsage: error)
    }
    
    func getErrorCodeFromAPIResponse() {
        Utils().showAlertView(title: ErrorString.error.rawValue, messsage: ErrorString.serverMsg.rawValue)
    }
    
}

// UICollectionViewDataSource protocol

extension CharacterDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.detailViewModel?.comicsDataModel?.data?.results?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Obtén el cómic seleccionado
        let selectedComic = self.detailViewModel?.comicsDataModel?.data?.results?[indexPath.row]

        // Inicia la transición a ComicListViewController
        performSegue(withIdentifier: "transicionDesdeDetalleALista", sender: selectedComic)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryboardUtils.CellIdentifier.comicCardCell, for: indexPath) as? ComicsCollectionViewCell {
            cell.renderDataToComicCell(self.detailViewModel?.comicsDataModel?.data?.results?[indexPath.row])
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension CharacterDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 300)
    }
}
