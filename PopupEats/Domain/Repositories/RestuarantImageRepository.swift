//
//  RestuarantImageRepository.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/06.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import Foundation

protocol RestuarantImageRepository {
    func fetchImage(with reference: String, width: Int, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable?
}
