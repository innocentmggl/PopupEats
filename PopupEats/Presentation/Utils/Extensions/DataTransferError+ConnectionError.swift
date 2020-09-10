//
//  DataTransferError+ConnectionError.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/10.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import Foundation

extension DataTransferError: ConnectionError {
    public var isInternetConnectionError: Bool {
        guard case let DataTransferError.networkFailure(networkError) = self,
            case .notConnected = networkError else {
                return false
        }
        return true
    }
}
