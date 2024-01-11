//
//  EventsListViewModel.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste on 11/1/24.
//

import Foundation

class EventsListViewModel {
    var view: EventsListViewController
    
    private let eventsListCoordinator: EventsListCoordinator  // Conserva el nombre del coordinador

    init(eventsListCoordinator: EventsListCoordinator,
         view: EventsListViewController) {
        self.eventsListCoordinator = eventsListCoordinator
        self.view = view
    }
}

