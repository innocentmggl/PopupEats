//
//  RouteAnnotation.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/09.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import MapKit

class RouteAnnotation: NSObject {
  private let item: MKMapItem

  init(item: MKMapItem) {
    self.item = item

    super.init()
  }
}

// MARK: - MKAnnotation

extension RouteAnnotation: MKAnnotation {
  var coordinate: CLLocationCoordinate2D {
    return item.placemark.coordinate
  }

  var title: String? {
    return item.name
  }
}
