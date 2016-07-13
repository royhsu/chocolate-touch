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

public class CatalogueTableViewController: CHSingleCellTypeTableViewController<CHTableViewCell> {

    enum Row: Int {
        
        case DynamicCellContent
        case CoreDataIntegration
        case WebServiceIntegration
        case CacheIntegration
        case AutomaticallyCaching
        
        var title: String {
            
            switch self {
            case .DynamicCellContent: return "Dynamic Cell Content"
            case .CoreDataIntegration: return "Core Data Integration"
            case .WebServiceIntegration: return "Web Service Integration"
            case .CacheIntegration: return "Cache Integration"
            case .AutomaticallyCaching: return "Automatically Caching"
            }
            
        }
        
    }
    
    
    // MARK: Property
    
    let rows: [Row] = [ .DynamicCellContent, .CoreDataIntegration, .WebServiceIntegration, .CacheIntegration, .AutomaticallyCaching ]
    
    
    // MARK: Init
    
    init() { super.init(cellType: CHTableViewCell.self) }
    
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Chocolate"
        
    }
    
    
    // MARK: UITableViewDataSource
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return rows.count }
    
    
    // MARK: TWTableViewControllerProtocol
    
    public override func tableView(_ tableView: UITableView, heightTypeForRowAt: IndexPath) -> HeightType { return .fixed(height: 44.0) }
    
    public override func tableView(_ tableView: UITableView, configurationFor cell: CHTableViewCell, at indexPath: IndexPath) -> CHTableViewCell {
        
        cell.textLabel?.text = rows[indexPath.row].title
        
        return cell
        
    }
    
    
    // MARK: UITableViewDelegate
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = rows[indexPath.row]
        
        switch row {
        case .DynamicCellContent:
            
            let controller = DynamicCellContentTableViewController()
            controller.navigationItem.title = row.title
            
            show(controller, sender: nil)
            
        case .CoreDataIntegration:
            
            let controller = CoreDataIntegrationTableViewController(modelName: "Main", at: .document(mask: .userDomainMask))
            controller.navigationItem.title = row.title
            
            show(controller, sender: nil)
            
        case .WebServiceIntegration:
            
            let controller = WebServiceIntegrationTableViewController()
            controller.navigationItem.title = row.title
            
            show(controller, sender: nil)
            
        case .CacheIntegration:
            
            let controller = CacheIntegrationTableViewController()
            controller.navigationItem.title = row.title
            
            show(controller, sender: nil)
            
        case .AutomaticallyCaching:

            let urlString = "http://itunes.apple.com/search?term=chocolate&media=music&limit=10&explicit=false"
            let urlRequest = URLRequest(url: URL(string: urlString)!)
            let webResource = WebResource<[AnyObject]>(urlRequest: urlRequest) { json in
                
                typealias Object = [NSObject: AnyObject]
                
                guard let json = json as? Object else { return nil }
                
                return json["results"] as? [AnyObject]
                
            }
            let webService = WebService(webResource: webResource)
            let section = CHWebServiceSectionInfo(name: "Request 1", webService: webService)
            
            let controller = CHCacheTableViewController(cacheIdentifier: "GET_\(urlString)")
            controller.navigationItem.title = row.title
            
            controller.webServiceController.appendSection(section)
            
            let urlString2 = "http://itunes.apple.com/search?term=chocolate&media=music&limit=10&offset=10&explicit=false"
            let urlRequest2 = URLRequest(url: URL(string: urlString2)!)
            let webResource2 = WebResource<[AnyObject]>(urlRequest: urlRequest2) { json in
                
                typealias Object = [NSObject: AnyObject]
                
                guard let json = json as? Object else { return nil }
                
                return json["results"] as? [AnyObject]
                
            }
            let webService2 = WebService(webResource: webResource2)
            let section2 = CHWebServiceSectionInfo(name: "Request 2", webService: webService2)
            
            controller.webServiceController.appendSection(section2)
            
            controller.navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .refresh,
                target: self,
                action: #selector(controller.refreshData)
            )
            
            show(controller, sender: nil)
        }
        
    }
    
}
