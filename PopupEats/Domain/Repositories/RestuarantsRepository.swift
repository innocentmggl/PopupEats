//
//  RestuarantsRepository.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/06.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import Foundation

protocol RestuarantsRepository {
    @discardableResult
    func restuarantsList(query: RestuarantQuery, completion: @escaping (Result<RestuarantsPage, DataTransferError>) -> Void) -> Cancellable?
}
