//
//  RestuarantListItemViewModel.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/06.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import Foundation

struct RestuarantListItemViewModel: Equatable {
    let name: String
    let rating: String
    let operatingHours: String
    let isOpen: Bool
    let location: String?
    let photoReference: String?
}

extension RestuarantListItemViewModel {

    init(restuarant: Restuarant) {
        self.name = restuarant.name
        self.rating = restuarant.rating > 0 ? "Reviews: \(restuarant.rating) (\(restuarant.totalUserRatings))" : "No reviews"
        self.location = restuarant.vicinity
        self.photoReference = restuarant.photos?.first?.reference
        self.isOpen = restuarant.operatingHours?.openNow ?? false
        if let hours = restuarant.operatingHours?.openNow {
            let open = hours ? "Open" : "Closed"
            self.operatingHours = "\(open)"
        }
        else{
            self.operatingHours = "Trading hours unknown"
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()
