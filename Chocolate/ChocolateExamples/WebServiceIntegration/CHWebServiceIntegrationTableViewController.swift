//
//  CHWebServiceIntegrationTableViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/5.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
import Chocolate

public class CHWebServiceIntegrationTableViewController: CHSingleCellTypeTableViewController<CHTableViewCell> {

    
    // MARK: Property
    
    var webService: WebService<[UserModel]>
    internal(set) var users: [UserModel] = []
    
    
    // MARK: Init
    
    init(webService: WebService<[UserModel]>) {
        
        self.webService = webService
        
        super.init(cellType: CHTableViewCell.self)
        
    }
    
    
    // MARK: View Life Cycle
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if users.isEmpty {
            
            let _ = webService.request(
                with: URLSession.shared(),
                errorParser: nil,
                successHandler: { users in
                
                    self.users = users
                    self.tableView.reloadData()
                
                },
                failHandler: { _, error in
                
                    print(error)
                    
                }
            )
            
        }
        
    }
    
    
    // MARK: UITableViewDataSource
    
    public override func tableView(_ tableView: UITableView, heightTypeForRowAt: IndexPath) -> HeightType {
        
        return .fixed(height: 44.0)
        
    }
    
    public override func tableView(_ tableView: UITableView, configurationFor cell: CHTableViewCell, at indexPath: IndexPath) -> CHTableViewCell {
        
        cell.textLabel?.text = users[indexPath.row].name
        
        return cell
        
    }
    
}
