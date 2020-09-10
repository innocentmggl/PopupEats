//
//  RouteBuilder.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/09.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import MapKit

enum RouteBuilder {
    
    enum RouteError: Error {
        case invalidSegment(String)
    }

    typealias PlaceCompletionBlock = (MKPlacemark?) -> Void
    typealias RouteCompletionBlock = (Result<Route, RouteError>) -> Void

    private static let routeQueue = DispatchQueue(label: "com.innocent.PopupEats.route-builder")

    static func buildRoute(origin: CLLocation, destination: CLLocation, within region: MKCoordinateRegion?, completion: @escaping RouteCompletionBlock) {
        routeQueue.async {
            let group = DispatchGroup()

            var originItem: MKMapItem?
            group.enter()
            requestPlace(for: origin, within: region) { place in
                if let requestedPlace = place {
                    originItem = MKMapItem(placemark: requestedPlace)
                }
                group.leave()
            }

            var destinationItem: MKMapItem?
            group.enter()
            requestPlace(for: destination, within: region) { place in
                if let requestedPlace = place {
                    destinationItem = MKMapItem(placemark: requestedPlace)
                }
                group.leave()
            }

            group.notify(queue: .main) {
                if let originMapItem = originItem, let destinationMapItem = destinationItem {
                    let route = Route(origin: originMapItem, destination: destinationMapItem)
                    completion(.success(route))
                } else {
                    let reason = originItem == nil ? "the origin address" : "one or more of the stops"
                    completion(.failure(.invalidSegment(reason)))
                }
            }
        }
    }

    private static func requestPlace(for location: CLLocation, within region: MKCoordinateRegion?, completion: @escaping PlaceCompletionBlock) {
        CLGeocoder().geocodeSegment(location) { places, _ in
            let place: MKPlacemark?

            if let firstPlace = places?.first {
                place = MKPlacemark(placemark: firstPlace)
            } else {
                place = nil
            }

            completion(place)
        }
    }
}

private extension CLGeocoder {
    func geocodeSegment(_ location: CLLocation, completionHandler: @escaping CLGeocodeCompletionHandler) {
        reverseGeocodeLocation(location, completionHandler: completionHandler)
    }
}
