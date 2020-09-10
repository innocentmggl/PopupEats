//
//  AppDelegate.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/05.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let appDIContainer = DIContainer()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppAppearance.setupAppearance()

        window = UIWindow(frame: UIScreen.main.bounds)

        let navigationController = UINavigationController()

        window?.rootViewController = navigationController

        let flow = appDIContainer.makeRestuarantSceneDIContainer()
        flow.start(navigationController: navigationController)
        window?.makeKeyAndVisible()
        return true
    }
}

