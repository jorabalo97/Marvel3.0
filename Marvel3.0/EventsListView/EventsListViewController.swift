//
//  EventsListViewController.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste on 11/1/24.
//

import Foundation
import UIKit

class EventsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    struct MarvelResponse: Codable {
        let code: Int
        let status: String
        let data: MarvelData
    }

    struct MarvelData: Codable {
        let results: [Events]
    }

    struct Events: Codable {
        var title: String?
        var issueNumber: Int?  // Cambiado para que coincida con la estructura de la segunda clase
    }

    var events: [Events] = []
    var viewModel: EventsListViewModel?
    var totalItems = 0
    var itempsPage = 20
    var currentPage = 0
    var isLoading = false
    func loadMoreEvent() {
        guard !isLoading else {
            return
        }
        isLoading = true
        currentPage += 1
        fetchMarvelEvents{ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let newEvents):
                // Agregar las nuevas historias a la lista existente
                self.events += newEvents
                self.updateUI(with: self.events)
                
            case .failure(let error):
                print("Error: \(error)")
            }
            
            self.isLoading = false
        }
    }

    func fetchMarvelEvents(completion: @escaping (Result<[Events], Error>) -> Void) {
        let publicKey = "91876cd71efdc7d4d08056257a5dd7bf"
        let privateKey = "4b31ba5c27608c34ec0d47763e976f32001d59e6"
        let baseURL = "https://gateway.marvel.com/v1/public/events"

        // Construir la URL con las claves y otros parámetros
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

                        // Acceder a la matriz de eventos dentro de la respuesta
                        let events = marvelResponse.data.results

                        // Actualizar la interfaz de usuario en el hilo principal
                        DispatchQueue.main.async {
                            completion(.success(events))
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let offsetY = scrollView.contentOffset.y
           let contentHeight = scrollView.contentSize.height
           
           // Verificar si el usuario ha llegado al final de la tabla y cargar más historias
           if offsetY > contentHeight - scrollView.frame.size.height {
               loadMoreEvent()
           }
       }

    func updateUI(with events: [Events]) {
        self.events = events
        DispatchQueue.main.async {
            self.eventsTable.reloadData()
        }
    }

    @IBOutlet weak var eventsTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMarvelEvents { result in
            switch result {
            case .success(let events):
                // Procesa los eventos y actualiza la interfaz de usuario
                self.updateUI(with: events)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        eventsTable.dataSource = self
        eventsTable.delegate = self
        eventsTable.reloadData()
    }

    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventsTable.dequeueReusableCell(withIdentifier: "eventCell" , for : indexPath)
        let event = events[indexPath.row]
        cell.textLabel?.text = event.title
        cell.detailTextLabel?.text = "\(event.issueNumber ?? 0)"  // Cambiado para que coincida con la estructura de la segunda clase
        cell.imageView?.image = UIImage(systemName: "film.circle.fill")  // Cambiado para que coincida con la estructura de la segunda clase
        return cell
    }

    // MARK: - UITableViewDelegate Methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "transicionDesdeDetalleAListaStories", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "vistaDeDetalle" {
            if let indexPath = eventsTable.indexPathForSelectedRow,
               let destinationVC = segue.destination as? CharacterDetailViewController {
                // Evento seleccionado
                let selectedEvent = events[indexPath.row]

                // Asignamos el evento al CharacterDetailViewController
                destinationVC.comicModel = ComicsModel(title: selectedEvent.title)
            }
        }
    }
}

