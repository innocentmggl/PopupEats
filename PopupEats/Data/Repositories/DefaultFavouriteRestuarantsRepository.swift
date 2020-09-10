//
//  DefaultRestuarantsQueriesRepository.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/06.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import Foundation

final class DefaultFavouriteRestuarantsRepository {
    private let key = "FAVOURITE_RESTUARANTS"
    private let keyStore = NSUbiquitousKeyValueStore()
}

extension DefaultFavouriteRestuarantsRepository: FavouriteRestuarantsRepository {


    func favourites(completion: @escaping (Result<[String:Any], Error>) -> Void){
        if let favs = keyStore.dictionary(forKey: key) {
            completion(Result.success(favs))
        }
    }

    func saveAsFavourite(place: [String:Any]){
        keyStore.set(place, forKey: key)
    }
}



