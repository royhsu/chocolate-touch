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
    
    enum Row: Int {
        
        case Plain
        
        var title: String {
        
            switch self {
            case .Plain: return "Plain"
            }
        
        }
    
    }
    
    let rows: [Row] = [ .Plain ]
    
    lazy var listTableViewController: TWTableViewController<TWTableViewCell> = { [unowned self] in
    
        let controller = TWTableViewController(cellType: TWTableViewCell.self)
        
        controller.navigationItem.title = "TWKit"
        controller.cellHeight = .Fixed(height: 44.0)
        controller.cellConfigurator = { cell, index in
            
            cell.textLabel?.text = self.rows[index].title
            
        }
        controller.numberOfRows = self.rows.count
        controller.tableView.delegate = self
        
        return controller
        
    }()

}


// MARK: - UIApplicationDelegate

extension AppDelegate: UIApplicationDelegate {
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = UINavigationController(rootViewController: listTableViewController)
        window?.makeKeyAndVisible()
        
        return true
        
    }
    
}


// MARK: - UITableViewDelegate

extension AppDelegate: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let row = rows[indexPath.row]
        
        switch row {
        case .Plain: print(row.title)
        }
        
    }
    
}
