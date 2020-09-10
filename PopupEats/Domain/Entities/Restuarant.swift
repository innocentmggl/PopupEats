//
//  Restuarant.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/06.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import Foundation

struct RestuarantsPage {
    let nextPageToken: String?
    let restuarants: [Restuarant]
}

typealias PlaceId = String

struct Restuarant {
    let id: PlaceId
    let name: String
    let rating: Double
    let types: [String]
    let vicinity: String
    let priceLevel: Int?
    let totalUserRatings: Int
    let operatingHours: OpeningHours?
    let photos: [Photos]?
    let geometry: Geometry
}

extension Restuarant: Hashable {
    static func == (lhs: Restuarant, rhs: Restuarant) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct OpeningHours {
    let openNow: Bool
}


struct Photos {
    let height: Double
    let width: Double
    let reference: String
}

struct Geometry {
    let location: Location
}

struct Location {
    let latitude: Double
    let longitude: Double
}
