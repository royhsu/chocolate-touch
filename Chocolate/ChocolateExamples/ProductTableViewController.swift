//
//  ProductTableViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/9/16.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
import Chocolate
import CoreData
import PromiseKit
import UIKit

class ProductTableViewController: CHCacheTableViewController {

    enum Section: Int { case information, description, comment }
    enum InformationRow: Int { case title, price, quantity }
    
    
    // MARK: Property
    
    let productIdentifier: String
    let sections: [Section] = [ .information, .description, .comment ]
    let informationRows: [InformationRow] = [ .title, .price, .quantity ]
    private var numberOfComments = 0
    
    
    // MARK: Init
    
    init(productIdentifier: String) {
        
        self.productIdentifier = productIdentifier
        
        super.init(cacheIdentifier: "products/\(productIdentifier)")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError()
        
    }
    
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = setUpRefreshControl()
        
        webRequests = [ productRequest, commentsRequest ]
        
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.identifier)
        
        let _ =
        setUpFetchedResultsController()
            .then { _ -> Void in
                
                if self.isCached { return }
                
                let _ = self.fetch()
                
            }
            .catch { error in
                
                print(error.localizedDescription)
                
            }
            .always { self.tableView.reloadData() }
        
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
            .always {
                
                refreshControl.endRefreshing()
                self.tableView.reloadData()
        
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
    
    private var commentsRequest: CHCacheWebRequest {
        
        let url = URL(string: "https://comments.com")!
        let urlRequest = URLRequest(url: url)
        var webService = WebService<Any>(urlRequest: urlRequest)
        
        let mockSession = MockURLSession()
        let jsonObject: [Any] = [
            [
                "id": "01",
                "text": "Nulla vitae elit libero, a pharetra augue. Praesent commodo cursus magna, vel scelerisque nisl consectetur et."
            ],
            [
                "id": "02",
                "text": "Sollicitudin Amet Sit"
            ],
            [
                "id": "03",
                "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean lacinia bibendum nulla sed consectetur."
            ],
            [
                "id": "04",
                "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ullamcorper nulla non metus auctor fringilla. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Donec ullamcorper nulla non metus auctor fringilla. Maecenas sed diam eget risus varius blandit sit amet non magna. Integer posuere erat a ante venenatis dapibus posuere velit aliquet."
            ],
            [
                "id": "05",
                "text": "Donec ullamcorper nulla non metus auctor fringilla. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor."
            ]
        ]
        mockSession.data = try! JSONSerialization.data(
            withJSONObject: jsonObject,
            options: []
        )
        
        webService.urlSession = mockSession
        
        let webServiceGroup = WebServiceGroup(webServices: [ webService ])
        
        let webRequest = CHCacheWebRequest(webServiceGroup: webServiceGroup) { objects in
            
            let comments = objects.first as! Array<[String: Any]>
            
            self.numberOfComments = comments.count
            
            return comments
            
        }
        
        return webRequest
        
    }
    
    
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
     
        return sections.count
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard
            let section = Section(rawValue: section)
            else { return 0 }
        
        switch section {
        case .information: return informationRows.count
        case .description: return 1
        case .comment: return numberOfComments
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard
            let section = Section(rawValue: section)
            else { return nil }
        
        switch section {
        case .information: return "Information"
        case .description: return "Description"
        case .comment: return "Comment"
        }
        
    }
    
    
    // MARK: CHTableViewDataSource
    
    override func tableView(_ tableView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> String? {
        
        return ProductTableViewCell.identifier
        
    }
    
    override func configureCell(_ cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard
            let section = Section(rawValue: indexPath.section),
            let jsonObject = jsonObject(at: indexPath)
            else { return }
        
        switch section {
        case .information:
            
            let json = jsonObject as? [String: Any]
            
            guard
                let row = InformationRow(rawValue: indexPath.row)
                else { return }
            
            switch row {
            case .title:
                
                if let title = json?["title"] as? String {
                    
                    cell.textLabel?.text = "Title: \(title)"
                    
                }
                else {
                    
                    cell.textLabel?.text = "No title"
                    
                }
                
            case .price:
                
                
                if let price = json?["price"] as? Double {
                    
                    cell.textLabel?.text = "Price: \(price)"
                    
                }
                else {
                    
                    cell.textLabel?.text = "No price"
                    
                }
                
            case .quantity:
                
                if let quantity = json?["quantity"] as? Int {
                    
                    cell.textLabel?.text = "Quantity: \(quantity)"
                    
                }
                else {
                    
                    cell.textLabel?.text = "No quantity"
                    
                }
            }
            
        case .description:
            
            let json = jsonObject as? [String: Any]
            
            if let description = json?["description"] as? String {
                
                cell.textLabel?.text = "Description: \(description)"
                
            }
            else {
                
                cell.textLabel?.text = "No Description"
                
            }
            
        case .comment:
            
            let jsonObjects = jsonObject as? [Any]
            
            if
                let comment = jsonObjects?[indexPath.row] as? [String: Any],
                let text = comment["text"] as? String {
                
                cell.textLabel?.text = "Comment: \(text)"
                
            }
            else {
                
                cell.textLabel?.text = "No Comment"
                
            }
        }
        
    }
    
    
    // MARK: CHCacheTableViewDataSource
    
    override func jsonObject(with objects: [Any], forRowsAt indexPath: IndexPath) -> Any? {
        
        guard
            let section = Section(rawValue: indexPath.section)
            else { return nil }
        
        switch section {
        case .information: return objects[0]
        case .description: return objects[0]
        case .comment: return objects[1]
        }
        
    }

}


// MARK: Selector

private extension Selector {
    
    static let pullToRefresh = #selector(ProductTableViewController.pullToRefresh)
    
}
