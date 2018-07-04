//
//  UINavigationController+Extension.swift
//  FoodPin
//
//  Created by 许有红 on 2018/6/21.
//  Copyright © 2018 EmptyWlaker. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return topViewController
    }
}
