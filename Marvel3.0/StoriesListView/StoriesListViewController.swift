//
//  SeriesListViewController.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste on 10/1/24.
//



import Foundation
import UIKit

class StoriesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    struct MarvelResponse: Codable {
        let code: Int
        let status: String
        let data: MarvelData
    }
    
    struct MarvelData: Codable {
        let results: [Stories]
    }
    
    struct Stories: Codable {
        var title: String?
        var issueNumber: Int?
       
     }
    
    var stories: [Stories] = []
    var viewModel: StoriesListViewModel?
    var storiesModel: StoriesModel?
    func fetchMarvelStories(completion: @escaping (Result<[Stories], Error>) -> Void) {
        let publicKey = "91876cd71efdc7d4d08056257a5dd7bf"
        let privateKey = "4b31ba5c27608c34ec0d47763e976f32001d59e6"
        let baseURL = "https://gateway.marvel.com/v1/public/stories"
        
        // Construir la URL con las claves y otros parámetros
        let timestamp = String(Date().timeIntervalSince1970)
        let hash = "\(timestamp)\(privateKey)\(publicKey)".md5
        let urlString = "\(baseURL)?apikey=\(publicKey)&ts=\(timestamp)&hash=\(hash)"
        print("URL: \(urlString)")
        
        if let url = buildURL() {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    completion(.failure(error))
                } else if let data = data {
                    do {
                        // Decodificar la respuesta como un objeto MarvelResponse
                        let decoder = JSONDecoder()
                        let marvelResponse = try decoder.decode(MarvelResponse.self, from: data)
                        
                        // Verificar si la respuesta fue exitosa (código 200)
                        guard marvelResponse.code == 200 else {
                            let error = NSError(domain: "Marvel API Error", code: marvelResponse.code, userInfo: nil)
                            print("Marvel API Error: \(error)")
                            completion(.failure(error))
                            return
                        }
                        
                        // Acceder a la matriz de cómics dentro de la respuesta
                        let stories = marvelResponse.data.results
                        
                        // Actualizar la interfaz de usuario en el hilo principal
                        DispatchQueue.main.async {
                            completion(.success(stories))
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                        completion(.failure(error))
                    }
                }
            }
            // Iniciar la tarea
            task.resume()
        } else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            print("Error: \(error)")
            completion(.failure(error))
        }
    }
    func updateUI(with stories: [Stories]) {
        self.stories = stories
        DispatchQueue.main.async {
            self.storiesTable.reloadData()
        }
    }
    
    @IBOutlet weak var storiesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMarvelStories { result in
            switch result {
            case .success(let stories):
                
                self.updateUI(with: stories)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        storiesTable.dataSource = self
        storiesTable.delegate = self
        storiesTable.reloadData()
    }
    
    
    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = storiesTable.dequeueReusableCell(withIdentifier: "storieCell" , for : indexPath)
            let stories = stories[indexPath.row]
            cell.textLabel?.text = stories.title
            cell.detailTextLabel?.text = stories.title
            cell.imageView?.image = UIImage(systemName: "film.circle.fill")
            return cell
        }
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "transicionDesdeDetalleAListaStories", sender: self)
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "vistaDeDetalle" {
                if let indexPath = storiesTable.indexPathForSelectedRow,
                   let destinationVC = segue.destination as? CharacterDetailViewController {
                    //  cómic seleccionado
                    let selectedStories = stories[indexPath.row]
                    
                    // Asignamos  el cómic al CharacterDetailViewController
                    destinationVC.comicModel = ComicsModel(title: selectedStories.title)
                }
        }
    }
}

private extension StoriesListViewController {
    func buildURL() -> URL? {
        let publicKey = "91876cd71efdc7d4d08056257a5dd7bf"
        let privateKey = "4b31ba5c27608c34ec0d47763e976f32001d59e6"
        let baseURL = "https://gateway.marvel.com/v1/public/stories"
        
        // Construir la URL con las claves y otros parámetros
        let timestamp = String(Date().timeIntervalSince1970)
        let hash = "\(timestamp)\(privateKey)\(publicKey)".md5
        let urlString = "\(baseURL)?apikey=\(publicKey)&ts=\(timestamp)&hash=\(hash)"
        print("URL: \(urlString)")
        return URL(string: urlString)
    }
}

