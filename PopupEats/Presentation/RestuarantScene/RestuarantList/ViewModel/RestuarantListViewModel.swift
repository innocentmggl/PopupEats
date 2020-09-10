//
//  RestuarantListViewModel.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/06.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import Foundation

struct RestuarantListViewModelActions {
    let showRouteDetails: (Route, Restuarant) -> Void
    let showRestuarantQueriesSuggestions: (@escaping (_ didSelect: RestuarantQuery) -> Void) -> Void
    let closeRestuarantQueriesSuggestions: () -> Void
}

enum RestuarantListViewModelLoading {
    case fullScreen
    case nextPage
}

protocol RestuarantListViewModelInput {
    func viewDidLoad()
    func didSearch(query: String)
    func didCancelSearch()
    func showQueriesSuggestions()
    func closeQueriesSuggestions()
    func didSelectItem(at index: Int)
}

protocol RestuarantListViewModelOutput {
    var items: Observable<[RestuarantListItemViewModel]> { get }
    var loading: Observable<RestuarantListViewModelLoading?> { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var message: Observable<String> { get }
    var isEmpty: Bool { get }
    var screenTitle: String { get }
    var errorTitle: String { get }
    var searchBarPlaceholder: String { get }
    var locationhelper: LocationHelper {get}
}

protocol RestuarantListViewModel: RestuarantListViewModelInput, RestuarantListViewModelOutput {}

final class DefaultRestuarantListViewModel: RestuarantListViewModel {

    private let searchRestuarantsUseCase: SearchRestuarantsUseCase
    private let actions: RestuarantListViewModelActions?

    private var pages: [RestuarantsPage] = []
    private var restuarantsLoadTask: Cancellable? { willSet { restuarantsLoadTask?.cancel() } }

    // MARK: - OUTPUT

    let items: Observable<[RestuarantListItemViewModel]> = Observable([])
    let loading: Observable<RestuarantListViewModelLoading?> = Observable(.none)
    let query: Observable<String> = Observable("")
    let error: Observable<String> = Observable("")
    let message: Observable<String> = Observable("")
    var isEmpty: Bool { return items.value.isEmpty }
    let screenTitle = NSLocalizedString("Restuarants", comment: "")
    let errorTitle = NSLocalizedString("Error", comment: "")
    let searchBarPlaceholder = NSLocalizedString("Search food...", comment: "")
    let locationhelper: LocationHelper = LocationHelper()

    // MARK: - Init

    init(searchRestuarantsUseCase: SearchRestuarantsUseCase,
         actions: RestuarantListViewModelActions? = nil) {
        self.searchRestuarantsUseCase = searchRestuarantsUseCase
        self.actions = actions
    }

    // MARK: - Private
    private func load(restuarantQuery: RestuarantQuery, loading: RestuarantListViewModelLoading) {
        self.loading.value = loading
        query.value = restuarantQuery.query

        restuarantsLoadTask = searchRestuarantsUseCase.execute(
            requestValue: .init(query: restuarantQuery),
            completion: { result in
                switch result {
                case .success(let page):
                    self.appendPage(page)
                case .failure(let error):
                    self.handle(error: error)
                }
                self.loading.value = .none
        })
    }

    private func appendPage(_ restuarantPage: RestuarantsPage) {
        guard restuarantPage.restuarants.count > 0 else {
            self.message.value = NSLocalizedString("No result for search criteria", comment: "")
            return
        }
        //support for the first page results at the moment
        pages = [restuarantPage]
        items.value = restuarantPage.restuarants.map(RestuarantListItemViewModel.init)
    }

    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ?
            NSLocalizedString("No internet connection", comment: "") :
            NSLocalizedString("Failed loading places", comment: "")
    }

    private func update(restuarantQuery: RestuarantQuery) {
        load(restuarantQuery: restuarantQuery, loading: .fullScreen)
    }
}

// MARK: - INPUT. View event methods

extension DefaultRestuarantListViewModel {

    func viewDidLoad() {
        self.message.value = NSLocalizedString("Enter food type to search for restuarants", comment: "")
    }

    func didSearch(query: String) {
        guard !query.isEmpty else { return }
        guard let coordinates = locationhelper.userLocation?.coordinate else {
            self.error.value = NSLocalizedString("No location found, please make sure you have granted location permissions", comment: "")
            return
        }
        update(restuarantQuery: RestuarantQuery(query: query,
                                           latLong: "\(coordinates.latitude),\(coordinates.longitude)",
                                           searchRadius: 5000))
    }

    func didCancelSearch() {
        restuarantsLoadTask?.cancel()
    }

    func showQueriesSuggestions() {
        actions?.showRestuarantQueriesSuggestions(update(restuarantQuery:))
    }

    func closeQueriesSuggestions() {
        actions?.closeRestuarantQueriesSuggestions()
    }

    func didSelectItem(at index: Int) {
        let restuarant = pages.restuarants[index]
        let coordinates = restuarant.geometry.location
        self.loading.value = .fullScreen
        RouteBuilder.buildRoute(
            origin: locationhelper.userLocation!,
            destination: locationhelper.destination(coordinates.latitude, longitude: coordinates.longitude),
            within: locationhelper.currentRegion
        ) {  result in
            self.loading.value = .none
            switch result {
            case .success(let route):
                self.actions?.showRouteDetails(route, restuarant)
            case .failure(let error):
                switch error {
                case .invalidSegment(let reason):
                    self.error.value = "There was an error with: \(reason)."
                }

            }
        }
    }
}

// MARK: - Private
private extension Array where Element == RestuarantsPage {
    var restuarants: [Restuarant] { flatMap { $0.restuarants } }
}
