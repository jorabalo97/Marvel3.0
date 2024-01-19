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
    var series: [SeriesModel] = []
    var isViewingSeries: Bool = true
    var isViewingStories: Bool = true 
    var isViewingEvents: Bool = true
    var segmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailViewModel?.getRequestCharacterComicsAPI()
        
       
        
    }
    @objc func segmentedControl(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            isViewingComics = true
            isViewingSeries = false
            isViewingStories = false
            isViewingEvents = false
            descriptionLabel.text = "Comics"
            detailViewModel?.getRequestCharacterComicsAPI()
        case 1:
            isViewingComics = false
            isViewingSeries = true
            isViewingStories = false
            isViewingEvents = false
            updateTitleLabel(for: "Series")
            updatedescriptionLabel(for: "Series")
            detailViewModel?.getRequestCharacterSeriesAPI()
        case 2:
            isViewingComics = false
            isViewingSeries = false
            isViewingStories = true
            isViewingEvents = false
            updateTitleLabel(for: "Stories")
            updatedescriptionLabel(for: "Stories")
            detailViewModel?.getRequestCharacterStoriesAPI()
        case 3:
            isViewingComics = false
            isViewingSeries = false
            isViewingStories = false
            isViewingEvents = true
            updateTitleLabel(for: "Events")
            updatedescriptionLabel(for:"Events")
            detailViewModel?.getRequestCharacterEventsAPI()
        default:
            break
        }
        self.comicsCollectionView.reloadData()
        func updateTitleLabel(for category: String) {
              descriptionLabel.text = category
              titleLabel.text = category
          }
        func updatedescriptionLabel(for category: String) {
              descriptionLabel.text = category
              titleLabel.text = category
          }
    }
    
        
        
    

    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "transicionDesdeDetalleALista" {
            if let destinationVC = segue.destination as? ComicListViewController,
               let selectedComic = sender as? Comic {
                // Pasa el cómic seleccionado
                destinationVC.comicModel = ComicsModel(title: selectedComic.title, issueNumber: selectedComic.issueNumber, thumbnail: selectedComic.thumbnail)
               
            }
        }
        else if segue.identifier == "transicionDesdeDetalleAListaSeries" {
            if let destinationVC = segue.destination as? SeriesListViewController,
               let selectedSeries = sender as? SeriesModel {
                destinationVC.seriesModel = SeriesModel(title: selectedSeries.title)
            }
        }
        else if segue.identifier == "transicionDesdeDetalleAListaStories" {
            let charcterId = detailViewModel?.charcterId
            if let destinationVC = segue.destination as? StoriesListViewController,
               let selectedStories = sender as? Stories {
                destinationVC.storiesModel = Stories( Id: selectedStories.Id, title: selectedStories.title)
            }
        }

    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.detailViewModel?.delegate = self
        if isViewingComics {
              self.detailViewModel?.getRequestCharacterComicsAPI()
          } else if isViewingSeries {
              self.detailViewModel?.getRequestCharacterSeriesAPI()
          } else if isViewingStories {
              self.detailViewModel?.getRequestCharacterStoriesAPI()
          }else if isViewingEvents {
              self.detailViewModel?.getRequestCharacterEventsAPI()
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
        if isViewingComics {
            let selectedComic = self.detailViewModel?.comicsDataModel?.data?.results?[indexPath.row]
            performSegue(withIdentifier: "transicionDesdeDetalleALista", sender: selectedComic)
        } else if isViewingSeries {
            let selectedSeries = self.detailViewModel?.seriesDataModel?.data?.results?[indexPath.row]
            performSegue(withIdentifier: "transicionDesdeDetalleAListaSeries", sender: selectedSeries)
        } else if isViewingStories {
            let selectedStories = self.detailViewModel?.storiesDataModel?.data?.results?[indexPath.row]
            performSegue(withIdentifier: "transicionDesdeDetalleAListaStories", sender: selectedStories)
        }else if isViewingEvents {
            let selectedEvents = self.detailViewModel?.eventsDataModel?.data?.results?[indexPath.row]
            performSegue(withIdentifier: "transicionDesdeDetalleAListaEvents", sender: selectedEvents)
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryboardUtils.CellIdentifier.comicCardCell, for: indexPath) as? ComicsCollectionViewCell {
            let model: Any?

                 if isViewingComics {
                     model = self.detailViewModel?.comicsDataModel?.data?.results?[indexPath.row]
                 } else if isViewingSeries {
                     model = self.detailViewModel?.seriesDataModel?.data?.results?[indexPath.row]
                 } else if isViewingStories {
                     model = self.detailViewModel?.storiesDataModel?.data?.results?[indexPath.row]
                 } else if isViewingEvents {
                     model = self.detailViewModel?.eventsDataModel?.data?.results?[indexPath.row]
                 }else {
                     model = nil
                 }
            let viewType: String  = "Comics"
                   cell.viewType = ""
            cell.renderDataToCell(model, viewType: viewType)
                 return cell        }
        return UICollectionViewCell()
    }
}
    
    extension CharacterDetailViewController: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 170, height: 300)
        }
    }

