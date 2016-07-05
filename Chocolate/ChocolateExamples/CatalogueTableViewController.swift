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
        
        var title: String {
            
            switch self {
            case .DynamicCellContent: return "Dynamic Cell Content"
            case .CoreDataIntegration: return "Core Data Integration"
            case .WebServiceIntegration: return "Web Service Integration"
            }
            
        }
        
    }
    
    
    // MARK: Property
    
    let rows: [Row] = [ .DynamicCellContent, .CoreDataIntegration, .WebServiceIntegration ]
    
    
    // MARK: Init
    
    init() { super.init(cellType: CHTableViewCell.self) }
    
    
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
            
            let url = URL(string: "http://localhost:3000/users")!
            let urlRequest = URLRequest(url: url)
            let webResource = WebResource<[UserModel]>(urlRequest: urlRequest) { json in
                
                typealias Object = [NSObject: AnyObject]
                
                guard let json = json as? Object,
                    userObjects = json["data"] as? [Object]
                    else { return nil }
                
                var users: [UserModel] = []
                
                for userObject in userObjects {
                    
                    guard let identifier = userObject["id"] as? String,
                        name = userObject["name"] as? String
                        else { continue }
                    
                    let user = UserModel(
                        identifier: identifier,
                        name: name
                    )
                    
                    users.append(user)
                    
                }
                        
                return users
            
            }
            let webService = WebService(webResource: webResource)
            let controller = CHWebServiceIntegrationTableViewController(webService: webService)
            
            show(controller, sender: nil)
            
        }
        
    }
    
}
