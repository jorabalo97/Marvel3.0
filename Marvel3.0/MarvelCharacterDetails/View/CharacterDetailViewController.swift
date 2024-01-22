//
//  CharacterDetailViewController.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste
//

import UIKit

class CharacterDetailViewController: UIViewController {
    
    enum State: Int {
        case comics = 0
        case series = 1
        case stories = 2
        case events = 3
    }
    
    // IBOutlets
    @IBOutlet private weak var thumbnailImage: MarvelImageView!
    @IBOutlet private weak var marvelImageView: MarvelImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var comicsCollectionView: UICollectionView!
    @IBOutlet private weak var collectionBackgroundView: UIView!
    @IBOutlet private var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var flowLayout: UICollectionViewFlowLayout!
    
    private var state: State = .comics
    var detailViewModel: CharacterDetailViewModel?
    private var characterModel: CharacterModel?
    var comicModel: ComicsModel?
    private var series: [SeriesModel] = []
    
    private var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailViewModel?.getRequestCharacterComicsAPI()
    }
    
    public func setCharacterModel(_ characterModel: CharacterModel) {
        self.characterModel = characterModel
    }
    
    @objc func segmentedControl(_ sender: UISegmentedControl) {
        comicsCollectionView.selectItem(at: IndexPath(row: .zero, section: .zero), animated: true, scrollPosition: .centeredHorizontally)
        switch sender.selectedSegmentIndex {
        case 0:
            state = .comics
            updatedescriptionLabel(for: "Comics")
            detailViewModel?.getRequestCharacterComicsAPI()
        case 1:
            state = .series
//            updateTitleLabel(for: "Series")
            updatedescriptionLabel(for: "Series")
            detailViewModel?.getRequestCharacterSeriesAPI()
        case 2:
            state = .stories
//            updateTitleLabel(for: "Stories")
            updatedescriptionLabel(for: "Stories")
            detailViewModel?.getRequestCharacterStoriesAPI()
        case 3:
            state = .events
//            updateTitleLabel(for: "Events")
            updatedescriptionLabel(for:"Events")
            detailViewModel?.getRequestCharacterEventsAPI()
        default:
            break
        }
        comicsCollectionView.reloadData()
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
                destinationVC.storiesModel = StoriesModel(id: selectedStories.Id, title: selectedStories.title)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.detailViewModel?.delegate = self
        switch state {
        case .comics:
            detailViewModel?.getRequestCharacterComicsAPI()
        case .series:
            detailViewModel?.getRequestCharacterSeriesAPI()
        case .stories:
            detailViewModel?.getRequestCharacterStoriesAPI()
        case .events:
            detailViewModel?.getRequestCharacterEventsAPI()
        }
    }
    
    // setData desde Api
    func setData() {
        guard let characterModel = characterModel else { return }
//        self.descriptionLabel.text = characterModel.description
        self.titleLabel.text = characterModel.name
        let urlString = (characterModel.thumbnail?.path ?? "") + "." + (characterModel.thumbnail?.imageExtension ?? "")
        self.marvelImageView.downloadImageFrom(urlString: urlString, imageMode: .scaleToFill)
    }
    
}

private extension CharacterDetailViewController {
    func updateTitleLabel(for category: String) {
        titleLabel.text = category
    }
    
    func updatedescriptionLabel(for category: String) {
        descriptionLabel.text = category
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
        switch state {
        case .comics:
            return self.detailViewModel?.comicsDataModel?.data?.results?.count ?? .zero
        case .series:
            return self.detailViewModel?.seriesDataModel?.data?.results?.count ?? .zero
        case .stories:
            return self.detailViewModel?.storiesDataModel?.data?.results?.count ?? .zero
        case .events:
            return self.detailViewModel?.eventsDataModel?.data?.results?.count ?? .zero
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch state {
        case .comics:
            let selectedComic = self.detailViewModel?.comicsDataModel?.data?.results?[indexPath.row]
            performSegue(withIdentifier: "transicionDesdeDetalleALista", sender: selectedComic)
        case .series:
            let selectedComic = self.detailViewModel?.comicsDataModel?.data?.results?[indexPath.row]
            performSegue(withIdentifier: "transicionDesdeDetalleALista", sender: selectedComic)
        case .stories:
            let selectedStories = self.detailViewModel?.storiesDataModel?.data?.results?[indexPath.row]
            performSegue(withIdentifier: "transicionDesdeDetalleAListaStories", sender: selectedStories)
        case .events:
            let selectedEvents = self.detailViewModel?.eventsDataModel?.data?.results?[indexPath.row]
            performSegue(withIdentifier: "transicionDesdeDetalleAListaEvents", sender: selectedEvents)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryboardUtils.CellIdentifier.comicCardCell, for: indexPath) as? ComicsCollectionViewCell {
            var model: Any? = nil
            switch state {
            case .comics:
                model = self.detailViewModel?.comicsDataModel?.data?.results?[indexPath.row]
            case .series:
                model = self.detailViewModel?.seriesDataModel?.data?.results?[indexPath.row]
            case .stories:
                model = self.detailViewModel?.storiesDataModel?.data?.results?[indexPath.row]
            case .events:
                model = self.detailViewModel?.eventsDataModel?.data?.results?[indexPath.row]
            }
            let viewType: String = ""
            cell.viewType = viewType
            cell.renderDataToCell(model, viewType: "")
            return cell        }
        return UICollectionViewCell()
    }
}

extension CharacterDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 300)
    }
}
