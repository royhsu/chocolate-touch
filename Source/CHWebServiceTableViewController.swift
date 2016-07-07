//
//  CHWebServiceTableViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/5.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation

public class CHWebServiceTableViewController<Cell: UITableViewCell, ObjectModel where Cell: Identifiable>: CHSingleCellTypeTableViewController<Cell>, CHWebServiceControllerDelegate {

    
    // MARK: Property
    
    public let webServiceController = CHWebServiceController<[ObjectModel]>()
    
    
    // MARK: Init
    
    public override init(cellType: Cell.Type) { super.init(cellType: cellType) }
    
    public override init(nibType: Cell.Type, bundle: Bundle?) { super.init(nibType: nibType, bundle: bundle) }
    
    
    // MARK: View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        webServiceController.delegate = self
        
    }
    
    
    // MARK: UITableViewDataSource
    
    public final override func numberOfSections(in tableView: UITableView) -> Int {
        
        return webServiceController.sections.count
        
    }
    
    public final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let section = webServiceController.sections[section]
        
        return section.objects.count
        
    }
    
    
    // MARK: CHWebServiceControllerDelegate
    
    public func webServiceController<Objects: Sequence where Objects: ArrayLiteralConvertible>(_ controller: CHWebServiceController<Objects>, didRequest section: CHWebServiceSectionInfo<Objects>, withSuccess objects: Objects) {

        tableView.beginUpdates()
        
        tableView.reloadSections(
            IndexSet(integersIn: 0..<webServiceController.sections.count),
            with: .automatic
        )
        
        tableView.endUpdates()
        
    }
    
    public func webServiceController<Objects: Sequence where Objects: ArrayLiteralConvertible>(_ controller: CHWebServiceController<Objects>, didRequest section: CHWebServiceSectionInfo<Objects>, withFail result: (statusCode: Int?, error: ErrorProtocol?)) {
        
        // TODO: Error handling.
        
    }
    
}
