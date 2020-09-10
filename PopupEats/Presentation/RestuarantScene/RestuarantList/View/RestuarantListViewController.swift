//
//  RestuarantListViewController.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/05.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

final class RestuarantListViewController: UIViewController, StoryboardInstantiable, Alertable {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private var restuarantsListContainer: UIView!
    @IBOutlet private(set) var suggestionsListContainer: UIView!
    @IBOutlet private var searchBarContainer: UIView!
    @IBOutlet private var emptyDataLabel: UILabel!

    private var viewModel: RestuarantListViewModel!
    private var imagesRepository: RestuarantImageRepository?

    private var moviesTableViewController: RestuarantListTableViewController?
    private var searchController = UISearchController(searchResultsController: nil)
    private let locationManager = CLLocationManager()
    private var currentRegion: MKCoordinateRegion?

    // MARK: - Lifecycle

    static func create(with viewModel: RestuarantListViewModel,
                       imagesRepository: RestuarantImageRepository?) -> RestuarantListViewController {
        let view = RestuarantListViewController.instantiateViewController()
        view.viewModel = viewModel
        view.imagesRepository = imagesRepository
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind(to: viewModel)
        attemptLocationAccess()
        viewModel.viewDidLoad()
    }

    private func bind(to viewModel: RestuarantListViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.updateItems() }
        viewModel.loading.observe(on: self) { [weak self] in self?.updateLoading($0) }
        viewModel.query.observe(on: self) { [weak self] in self?.updateSearchQuery($0) }
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
        viewModel.message.observe(on: self) { [weak self] in self?.emptyDataLabel.text = $0 }
    }

    private func attemptLocationAccess() {
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self

        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.requestLocation()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.isActive = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: RestuarantListTableViewController.self),
            let destinationVC = segue.destination as? RestuarantListTableViewController {
            moviesTableViewController = destinationVC
            moviesTableViewController?.viewModel = viewModel
            moviesTableViewController?.imagesRepository = imagesRepository
        }
    }

    // MARK: - Private

    private func setupViews() {
        title = viewModel.screenTitle
        setupSearchController()
    }


    private func updateItems() {
        moviesTableViewController?.reload()
    }

    private func updateLoading(_ loading: RestuarantListViewModelLoading?) {
        emptyDataLabel.isHidden = true
        restuarantsListContainer.isHidden = true
        suggestionsListContainer.isHidden = true
        LoadingView.hide()

        switch loading {
        case .fullScreen: LoadingView.show()
        case .nextPage: restuarantsListContainer.isHidden = false
        case .none:
            restuarantsListContainer.isHidden = viewModel.isEmpty
            emptyDataLabel.isHidden = !viewModel.isEmpty
        }
        updateQueriesSuggestions()
    }

    private func updateQueriesSuggestions() {
        guard searchController.searchBar.isFirstResponder else {
            viewModel.closeQueriesSuggestions()
            return
        }
        viewModel.showQueriesSuggestions()
    }

    private func updateSearchQuery(_ query: String) {
        searchController.isActive = false
        searchController.searchBar.text = query
    }

    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: viewModel.errorTitle, message: error)
    }
}

// MARK: - Search Controller

extension RestuarantListViewController {
    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = viewModel.searchBarPlaceholder
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.frame = searchBarContainer.bounds
        searchController.searchBar.autoresizingMask = [.flexibleWidth]
        searchBarContainer.addSubview(searchController.searchBar)
        definesPresentationContext = true
    }
}

extension RestuarantListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchController.isActive = false
        viewModel.didSearch(query: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didCancelSearch()
    }
}

extension RestuarantListViewController: UISearchControllerDelegate {
    public func willPresentSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestions()
    }

    public func willDismissSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestions()
    }

    public func didDismissSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestions()
    }
}

// MARK: - CLLocationManagerDelegate

extension RestuarantListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }

        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first else {
            return
        }
        
        viewModel.locationhelper.userLocation = firstLocation

        let commonDelta: CLLocationDegrees = 25 / 111 // 1/111 = 1 latitude km
        let span = MKCoordinateSpan(latitudeDelta: commonDelta, longitudeDelta: commonDelta)
        let region = MKCoordinateRegion(center: firstLocation.coordinate, span: span)

        viewModel.locationhelper.currentRegion = region

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("Error requesting location: \(error.localizedDescription)")
    }
}
