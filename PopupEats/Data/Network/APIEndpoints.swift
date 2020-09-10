//
//  APIEndpoints.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/06.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import Foundation

struct APIEndpoints {

    static func restuarants(query: String, latLong: String, searchRadius: Double) -> Endpoint<RestuarantsPage> {

        return Endpoint(path: "nearbysearch/json",
                        method: .get,
                        queryParameters: ["keyword": query,
                                          "location": latLong,
                                          "radius" : searchRadius,
                                          "type": "restaurant"])
    }

    static func image(reference: String, width: Int) -> Endpoint<Data> {
        return Endpoint(path: "photo",
                        method: .get,
                        queryParameters: ["photoreference": reference,
                                          "maxwidth": width],
                        responseDecoder: RawDataResponseDecoder())
    }
}
