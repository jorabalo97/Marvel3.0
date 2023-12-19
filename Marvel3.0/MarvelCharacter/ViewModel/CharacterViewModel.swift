//
//  CharacterViewModel.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste 
//

import UIKit

// Define el protocolo CharacterViewModelDelegate
protocol CharacterViewModelDelegate: AnyObject {
    func fetchListOfMarvelCharacters()
    func getErrorFrom(_ error: String)
    func getErrorCodeFromAPIResponse()
}

// Define la clase que adopta el protocolo CharacterViewModelDelegate
class MarvelCharactersDelegate: CharacterViewModelDelegate {
    func getErrorFrom(_ error: String) {
        return
    }
    
    func getErrorCodeFromAPIResponse() {
        return
    }
    var characterViewModel: CharacterViewModel?

    func fetchListOfMarvelCharacters() {
        print("Lista de personajes de Marvel recibida.")
       
          if let characterDataModel = characterViewModel?.characterDataModel {
              
              //imprimir lista
              
              for result in characterDataModel.data?.results ?? [] {
                  print("Nombre del personaje: \(result.name ?? "")")
              }
          }
      }
       
    }

    func getErrorFrom(_ error: String) {
        print("Error: \(error)")
        
    }

    func getErrorCodeFromAPIResponse() {
        print("Código de error en la respuesta de la API.")
        
    }


class CharacterViewModel {
    weak var delegate: CharacterViewModelDelegate?
    
    var privateKey = "4da961812496c30cf73ed692b494f315"
    var publicKey = "d7fc2827797d7e47f6417dca83b3beeb4c5607ee"
    var baseUrl = "https://gateway.marvel.com:443/v1/public/characters?limit=50&offset=0&apikey=4da961812496c30cf73ed692b494f315"
    var characterDataModel: CharacterDataModel?
    
    // Modificar el método getCharacterList para incluir offset y limit
    func getCharacterList(offset: Int, limit: Int) {
        let timeStamp = String(Int(Date().timeIntervalSinceNow))
        let hash = Utils.md5Hash("\(timeStamp)\(privateKey)\(publicKey)")
        let url = "\(baseUrl)characters?ts=\(timeStamp)&apikey=\(publicKey)&hash=\(hash)"
        
        MarvelAPIService().getRequestWithPagination(url: url, offset: offset, limit: limit) { jsonData, error, statuscode in
            if let error = error {
                self.delegate?.getErrorFrom(error.localizedDescription)
                return
            }
            
        
            if let statuscode = statuscode {
                if statuscode == 200, let responseData = jsonData {
                    let jsonDecoder = JSONDecoder()
                    let newCharacterDataModel = try? jsonDecoder.decode(CharacterDataModel.self, from: responseData)

                    // nuevos resultados
                    self.characterDataModel?.data?.results?.append(contentsOf: newCharacterDataModel?.data?.results ?? [])
                    
                    self.delegate?.fetchListOfMarvelCharacters()
                } else {
                    self.delegate?.getErrorCodeFromAPIResponse()
                }
            }
        }
    }
}
func main() {
  
    let marvelCharactersDelegate = MarvelCharactersDelegate()
    
    
    let characterViewModel = CharacterViewModel()
    
  
    characterViewModel.delegate = marvelCharactersDelegate
    
    
    characterViewModel.getCharacterList(offset: 0, limit: 50)
    
}

