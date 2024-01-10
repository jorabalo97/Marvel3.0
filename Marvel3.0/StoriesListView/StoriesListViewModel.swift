//
//  SeriesListViewModel.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste on 10/1/24.
//


import Foundation
class StoriesListViewModel {
    var view: StoriesListViewController
    
    private let storiesListCoordinator: StoriesListCoordinator

    init(storiesListCoordinator: StoriesListCoordinator,
         view: StoriesListViewController) {
        self.storiesListCoordinator = storiesListCoordinator
        self.view = view
    }
}
