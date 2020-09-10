//
//  TimeInterval+Additions.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/09.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import Foundation

extension TimeInterval {
  var formatted: String {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .full
    formatter.allowedUnits = [.hour, .minute]

    return formatter.string(from: self) ?? ""
  }
}
