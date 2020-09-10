//
//  Route.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/09.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import MapKit

struct Route {
  let origin: MKMapItem
  let destination: MKMapItem

  var annotations: [MKAnnotation] {
    var annotations: [MKAnnotation] = []

    annotations.append(
      RouteAnnotation(item: origin)
    )

    annotations.append(
      RouteAnnotation(item: destination)
    )

    return annotations
  }

  var destinationAddress: String {
      return destination.name ?? "Restuarant"
  }
}
