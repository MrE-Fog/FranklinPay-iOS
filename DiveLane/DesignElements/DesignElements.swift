//
//  GeometricPrimitives.swift
//  DiveLane
//
//  Created by Anton Grigorev on 25.09.2018.
//  Copyright © 2018 Matter Inc. All rights reserved.
//

import UIKit

public class DesignElements {
    public func navigationController(withTitle: String?, withImage: UIImage?,
                                     withController: UIViewController,
                                     tag: Int) -> UINavigationController {
        let nav = UINavigationController()
        nav.navigationBar.barTintColor = Colors.firstMain
        nav.navigationBar.tintColor = Colors.secondMain
        let font = UIFont(name: Constants.boldFont, size: Constants.basicFontSize) ?? UIFont.boldSystemFont(ofSize: Constants.basicFontSize)
        nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: font]
        let controller = withController
        controller.title = withTitle
        nav.viewControllers = [controller]
        nav.tabBarItem = UITabBarItem(title: nil, image: withImage, tag: tag)
        return nav
    }
}