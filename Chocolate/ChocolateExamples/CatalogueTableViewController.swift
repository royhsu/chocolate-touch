//
//  CatalogueTableViewController.swift
//  ChocolateExamples
//
//  Created by 許郁棋 on 2016/6/30.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
import Chocolate
import CoreData

public class CatalogueTableViewController: UITableViewController {

    enum Row: Int {
        
        case DynamicCellContent
        case CoreDataIntegration
        case WebServiceIntegration
        case CacheIntegration
        case fetchedResultsTableView
        
        var title: String {
            
            switch self {
            case .DynamicCellContent: return "Dynamic Cell Content"
            case .CoreDataIntegration: return "Core Data Integration"
            case .WebServiceIntegration: return "Web Service Integration"
            case .CacheIntegration: return "Cache Integration"
            case .fetchedResultsTableView: return "Fetched Results Table View"
            }
            
        }
        
    }
    
    
    // MARK: Property
    
    let rows: [Row] = [
        .fetchedResultsTableView,
        .DynamicCellContent,
        .CoreDataIntegration,
        .WebServiceIntegration,
        .CacheIntegration
    ]
    
    
    // MARK: Init
    
    public init() {
        
        super.init(style: .plain)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        fatalError()
    
    }
    
    
    // MARK: View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Chocolate"
        tableView.register(CHTableViewCell.self)
        
    }
    
    
    // MARK: UITableViewDataSource
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return rows.count
    
    }
    
    
    
    
    // MARK: UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, configurationForRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.textLabel?.text = rows[indexPath.row].title
        
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.textLabel?.text = "test"
        
        return cell
        
    }
    
    
    // MARK: UITableViewDelegate
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = rows[indexPath.row]
        
        switch row {
        case .fetchedResultsTableView:
            
            break
            
        case .DynamicCellContent:
            
//            let controller = DynamicCellContentTableViewController()
//            controller.navigationItem.title = row.title
//            
//            show(controller, sender: nil)
            break
            
        case .CoreDataIntegration:
            
//            let controller = CoreDataIntegrationTableViewController(modelName: "Main", at: .document(mask: .userDomainMask))
//            controller.navigationItem.title = row.title
//            
//            show(controller, sender: nil)
            
            break
            
        case .WebServiceIntegration:
            
//            let controller = WebServiceIntegrationTableViewController()
//            controller.navigationItem.title = row.title
//            
//            show(controller, sender: nil)
            break
            
        case .CacheIntegration:
            
//            let controller = CacheIntegrationTableViewController()
//            controller.navigationItem.title = row.title
//            
//            show(controller, sender: nil)
            break
        }
        
    }
    
}
