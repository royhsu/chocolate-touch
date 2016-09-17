//
//  ProductTableViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/9/16.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
import Chocolate
import PromiseKit
import UIKit

class ProductTableViewController: CHCacheTableViewController {

    
    // MARK: Property
    
    let productIdentifier: String
    
    
    // MARK: Init
    
    init(productIdentifier: String) {
        
        self.productIdentifier = productIdentifier
        
        super.init(cacheIdentifier: productIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError()
        
    }
    
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webRequests.append(productRequest)
        
    }
    
    
    // MARK: CHFetchedResultsTableViewControllerDelegate
    
    override func fetchedResultsControllerDidSetUp() {
        
        if !isCached { let _ = fetch() }
        
    }
    
    
    // MARK: Request
    
    private var productRequest: CHCacheWebRequest {
        
        let url = URL(string: "https://product.com")!
        let urlRequest = URLRequest(url: url)
        var webService = WebService<Any>(urlRequest: urlRequest)
        
        let mockSession = MockURLSession()
        let jsonObject: [String: Any] = [
            "id": productIdentifier,
            "price": 1000.0,
            "quantity": 15,
            "title": "Cras Justo Pharetra Vulputate Adipiscing",
            "description": "Cras justo odio, dapibus ac facilisis in, egestas eget quam. Sed posuere consectetur est at lobortis. Lorem ipsum dolor sit amet, consectetur adipiscing elit."
        ]
        mockSession.data = try! JSONSerialization.data(
            withJSONObject: jsonObject,
            options: []
        )
        
        webService.urlSession = mockSession
        
        let webServiceGroup = WebServiceGroup(webServices: [ webService ])
        
        let webRequest = CHCacheWebRequest(webServiceGroup: webServiceGroup) { objects in
            
            return objects.first!
            
        }
        
        return webRequest
        
    }
    
    
    // MARK: CHCacheTableViewDataSource
    
    override func numberOfSections() -> Int {
        
        return 1
        
    }
    
    override func numberOfRows(in section: Int) -> Int {
        
        return 2
        
    }
    
    
    // MARK: UITableViewDataSource
    
    override func configure(cell: CHTableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.textLabel?.text = "Test"
        
    }
    
}
