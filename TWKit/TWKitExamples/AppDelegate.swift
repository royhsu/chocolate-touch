//
//  AppDelegate.swift
//  TWKitExamples
//
//  Created by 許郁棋 on 2016/6/28.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder {

    var window: UIWindow?

}


// MARK: - UIApplicationDelegate

extension AppDelegate: UIApplicationDelegate {
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let catalogueTableViewController = CatalogueTableViewController()
        let navigationController = UINavigationController(rootViewController: catalogueTableViewController)
        
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        self.window = window
        
        return true
        
    }
    
}
