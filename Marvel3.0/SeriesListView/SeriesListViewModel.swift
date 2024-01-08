//
//  SeriesListViewModel.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste on 8/1/24.
//


import Foundation
 
class SeriesListViewModel {
    var view: SeriesListViewController
    
    private let seriesListCoordinator: SeriesListCoordinator

    init(seriesListCoordinator: SeriesListCoordinator,
         view: SeriesListViewController) {
        self.seriesListCoordinator = seriesListCoordinator
        self.view = view
        
    }
}
