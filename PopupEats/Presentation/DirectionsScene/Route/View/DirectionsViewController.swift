//
//  DirectionsViewController.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/09.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import UIKit
import MapKit

class DirectionsViewController: UIViewController {
  @IBOutlet private var mapView: MKMapView!
  @IBOutlet private var headerLabel: UILabel!
  @IBOutlet private var tableView: UITableView!
  @IBOutlet private var informationLabel: UILabel!
  @IBOutlet private var destinationLabel: UILabel!
  @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!

  private let cellIdentifier = "DirectionsCell"
  private let distanceFormatter = MKDistanceFormatter()

  private let viewModel: DirectionsViewModel

  private var mapRoutes: [MKRoute] = []
  private var totalTravelTime: TimeInterval = 0
  private var totalDistance: CLLocationDistance = 0

  private var groupedRoutes: [(startItem: MKMapItem, endItem: MKMapItem)] = []

  init(viewModel: DirectionsViewModel) {
    self.viewModel = viewModel

    super.init(nibName: String(describing: DirectionsViewController.self), bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    groupAndRequestDirections()

    headerLabel.text = viewModel.directionTo
    destinationLabel.text = viewModel.route.destinationAddress

    tableView.dataSource = self

    mapView.delegate = self
    mapView.showAnnotations(viewModel.route.annotations, animated: false)
  }

  // MARK: - Helpers

  private func groupAndRequestDirections() {
    groupedRoutes.append((viewModel.route.origin, viewModel.route.destination))
    fetchNextRoute()
  }

  private func fetchNextRoute() {
    guard !groupedRoutes.isEmpty else {
      activityIndicatorView.stopAnimating()
      return
    }

    let nextGroup = groupedRoutes.removeFirst()
    let request = MKDirections.Request()

    request.source = nextGroup.startItem
    request.destination = nextGroup.endItem

    let directions = MKDirections(request: request)

    directions.calculate { response, error in
      guard let mapRoute = response?.routes.first else {
        self.informationLabel.text = error?.localizedDescription
        self.activityIndicatorView.stopAnimating()
        return
      }

      self.updateView(with: mapRoute)
      self.fetchNextRoute()
    }
  }

  private func updateView(with mapRoute: MKRoute) {
    let padding: CGFloat = 8
    mapView.addOverlay(mapRoute.polyline)
    mapView.setVisibleMapRect(
      mapView.visibleMapRect.union(
        mapRoute.polyline.boundingMapRect
      ),
      edgePadding: UIEdgeInsets(
        top: 0,
        left: padding,
        bottom: padding,
        right: padding
      ),
      animated: true
    )

    totalDistance += mapRoute.distance
    totalTravelTime += mapRoute.expectedTravelTime

    let informationComponents = [
      totalTravelTime.formatted,
      "• \(distanceFormatter.string(fromDistance: totalDistance))"
    ]
    informationLabel.text = informationComponents.joined(separator: " ")

    mapRoutes.append(mapRoute)
    tableView.reloadData()
  }
}

// MARK: - UITableViewDataSource

extension DirectionsViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return mapRoutes.isEmpty ? 0 : mapRoutes.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let route = mapRoutes[section]
    return route.steps.count - 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = { () -> UITableViewCell in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) else {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        cell.selectionStyle = .none
        return cell
      }
      return cell
    }()

    let route = mapRoutes[indexPath.section]
    let step = route.steps[indexPath.row + 1]

    cell.textLabel?.text = "\(indexPath.row + 1): \(step.notice ?? step.instructions)"
    cell.detailTextLabel?.text = distanceFormatter.string(
      fromDistance: step.distance
    )

    return cell
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let route = mapRoutes[section]
    return route.name
  }
}

// MARK: - MKMapViewDelegate

extension DirectionsViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let renderer = MKPolylineRenderer(overlay: overlay)

    renderer.strokeColor = .systemBlue
    renderer.lineWidth = 3

    return renderer
  }
}
