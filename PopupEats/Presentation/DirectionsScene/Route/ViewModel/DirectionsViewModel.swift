//
//  DirectionsViewModel.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/09.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import Foundation


protocol DirectionsViewModelOutput {
    var route: Route { get }
    var directionTo: String { get }
}

protocol DirectionsViewModel: DirectionsViewModelOutput {}

final class DefaultDirectionsViewModel: DirectionsViewModel {

    // MARK: - OUTPUT

    let route: Route
    let directionTo: String

    // MARK: - Init

    init(route: Route,
         restuarant: Restuarant) {
        self.route = route
        self.directionTo = "Directoions to \(restuarant.name)"
    }
}
