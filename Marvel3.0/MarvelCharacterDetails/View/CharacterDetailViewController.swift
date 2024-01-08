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
   
    var isViewingComics: Bool = true
    var detailViewModel: CharacterDetailViewModel?
    var characterModel: CharacterModel?
    var comicModel: ComicsModel?
    
  
    var segmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailViewModel?.getRequestCharacterComicsAPI()
        
        collectionViewHeightConstraint.constant = 300
               flowLayout.itemSize = CGSize(width: 170, height: 300)
               
        segmentedControl = UISegmentedControl(items: ["Comics", "Series"])
           segmentedControl.selectedSegmentIndex = 0
           segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
              
        view.addSubview(segmentedControl)
        detailViewModel?.getRequestCharacterComicsAPI()
      
        collectionViewHeightConstraint.constant = 300
        flowLayout.itemSize = CGSize(width: 170, height: 300)
        
    }
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        isViewingComics = sender.selectedSegmentIndex == 0
        
        descriptionLabel.text = isViewingComics ? "Comics" : "Series"

        if isViewingComics {
            detailViewModel?.getRequestCharacterComicsAPI()
        } else {
            detailViewModel?.getRequestCharacterSeriesAPI()
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "transicionDesdeDetalleALista" {
            if let destinationVC = segue.destination as? ComicListViewController,
               let selectedComic = sender as? Comic {
                // Pasa el cómic seleccionado
                destinationVC.comicModel = ComicsModel(title: selectedComic.title, issueNumber: selectedComic.issueNumber, thumbnail: selectedComic.thumbnail)
                destinationVC.comicModel = ComicsModel(title: selectedComic.title)
            }
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.detailViewModel?.delegate = self
        if isViewingComics {
              self.detailViewModel?.getRequestCharacterComicsAPI()
          } else {
              self.detailViewModel?.getRequestCharacterSeriesAPI()
          }
    }
    
    // setData desde  Api
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
    
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           
            self.detailViewModel?.searchComics(with: searchText)
        }
    

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
       
        let selectedComic = self.detailViewModel?.comicsDataModel?.data?.results?[indexPath.row]

      
        performSegue(withIdentifier: "transicionDesdeDetalleALista", sender: selectedComic)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryboardUtils.CellIdentifier.comicCardCell, for: indexPath) as? ComicsCollectionViewCell {
            if isViewingComics {
                       cell.renderDataToCell(self.detailViewModel?.comicsDataModel?.data?.results?[indexPath.row])
                   } else {
                       cell.renderDataToCell(self.detailViewModel?.seriesDataModel?.data?.results?[indexPath.row])
                   }
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
