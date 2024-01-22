

//
//  ComicListViewController.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste on 21/12/23.
//

import UIKit

class ComicListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var comicModel: ComicsModel?
    var selectedComicFromDetail: Comic?
    var comics: [Comic] = []
    
    struct MarvelResponse: Codable {
        let code: Int
        let status: String
        let data: MarvelData
    }
    
    struct MarvelData: Codable {
        let results: [Comic]
    }
    
    struct Comic: Codable {
        let title: String?
        let variantDescription: String?
    }
    
    var viewModel: ComicListViewModel?
    
    func fetchMarvelComics(completion: @escaping (Result<[Comic], Error>) -> Void) {
        let publicKey = "91876cd71efdc7d4d08056257a5dd7bf"
        let privateKey = "4b31ba5c27608c34ec0d47763e976f32001d59e6"
        let baseURL = "https://gateway.marvel.com/v1/public/comics"
        
        // URL
        let timestamp = String(Date().timeIntervalSince1970)
        let hash = "\(timestamp)\(privateKey)\(publicKey)".md5
        let urlString = "\(baseURL)?apikey=\(publicKey)&ts=\(timestamp)&hash=\(hash)"
        print("URL: \(urlString)")
        
        if let url = URL(string: urlString) {
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
                        
                        // Acceder a la matriz de cómics
                        let comics = marvelResponse.data.results
                        
                        // Actualizar la interfaz de usuario
                        DispatchQueue.main.async {
                            completion(.success(comics))
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
    func updateUI(with comics: [Comic]) {
        self.comics = comics
        DispatchQueue.main.async {
            self.itemsTable.reloadData()
        }
    }
    
    @IBOutlet weak var itemsTable: UITableView!
    //Revisar
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fetchMarvelComics { result in
            switch result {
            case .success(let comics):
                // Procesa los cómics y actualiza la interfaz de usuario
                self.updateUI(with: comics)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        itemsTable.dataSource = self
        itemsTable.delegate = self
        itemsTable.reloadData()
        
        if let selectedComic = selectedComicFromDetail {
            
            print("Cómic seleccionado desde CharacterDetailViewController: \(selectedComic.title ?? "")")
        }
    }
    
    
    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = itemsTable.dequeueReusableCell(withIdentifier: "itemCell" , for : indexPath)
        let comic = comics[indexPath.row]
        cell.textLabel?.text = comic.title
        cell.detailTextLabel?.text = comic.variantDescription
        cell.imageView?.image = UIImage(systemName: "book")
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "vistaDeDetalle", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "vistaDeDetalle" {
            if let indexPath = itemsTable.indexPathForSelectedRow,
               let destinationVC = segue.destination as? CharacterDetailViewController {
                //  cómic seleccionado
                let selectedComic = comics[indexPath.row]
                
                // Asignamos  el cómic al CharacterDetailViewController
                destinationVC.comicModel = ComicsModel(title: selectedComic.title)
            }
        }
    }
}
