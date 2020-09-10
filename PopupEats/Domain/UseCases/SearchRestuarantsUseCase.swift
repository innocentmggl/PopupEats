//
//  SearchRestuarantsUseCase.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/06.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import Foundation

protocol SearchRestuarantsUseCase {
    func execute(requestValue: SearchMoviesUseCaseRequestValue,
                 completion: @escaping (Result<RestuarantsPage, DataTransferError>) -> Void) -> Cancellable?
}

final class DefaultSearchRestuarantUseCase: SearchRestuarantsUseCase {

    private let restuarantsRepository: RestuarantsRepository

    init(repository: RestuarantsRepository) {
        self.restuarantsRepository = repository
    }

    func execute(requestValue: SearchMoviesUseCaseRequestValue,
                 completion: @escaping (Result<RestuarantsPage, DataTransferError>) -> Void) -> Cancellable? {
        return restuarantsRepository.restuarantsList(query: requestValue.query) { result in
            switch result {
            case .success:
              completion(result)
            case .failure:
                completion(result)
            }
        }
    }
}

struct SearchMoviesUseCaseRequestValue {
    let query: RestuarantQuery
}
