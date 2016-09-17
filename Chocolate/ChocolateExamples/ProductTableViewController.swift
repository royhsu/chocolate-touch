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

    enum Section: Int { case information }
    enum InformationRow: Int { case title, price, quantity }
    
    
    // MARK: Property
    
    let productIdentifier: String
    let sections: [Section] = [ .information ]
    let informationRows: [InformationRow] = [ .title, .price, .quantity ]
    
    
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
        
        refreshControl = setUpRefreshControl()
        
        webRequests.append(productRequest)
        
    }
    
    
    // MARK: Set Up
    
    private func setUpRefreshControl() -> UIRefreshControl {
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: .pullToRefresh, for: .valueChanged)
        
        return refreshControl
        
    }
    
    
    // MARK: Action
    
    func pullToRefresh(refreshControl: UIRefreshControl) {
        
        let _ =
            refresh()
            .always { refreshControl.endRefreshing() }
        
    }
    
    
    // MARK: CHFetchedResultsTableViewControllerDelegate
    
    override func fetchedResultsControllerDidSetUp() {
        
        if !isCached {
            
            let _ = fetch()
        
        }
        
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
        
        return sections.count
        
    }
    
    override func numberOfRows(in section: Int) -> Int {
        
        guard
            let section = Section(rawValue: section)
            else { return 0 }
        
        switch section {
        case .information: return informationRows.count
        }
        
    }
    
    override func jsonObject(with objects: [Any], forRowsAt indexPath: IndexPath) -> Any? {
        
        guard
            let section = Section(rawValue: indexPath.section)
            else { return 0 }
        
        switch section {
        case .information: return objects[0]
        }
        
    }
    
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard
            let section = Section(rawValue: section)
            else { return nil }
        
        switch section {
        case .information: return "Information"
        }
        
    }
    
    override func configure(cell: CHTableViewCell, forRowAt indexPath: IndexPath) {
        
        guard
            let section = Section(rawValue: indexPath.section)
            else { return }
        
        switch section {
        case .information:
        
            guard
                let row = InformationRow(rawValue: indexPath.row),
                let cache = fetchedResultsController?.object(at: indexPath),
                let jsonObject = try? cache.data.jsonObject(),
                let json = jsonObject as? [String: Any]
                else { return }
            
            
            switch row {
            case .title:
                
                if let title = json["title"] as? String {
                    
                    cell.textLabel?.text = "Title: \(title)"
                    
                }
                else {
                
                    cell.textLabel?.text = "No title"
                
                }
                
            case .price:
                
                
                if let price = json["price"] as? Double {
                 
                    cell.textLabel?.text = "Price: \(price)"
                
                }
                else {
                    
                    cell.textLabel?.text = "No price"
                    
                }
                
            case .quantity:
                
                if let quantity = json["quantity"] as? Int {
                    
                    cell.textLabel?.text = "Quantity: \(quantity)"
                    
                }
                else {
                    
                    cell.textLabel?.text = "No quantity"
                    
                }
            }
            
        }
        
    }
    
}


// MARK: Selector

private extension Selector {
    
    static let pullToRefresh = #selector(ProductTableViewController.pullToRefresh)
    
}
