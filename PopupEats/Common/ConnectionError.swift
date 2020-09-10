//
//  ConnectionError.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/10.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import Foundation
public protocol ConnectionError: Error {
    var isInternetConnectionError: Bool { get }
}

public extension Error {
    var isInternetConnectionError: Bool {
        guard let error = self as? ConnectionError, error.isInternetConnectionError else {
            return false
        }
        return true
    }
}
