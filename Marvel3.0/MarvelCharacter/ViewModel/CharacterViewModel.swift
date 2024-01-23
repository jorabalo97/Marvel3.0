//
//  CharacterViewModel.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste
//


import UIKit

// ViewModel Protocols
protocol characterViewModelProtocol: AnyObject {
    func fetchListOfMarvelCharacters()
    func getErrorFrom(_ error: String)
    func getErrorCodeFromAPIResponse()
}

class CharacterViewModel {
    
    // Variables
    var characterDataModel: CharacterDataModel?
    weak var delegate: characterViewModelProtocol?
    private var publicKey = Utils.getAPIKeys()[KeyString.publicKey.rawValue] ?? ""
    private var privateKey = Utils.getAPIKeys()[KeyString.privateKey.rawValue] ?? ""
    
    func searchCharacters(with searchText: String) {
        let ts = String(Int(Date().timeIntervalSince1970))
        let hash = Utils.md5Hash("\(ts)\(privateKey)\(publicKey)")
        let url = "\(baseUrl)characters?ts=\(ts)&apikey=\(publicKey)&hash=\(hash)&nameStartsWith=\(searchText)"
        
        MarvelAPIService.init().getRequest(url: url, completion: { jsonData, error, statuscode in
            if let error = error {
                self.delegate?.getErrorFrom(error.localizedDescription)
                return
            }
            
            if let statuscode = statuscode {
                if statuscode == 200, let responseData = jsonData {
                    let jsonDecoder = JSONDecoder()
                    self.characterDataModel = try? jsonDecoder.decode(CharacterDataModel.self, from: responseData)
                    self.delegate?.fetchListOfMarvelCharacters()
                } else {
                    self.delegate?.getErrorCodeFromAPIResponse()
                }
            }
        })
    }
    
    
    //API requeste lista de personajes
    func getCharacterList() {
        let timeStamp = String(Int(Date().timeIntervalSinceNow))
        let hash = Utils.md5Hash("\(timeStamp)\(privateKey)\(publicKey)")
        let url = "\(baseUrl)characters?ts=\(timeStamp)&apikey=\(publicKey)&hash=\(hash)"
        
        MarvelAPIService.init().getRequest(url: url, completion: { jsonData, error, statuscode in
            
            if let error = error {
                self.delegate?.getErrorFrom(error.localizedDescription)
                return
            }
            
            if let statuscode = statuscode {
                if statuscode == 200, let responseData = jsonData {
                    let jsonDecoder = JSONDecoder()
                    self.characterDataModel = try? jsonDecoder.decode(CharacterDataModel.self, from: responseData)
                    self.delegate?.fetchListOfMarvelCharacters()
                } else {
                    self.delegate?.getErrorCodeFromAPIResponse()
                }
            }
        })
    }
}
