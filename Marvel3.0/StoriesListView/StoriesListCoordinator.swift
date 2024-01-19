//
//  SeriesListCoordinator.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste on 10/1/24.
//

import Foundation
import UIKit

class StoriesListCoordinator {
 
    weak var navigationController: UINavigationController?
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    var selectedCharacter: CharacterModel?
    
    func start(){
        navigationController?.pushViewController(build(), animated: true)
    }
    
    func configure(with character: CharacterModel?) {
           selectedCharacter = character
       }

    func build() -> UIViewController { 
      
        let storiesListViewController = StoriesListViewController(storiesListCoordinator: self, viewModel: nil)
        let storiesListViewModel = StoriesListViewModel(storiesListCoordinator: self, view: storiesListViewController)
           storiesListViewController.viewModel = storiesListViewModel
        
                
       
        return storiesListViewController
    }
}
