//
//  ComicListCoordinator.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste on 21/12/23.
//

import UIKit

class ComicListCoordinator {
    weak var navigationController: UINavigationController?
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start(){
        navigationController?.pushViewController(build(), animated: true)
    }
    
    func build() -> UIViewController {
        let comicListViewController = ComicListViewController()
        let comicListViewModel = ComicListViewModel(comicListCoordinator: self, view: comicListViewController)
        comicListViewController.viewModel = comicListViewModel
        
        return comicListViewController
    }
}

