//
//  CatalogueTableViewController.swift
//  TWKit
//
//  Created by 許郁棋 on 2016/6/30.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import TWKit

public class CatalogueTableViewController: TWTableViewController<TWTableViewCell> {

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
    
    init() { super.init(cellType: TWTableViewCell.self) }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    // MARK: View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitially()
        
    }
    
    
    // MARK: Setup
    
    private func setupInitially() { navigationItem.title = "TWKit" }
    
    
    // MARK: UITableViewDataSource
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return rows.count }
    
    
    // MARK: TWTableViewControllerProtocol
    
    public override func tableView(tableView: UITableView, cellHeightTypeForRowAt: NSIndexPath) -> HeightType { return .fixed(height: 44.0) }
    
    public override func tableView(tableView: UITableView, configurationFor cellAtIndexPath: (cell: TWTableViewCell, indexPath: NSIndexPath)) -> TWTableViewCell {
        
        let cell = cellAtIndexPath.cell
        let rowIndex = cellAtIndexPath.indexPath.row
        
        cell.textLabel?.text = rows[rowIndex].title
        
        return cell
        
    }
    
    
    // MARK: UITableViewDelegate
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let row = rows[indexPath.row]

        switch row {
        case .DynamicCellContent:

            let controller = DynamicCellContentTableViewController()
            controller.navigationItem.title = row.title

            showViewController(controller, sender: nil)
            
        }
        
    }
    
}
