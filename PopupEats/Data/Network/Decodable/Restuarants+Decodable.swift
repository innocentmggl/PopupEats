//
//  Restuarants+Decodable.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/06.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import Foundation
extension RestuarantsPage: Decodable {

    private enum CodingKeys: String, CodingKey {
        case nextPageToken = "next_page_token"
        case restuarants = "results"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.nextPageToken = try container.decodeIfPresent(String.self, forKey: .nextPageToken)
        self.restuarants = try container.decode([Restuarant].self, forKey: .restuarants)
    }
}

extension Restuarant: Decodable {

    private enum CodingKeys: String, CodingKey {
        case id = "place_id"
        case name, rating, types,vicinity,photos,geometry
        case priceLevel = "price_level"
        case totalUserRatings = "user_ratings_total"
        case operatingHours = "opening_hours"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = PlaceId(try container.decode(String.self, forKey: .id))
        self.name = try container.decode(String.self, forKey: .name)
        self.rating = try container.decode(Double.self, forKey: .rating)
        self.types = try container.decode([String].self, forKey: .types)
        self.vicinity = try container.decode(String.self, forKey: .vicinity)
        self.priceLevel = try container.decodeIfPresent(Int.self, forKey: .priceLevel)
        self.totalUserRatings = try container.decode(Int.self, forKey: .totalUserRatings)
        self.operatingHours = try container.decodeIfPresent(OpeningHours.self, forKey: .operatingHours)
        self.photos = try container.decodeIfPresent([Photos].self, forKey: .photos)
        self.geometry = try container.decode(Geometry.self, forKey: .geometry)
    }
}

extension OpeningHours: Decodable {

    private enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.openNow = try container.decode(Bool.self, forKey: .openNow)
    }
}

extension Photos: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case height, width, reference = "photo_reference"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.height = try container.decode(Double.self, forKey: .height)
        self.width = try container.decode(Double.self, forKey: .width)
        self.reference = try container.decode(String.self, forKey: .reference)
    }
}

extension Geometry: Decodable {

    private enum CodingKeys: String, CodingKey {
        case location
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.location = try container.decode(Location.self, forKey: .location)
    }
}

extension Location: Decodable {

    private enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
    }
}


