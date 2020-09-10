//
//  AppAppearance.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/07.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import Foundation
import UIKit

final class AppAppearance {

    static func setupAppearance() {
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .darkGray
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
    }
}

extension UINavigationController {
    @objc override open var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
}
