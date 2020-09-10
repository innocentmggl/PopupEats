//
//  DIContainer.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/05.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import Foundation

final class DIContainer {

    private let appConfiguration = Configurations()

    // MARK: - Network
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!,
                                          queryParameters: ["key": appConfiguration.apiKey])

        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()

    lazy var imageDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.imagesBaseURL)!,
                                          queryParameters: ["key": appConfiguration.apiKey])
        let imagesDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: imagesDataNetwork)
    }()

    // MARK: - DIContainers of scenes
    func makeRestuarantSceneDIContainer() -> RestuarantSceneDiContainer {
        let dependencies = RestuarantSceneDiContainer.Dependencies(apiDataTransferService: apiDataTransferService,
                                                               imageDataTransferService: imageDataTransferService)
        return RestuarantSceneDiContainer(dependencies: dependencies)
    }
}
