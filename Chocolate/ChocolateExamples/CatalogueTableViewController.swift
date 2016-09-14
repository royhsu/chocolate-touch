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

public class CatalogueTableViewController: CHTableViewController {

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
        
    }
    
    
    // MARK: UITableViewDataSource
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return rows.count
    
    }
    
    public override func configure(cell: CHTableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.textLabel?.text = rows[indexPath.row].title
        
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
