//
//  LocationHelper.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/09.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class LocationHelper {

    var userLocation:CLLocation?
    var destination: CLLocation?
    var currentRegion: MKCoordinateRegion?
    var currentPlace: CLPlacemark?

    func destination(_ latitude: Double, longitude: Double) -> CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}
