//
//  CHWebServiceTableViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/5.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation

public class CHWebServiceTableViewController<Cell: UITableViewCell, ObjectModel where Cell: Identifiable>: CHSingleCellTypeTableViewController<Cell> {

    
    // MARK: Property
    
    public var webService: WebService<[ObjectModel]>
//    public private(set) var sections: [CHWebServiceSectionInfo<ObjectModel>] = []
    
    private class var emptyWebService: WebService<[ObjectModel]> {
        
        let url = URL(string: "")!
        let urlRequest = URLRequest(url: url)
        let webResource = WebResource<[ObjectModel]>(urlRequest: urlRequest) { _ in return nil }
        
        return WebService(webResource: webResource)
        
    }
    
    
    // MARK: Init
    
    public init(cellType: Cell.Type, webService: WebService<[ObjectModel]>) {
        
        self.webService = webService
        
        super.init(cellType: cellType)
        
    }
    
    public init(nibType: Cell.Type, bundle: Bundle? = nil, webService: WebService<[ObjectModel]>) {
        
        self.webService = webService
        
        super.init(nibType: nibType, bundle: bundle)
    
    }
    
    private override init(cellType: Cell.Type) {
        
        self.webService = self.dynamicType.emptyWebService
        
        super.init(cellType: cellType)
    
    }
    
    private override init(nibType: Cell.Type, bundle: Bundle? = nil) {
    
        self.webService = self.dynamicType.emptyWebService
        
        super.init(nibType: nibType, bundle: bundle)
    
    }
    
    
    // MARK: UITableViewDataSource
    
//    public final override func numberOfSections(in tableView: UITableView) -> Int {
//        
//        return sections.count
//        
//    }
//    
//    public final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return sections[section].objects.count
//        
//    }
    
}
