//
//  SeriesListCoordinator.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste on 8/1/24.
//
import Foundation
import UIKit

class SeriesListCoordinator {
    weak var navigationController: UINavigationController?
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start(){
        navigationController?.pushViewController(build(), animated: true)
    }
    
    func build() -> UIViewController {
        let seriesListViewController = SeriesListViewController()
        let seriesListViewModel = SeriesListViewModel(seriesListCoordinator: self, view: seriesListViewController)
        seriesListViewController.viewModel = seriesListViewModel
        
        return seriesListViewController
    }
}
