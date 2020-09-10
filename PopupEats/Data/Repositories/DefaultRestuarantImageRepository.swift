//
//  DefaultRestuarantImageRepository.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/06.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import Foundation

final class DefaultRestuarantImageRepository {

    private let dataTransferService: DataTransferService

    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultRestuarantImageRepository: RestuarantImageRepository {


    func fetchImage(with reference: String, width: Int, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable? {

        let endpoint = APIEndpoints.image(reference: reference, width: width)
        let task = RepositoryTask()
        task.networkTask = dataTransferService.request(with: endpoint) { (result: Result<Data, DataTransferError>) in

            let result = result.mapError { $0 as Error }
            DispatchQueue.main.async { completion(result) }
        }
        return task
    }
}
