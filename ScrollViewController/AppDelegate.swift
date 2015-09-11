//
//  AppDelegate.swift
//  ScrollViewController
//
//  Created by Dmitry Nesterenko on 30.08.15.
//  Copyright © 2015 Dmitry Nesterenko. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let scrollViewController = ScrollViewController(contentViewController: ContentViewController())
        let navigationController = UINavigationController(rootViewController: scrollViewController)
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        return true
    }

}

