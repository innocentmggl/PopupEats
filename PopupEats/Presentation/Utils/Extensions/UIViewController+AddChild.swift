//
//  UIViewController+AddChild.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/10.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import UIKit

extension UIViewController {

    func add(child: UIViewController, container: UIView) {
        addChild(child)
        child.view.frame = container.bounds
        container.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}
