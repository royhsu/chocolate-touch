//
//  CatalogueTableViewController.swift
//  ChocolateExamples
//
//  Created by 許郁棋 on 2016/6/30.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Chocolate

public class CatalogueTableViewController: CHSingleCellTypeTableViewController<CHTableViewCell> {

    enum Row: Int {
        
        case DynamicCellContent
        
        var title: String {
            
            switch self {
            case .DynamicCellContent: return "Dynamic Cell Content"
            }
            
        }
        
    }
    
    
    // MARK: Property
    
    let rows: [Row] = [ .DynamicCellContent ]
    
    
    // MARK: Init
    
    init() { super.init(cellType: CHTableViewCell.self) }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    // MARK: View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitially()
        
    }
    
    
    // MARK: Setup
    
    private func setupInitially() { navigationItem.title = "Chocolate" }
    
    
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
            
        }
        
    }
    
}