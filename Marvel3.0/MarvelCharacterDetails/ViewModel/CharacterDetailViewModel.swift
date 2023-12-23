//
//  CharacterDetailViewModel.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste 
//

import Foundation

//MARK:- CharacterDetailViewModelProtocol Methods
protocol CharacterDetailViewModelProtocol: AnyObject {
    
    func getCharacterDetails()
    func getError(_ error: String)
    func getErrorCodeFromAPIResponse()
}

class CharacterDetailViewModel {
    
    // Variables
    var comicsDataModel: ComicsDataModel?
    weak var delegate: CharacterDetailViewModelProtocol?
    private var publicKey = Utils.getAPIKeys()[KeyString.publicKey.rawValue] ?? ""
    private var privateKey = Utils.getAPIKeys()[KeyString.privateKey.rawValue] ?? ""
    var charcterId: String?
    
   
    init(id: String) {
        self.charcterId = id
    }
    
    func searchComics(with searchText: String) {
        // Construir la URL de búsqueda utilizando el término de búsqueda (searchText)
        let ts = String(Int(Date().timeIntervalSince1970))
        let hash = Utils.md5Hash("\(ts)\(privateKey)\(publicKey)")
        let url = "\(baseUrl)characters/\(self.charcterId ?? "")/comics?ts=\(ts)&apikey=\(publicKey)&hash=\(hash)&titleStartsWith=\(searchText)"
        
        MarvelAPIService.init().getRequest(url: url, completion: { jsonData, error, statuscode in
            if let error = error {
                self.delegate?.getError(error.localizedDescription)
                return
            }
            
            if let statuscode = statuscode {
                if statuscode == 200, let responseData = jsonData {
                    let jsonDecoder = JSONDecoder()
                    self.comicsDataModel = try? jsonDecoder.decode(ComicsDataModel.self, from: responseData)
                    self.delegate?.getCharacterDetails()
                } else {
                    self.delegate?.getErrorCodeFromAPIResponse()
                }
            }
        })
    }

    
    //Request de los comics de la API
    func getRequestCharacterComicsAPI() {
        
        let ts = String(Int(Date().timeIntervalSince1970))
        let hash = Utils.md5Hash("\(ts)\(privateKey)\(publicKey)")
        let url = "\(baseUrl)characters/\(self.charcterId ?? "")/comics?ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
        
        MarvelAPIService.init().getRequest(url: url, completion: { jsonData, error, statuscode in
            
            if let error = error {
                self.delegate?.getError(error.localizedDescription)
                return
            }
            
            if let statuscode = statuscode {
                if statuscode == 200, let responseData = jsonData {
                    let jsonDecoder = JSONDecoder()
                    self.comicsDataModel = try? jsonDecoder.decode(ComicsDataModel.self, from: responseData)
                    self.delegate?.getCharacterDetails()
                } else {
                    self.delegate?.getErrorCodeFromAPIResponse()
                }
            }
        })
    }
}
