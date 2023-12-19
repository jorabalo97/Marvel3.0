//
//  CharacterViewController.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste 
//


import UIKit

class CharacterViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var characterTableView: UITableView!

    var characterViewModel = CharacterViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
    
    private func setupUI() {
        characterTableView.delegate = self
        characterTableView.dataSource = self
    }
    
    private func fetchData() {
        characterViewModel.delegate = self
        characterViewModel.getCharacterList(offset: 0, limit: 10)
    }
    
}

extension CharacterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterViewModel.characterDataModel?.data?.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardUtils.CellIdentifier.characterCardCell, for: indexPath) as? CharacterTableViewCell {
            cell.renderDataToCell(characterViewModel.characterDataModel?.data?.results?[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewControllerInstance = StoryboardUtils.getCharacterDetailViewController() {
            viewControllerInstance.characterModel = characterViewModel.characterDataModel?.data?.results?[indexPath.row]
            viewControllerInstance.detailViewModel = CharacterDetailViewModel(id: "\(characterViewModel.characterDataModel?.data?.results?[indexPath.row].id ?? 0)")
            self.navigationController?.present(viewControllerInstance, animated: true, completion: nil)
        }
    }
}

// Implementación del protocolo CharacterViewModelDelegate
extension CharacterViewController: CharacterViewModelDelegate {
    func fetchListOfMarvelCharacters() {
        
        characterTableView.reloadData()
    }
    
    func getErrorFrom(_ error: String) {
        Utils().showAlertView(title: "Error", messsage: error)
    }
    
    func getErrorCodeFromAPIResponse() {
        Utils().showAlertView(title: ErrorString.error.rawValue, messsage: ErrorString.serverMsg.rawValue)
    }
}
