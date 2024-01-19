//
//  SeriesListViewController.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste on 8/1/24.
//

import Foundation
import UIKit

class SeriesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    struct MarvelResponse: Codable {
        let code: Int
        let status: String
        let data: MarvelData
    }
    
    struct MarvelData: Codable {
        let total: Int
        let count: Int
        let results: [Series]
    }
    
    struct Series: Codable {
        var title: String?
        var issueNumber: Int?
    }
    var viewModel: SeriesListViewModel?
    var seriesModel: SeriesModel?
    var totalItems = 0
    var itemsPerPage = 20
    var currentPage = 1
    var series: [Series] = []
    var isLoading = false
    
    func loadMoreSeries() {
        guard !isLoading else {
            return
        }
        isLoading = true
        currentPage += 1
        fetchMarvelSeries(page: currentPage) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let newSeries):
                // Agregar las nuevas historias a la lista existente
                self.series += newSeries
                self.updateUI(with: self.series)
                
            case .failure(let error):
                print("Error: \(error)")
            }
            
            self.isLoading = false
        }
    }
    
    func fetchMarvelSeries(page: Int, completion: @escaping (Result<[Series], Error>) -> Void) {
        let publicKey = "91876cd71efdc7d4d08056257a5dd7bf"
        let privateKey = "4b31ba5c27608c34ec0d47763e976f32001d59e6"
        let baseURL = "https://gateway.marvel.com/v1/public/series"
        
        // Construir la URL con las claves y otros parámetros
        let timestamp = String(Date().timeIntervalSince1970)
        let hash = "\(timestamp)\(privateKey)\(publicKey)".md5
        let offset = (page - 1) * itemsPerPage
        let urlString = "\(baseURL)?apikey=\(publicKey)&ts=\(timestamp)&hash=\(hash)&offset=\(offset)&limit=\(itemsPerPage)"
        
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
                        
                        // Actualizar la información de paginación
                        self.totalItems = marvelResponse.data.total
                        
                        // Acceder a la matriz de cómics dentro de la respuesta
                        let series = marvelResponse.data.results
                        
                        // Actualizar la interfaz de usuario en el hilo principal
                        DispatchQueue.main.async {
                            completion(.success(series))
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
  
    
    func updateUI(with series: [Series]) {
        if currentPage == 1 {
            self.series = series
        } else {
            self.series += series
        }
        DispatchQueue.main.async {
            self.seriesTable.reloadData()
        }
    }
    
    
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            
            // Verificar si el usuario ha llegado al final de la tabla y cargar más historias
            if offsetY > contentHeight - scrollView.frame.size.height {
                loadMoreSeries()
            }
        }
    
    @IBAction func backedButton(_ sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: 0)
            seriesTable.scrollToRow(at: indexPath, at: .top, animated: true)
        
    }
    @IBOutlet weak var seriesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        seriesTable.dataSource = self
        seriesTable.delegate = self
        seriesTable.reloadData()
    }
  
        
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        series.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = seriesTable.dequeueReusableCell(withIdentifier: "serieCell", for: indexPath)
        let series = series[indexPath.row]
        cell.textLabel?.text = series.title
        cell.detailTextLabel?.text = series.title
        cell.imageView?.image = UIImage(systemName: "film.circle.fill")
        

       
        
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "vistaDeDetalle", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "vistaDeDetalle" {
            if let destinationVC = segue.destination as? SeriesListViewController,
               let selectedIndexPath = seriesTable.indexPathForSelectedRow {
                let selectedSeriesModel = series[selectedIndexPath.row]
                destinationVC.seriesModel = SeriesModel(title: selectedSeriesModel.title)
            }
        }
    }
}
