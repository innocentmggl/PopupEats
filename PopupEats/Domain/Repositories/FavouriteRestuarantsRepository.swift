//
//  FavouriteRestuarantsRepository.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/06.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import Foundation

protocol FavouriteRestuarantsRepository {
    func favourites(completion: @escaping (Result<[String:Any], Error>) -> Void)
    func saveAsFavourite(place: [String:Any])
}
