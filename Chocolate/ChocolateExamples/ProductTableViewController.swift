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

public class ProductTableViewController: CHCacheTableViewController {

    typealias Object = [String: Any]
    
    private enum Section: Int { case information, description, comment }
    private enum InformationRow: Int { case title, price, quantity }
    
    
    // MARK: Property
    
    public let productIdentifier: String
    private let sections: [Section] = [ .information, .description, .comment ]
    private let informationRows: [InformationRow] = [ .title, .price, .quantity ]
    private var numberOfComments = 0
    
    
    // MARK: Init
    
    public init(productIdentifier: String) {
        
        self.productIdentifier = productIdentifier
        
        super.init(cacheIdentifier: "products/\(productIdentifier)")
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        fatalError()
        
    }
    
    
    // MARK: View Life Cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRefreshControl()
        
        webRequests = [ productRequest, commentsRequest ]
        
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.identifier)
        
        let _ =
        setUpFetchedResultsController()
            .then { _ -> Promise<Void> in
                
                if self.isCached { return Promise(value: ()) }
                
                return self.fetch()
                
            }
            .catch { print($0.localizedDescription) }
        
    }
    
    
    // MARK: Set Up
    
    private func setUpRefreshControl() {
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: .pullToRefresh, for: .valueChanged)
        
    }
    
    
    // MARK: Action
    
    public func pullToRefresh(refreshControl: UIRefreshControl) {
        
        let _ =
        refresh()
            .always { refreshControl.endRefreshing() }
        
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
            
            return objects.first ?? Object()
            
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
            
            let comments = objects.first as? [Object] ?? []
            
            self.numberOfComments = comments.count
            
            return comments
            
        }
        
        return webRequest
        
    }
    
    
    // MARK: UITableViewDataSource
    
    override public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch sections[section] {
        case .information: return "Information"
        case .description: return "Description"
        case .comment: return "Comment"
        }
        
    }
    
    
    // MARK: CHTableViewCacheDataSource
    
    public final override func numberOfSections() -> Int {
     
        return sections.count
        
    }
    
    public final override func numberOfRows(inSection section: Int) -> Int {
        
        switch sections[section] {
        case .information: return informationRows.count
        case .description: return 1
        case .comment: return numberOfComments
        }
        
    }
    
    public final override func jsonObject(with objects: [Any], forRowsAt indexPath: IndexPath) -> Any? {
        
        if objects.count != webRequests.count { return nil }
        
        switch sections[indexPath.section] {
        case .information: return objects[0]
        case .description: return objects[0]
        case .comment: return objects[1]
        }
        
    }

    
    // MARK: CHTableViewDataSource
    
    public final override func tableView(_ tableView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> String? {
        
        return ProductTableViewCell.identifier
        
    }
    
    public final override func configureCell(_ cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard
            let jsonObject = jsonObject(at: indexPath)
            else { return }
        
        switch sections[indexPath.section] {
        case .information:
            
            let jsonObject = jsonObject as? Object
            
            switch informationRows[indexPath.row] {
            case .title:
                
                let title = (jsonObject?["title"] as? String) ?? "Empty"
                    
                cell.textLabel?.text = "Title: \(title)"
                
            case .price:
                
                let price = (jsonObject?["price"] as? String) ?? "0.0"
                    
                cell.textLabel?.text = "Price: \(price)"
                
            case .quantity:
                
                let quantity = (jsonObject?["quantity"] as? String) ?? "0"
                    
                cell.textLabel?.text = "Quantity: \(quantity)"
                
            }
            
        case .description:
            
            let jsonObject = jsonObject as? Object
            let description = (jsonObject?["description"] as? String) ?? "Empty"
                
            cell.textLabel?.text = "Description: \(description)"
               
        case .comment:
            
            let jsonObjects = jsonObject as? [Object]
            let commentObject = jsonObjects?[indexPath.row]
            let text = (commentObject?["text"] as? String) ?? "Empty"
                
            cell.textLabel?.text = "Comment: \(text)"
        }
        
    }

}


// MARK: - NSFetchedResultsControllerDelegate

extension ProductTableViewController {
    
    public final func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.reloadData()
        
    }
    
}


// MARK: Selector

private extension Selector {
    
    static let pullToRefresh = #selector(ProductTableViewController.pullToRefresh)
    
}
