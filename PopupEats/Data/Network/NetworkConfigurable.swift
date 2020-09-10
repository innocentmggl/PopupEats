//
//  NetworkConfigurable.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/06.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import Foundation

public protocol NetworkConfigurable {
    var baseURL: URL { get }
    var queryParameters: [String: String] { get }
}

public struct ApiDataNetworkConfig: NetworkConfigurable {
    public let baseURL: URL
    public let queryParameters: [String: String]

     public init(baseURL: URL,
                 queryParameters: [String: String] = [:]) {
        self.baseURL = baseURL
        self.queryParameters = queryParameters
    }
}
