//
//  EventsListCoordinator.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste on 11/1/24.
//

import UIKit

class EventsListCoordinator {
    weak var navigationController: UINavigationController?
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    var selectedCharacter: CharacterModel?  // Agregada para que coincida con la segunda clase

    func start() {
        navigationController?.pushViewController(build(), animated: true)
    }

    func configure(with character: CharacterModel?) {
        selectedCharacter = character
    }

    func build() -> UIViewController {
        let eventsListViewModel = EventsListViewModel(eventsListCoordinator: self)
        let eventsListViewController = EventsListViewController(viewModel: eventsListViewModel)
        return eventsListViewController
    }
}
