//
//  AppDelegate.swift
//  ChocolateExamples
//
//  Created by 許郁棋 on 2016/7/2.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    // MARK: Property
    
    var window: UIWindow?
    
    
    // MARK: UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let catalogueTableViewController = CatalogueTableViewController()
        let navigationController = UINavigationController(rootViewController: catalogueTableViewController)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        self.window = window
        
        return true
        
    }

}
