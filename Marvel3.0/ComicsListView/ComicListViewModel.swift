//
//  ComicListViewModel.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste on 21/12/23.
//

import Foundation
 
class ComicListViewModel {
    var view: ComicListViewController
    
    private let comicListCoordinator: ComicListCoordinator

    init(comicListCoordinator: ComicListCoordinator,
         view: ComicListViewController) {
        self.comicListCoordinator = comicListCoordinator
        self.view = view
        
    }
}


