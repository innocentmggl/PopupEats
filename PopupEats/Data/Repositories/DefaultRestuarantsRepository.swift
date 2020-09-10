//
//  DefaultRestuarantsRepository.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/06.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import Foundation

final class DefaultRestuarantsRepository {

    private let dataTransferService: DataTransferService

    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultRestuarantsRepository: RestuarantsRepository {

     func restuarantsList(query: RestuarantQuery, completion: @escaping (Result<RestuarantsPage, DataTransferError>) -> Void) -> Cancellable? {

        let endpoint = APIEndpoints.restuarants(query: query.query, latLong: query.latLong, searchRadius: query.searchRadius)
        let networkTask = self.dataTransferService.request(with: endpoint, completion: completion)

        let task =  RepositoryTask()
        task.networkTask = networkTask
        return task
    }
}
