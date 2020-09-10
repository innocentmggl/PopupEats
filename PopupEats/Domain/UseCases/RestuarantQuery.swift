//
//  RestuarantQuery.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/06.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import Foundation

struct RestuarantQuery {
    let query: String
    let latLong: String
    let searchRadius: Double
}

extension RestuarantQuery: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(query)
    }
}
