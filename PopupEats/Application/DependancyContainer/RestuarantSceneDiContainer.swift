//
//  RestuarantSceneDiContainer.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/07.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import UIKit

final class RestuarantSceneDiContainer {

    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    private weak var navigationController: UINavigationController?
    private weak var restuarantListVC: RestuarantListViewController?
    private weak var favouriteQueriesSuggestionsVC: UIViewController?

    // MARK: - Persistent Storage
    //icloud fvorites

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Use Cases
    func makeRestuarantUseCase() -> SearchRestuarantsUseCase {
        return DefaultSearchRestuarantUseCase(repository: makeRestuarantRepository())
    }

    // MARK: - Repositories
    func makeRestuarantRepository() -> RestuarantsRepository {
        return DefaultRestuarantsRepository(dataTransferService: dependencies.apiDataTransferService)
    }

    func makeRestuarantImagesRepository() -> RestuarantImageRepository {
        return DefaultRestuarantImageRepository(dataTransferService: dependencies.imageDataTransferService)
    }

    // MARK: - Restuarant List
    func makeRestuarantListViewController(actions: RestuarantListViewModelActions) -> RestuarantListViewController {
        return RestuarantListViewController.create(with: makeRestuarantListViewModel(actions: actions),
                                                   imagesRepository: makeRestuarantImagesRepository())
    }

    func makeRestuarantListViewModel(actions: RestuarantListViewModelActions) -> RestuarantListViewModel {
        return DefaultRestuarantListViewModel(searchRestuarantsUseCase: makeRestuarantUseCase(),
                                          actions: actions)
    }

    func start(navigationController: UINavigationController?) {
        let actions = RestuarantListViewModelActions(showRouteDetails: showRouteDetails,
                                                     showRestuarantQueriesSuggestions: showRestuarantQueriesSuggestions,
                                                     closeRestuarantQueriesSuggestions: closeRestuarantQueriesSuggestions)
        let vc = makeRestuarantListViewController(actions: actions)
        self.navigationController = navigationController
        navigationController?.pushViewController(vc, animated: false)
    }

    func makeDirectionsViewModel(route: Route, restuarant: Restuarant) -> DirectionsViewModel {
        return DefaultDirectionsViewModel(route: route, restuarant: restuarant)
    }

    func makeDirectionsViewController(viewmodel: DirectionsViewModel) -> DirectionsViewController {
        return DirectionsViewController(viewModel: viewmodel)
    }

    private func showRouteDetails(route: Route, restuarant: Restuarant) {
        let viewModel = makeDirectionsViewModel(route: route, restuarant: restuarant)
        let viewController = makeDirectionsViewController(viewmodel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    private func showRestuarantQueriesSuggestions(didSelect: @escaping (RestuarantQuery) -> Void) {
        //TODO: - hide favorites
    }

    private func closeRestuarantQueriesSuggestions() {
        //TODO: - hide favorites
    }
}
