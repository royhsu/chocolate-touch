//
//  CHCacheTableViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/9.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
import CoreData

open class CHCacheTableViewController: CHTableViewController, NSFetchedResultsControllerDelegate {
    
    
    // MARK: Property
    
    private let cacheIdentifier: String
    private var cache: CHCache?
    
    public private(set) var fetchedResultsController: NSFetchedResultsController<NSManagedObject>?
    public private(set) var webServiceController = CHWebServiceController<[AnyObject]>()
    
    
    // MARK: Init
    
    public init(cacheIdentifier: String) {
        
        self.cacheIdentifier = cacheIdentifier
    
        super.init(style: .plain)
        
    }
    
    private init() {
        
        self.cacheIdentifier = ""
        
        super.init(style: .plain)
    
    }
    
    private override init(style: UITableViewStyle) {
        
        self.cacheIdentifier = ""
        
        super.init(style: style)
    
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        self.cacheIdentifier = ""
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    // MARK: View Life Cycle
    
    open override func viewDidLoad() {
        
//        tableView.register(CHTableViewCell.self)
        
//        webServiceController.delegate = self
        
        do {
            
            let cacheStack = try setUpCacheStack(name: "Cache")
            
            cache = CHCache(identifier: cacheIdentifier, stack: cacheStack)
            
//            fetchedResultsController = try setUpFetchResultsController(with: cacheStack.writerContext)
            
        }
        catch { /* TODO: error handling */ print("Error: \(error)") }
        
    }
    
    
    // MARK: Set Up
    
    private func setUpCacheStack(name: String) throws -> CoreDataStack {
        
        do {
            
            let storeURL = Directory.document(domainMask: .userDomainMask).url
                .appendingPathComponent(name)
                .appendingPathExtension("sqlite")
            
            let model = NSManagedObjectModel()
//            let entity = CHCache.schema.entity
//            model.add(entity: entity, of: CHCacheSchema.self)
            
            let stack = try CoreDataStack(
                name: name,
                model: model,
                options: [
                    NSMigratePersistentStoresAutomaticallyOption: true,
                    NSInferMappingModelAutomaticallyOption: true
                ],
                storeType: .local(storeURL: storeURL)
            )
            
            return stack
            
        }
        catch { throw error }
        
    }
    
    private func setUpFetchResultsController(with context: NSManagedObjectContext) throws -> NSFetchedResultsController<NSManagedObject> {
        
//        let fetchRequest = CHCacheSchema.fetchRequest
//        
//        fetchRequest.predicate = Predicate(format: "id == %@", cacheIdentifier)
//        
//        fetchRequest.sortDescriptors = [
//            SortDescriptor(key: "createdAt", ascending: true)
//        ]
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Temp")
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "section",
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
        
    }
    
    private typealias FetchDataSuccessHandler = () -> Void
    private typealias FetchDataFailHandler = (_ error: Error) -> Void
    
    private func fetchData(with fetchedResultsController: NSFetchedResultsController<NSManagedObject>, webServiceController: CHWebServiceController<[AnyObject]>, successHandler: FetchDataSuccessHandler? = nil, failHandler: FetchDataFailHandler? = nil) {
        
        let context = fetchedResultsController.managedObjectContext
        
        context.perform {
            
            do {
                
                let _ = try fetchedResultsController.performFetch()
                
                DispatchQueue.main.async {
                    
                    if
                        let fetchedObjects = fetchedResultsController.fetchedObjects ,
                        fetchedObjects.isEmpty {
                        
                        webServiceController.performReqeust()
                        
                    }
                    
                    successHandler?()
                    
                }
                
            }
            catch {
                
//                DispatchQueue.main.async { failHandler?(error as! UIViewController.Error) }
            
            }
            
        }
        
    }
    
    
    // MARK: Action
    
    public final func fetchData() {
        
        guard let fetchedResultsController = fetchedResultsController else { return }
        
        fetchData(with: fetchedResultsController, webServiceController: webServiceController)
        
    }
    
    public final func refreshData() {
        
        cache?.cleanUp(successHandler: { [weak self] in
            
            self?.fetchData()
        
        })
        
    }
    
    
    // MARK: UITableViewDataSource
    
    public final override func numberOfSections(in tableView: UITableView) -> Int {

        return fetchedResultsController?.sections?.count ?? 0

    }

    public final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let sections = fetchedResultsController?.sections else { return 0 }

        return sections[section].numberOfObjects
        
    }
    
    public final override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat { return 44.0 }
    
    public final override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cellHeight = self.tableView(tableView, heightTypeForRowAt: indexPath)
        
        switch cellHeight {
        case .dynamic: tableView.rowHeight = UITableViewAutomaticDimension
        case .fixed(let height): tableView.rowHeight = height
        }
        
        return tableView.rowHeight
        
    }
    
//    public final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell: CHTableViewCell = tableView.dequeueReusableCell(for: indexPath)
//        
//        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
//        
//        if let cellContentView = self.tableView(tableView, cellContentViewForRowAt: indexPath) {
//            
//            cell.contentView.addSubview(cellContentView)
//            
//            cellContentView.pinEgdesToSuperview()
//            
//        }
//        
//        return cell
//        
//    }
    
    public final func tableView(_ tableView: UITableView, jsonObjectForRowAt indexPath: IndexPath) -> AnyObject? {
        
        let object = fetchedResultsController?.object(at: indexPath)
        let jsonString = object?.value(forKey: "data") as? String
        let jsonObject = try? jsonString?.jsonObject()
            
        return jsonObject as AnyObject?? ?? nil
        
    }
    
    
    // MARK: NSFetchedResultsControllerDelegate
    
    public final func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.reloadData()

    }
    
    
    // MARK: CHWebServiceControllerDelegate
    
    public final func webServiceController<Objects>(_ controller: CHWebServiceController<Objects>, didRequest section: CHWebServiceSectionInfo<Objects>, withSuccess objects: Objects) {
        
        guard let cache = cache else { return }
        let writerContext = cache.stack.viewContext
        
        writerContext.performAndWait {
            
//            do {
                
//                let jsonObjects = objects.map { $0 as AnyObject }
//                
//                for jsonObject in jsonObjects {
//                    
//                    let jsonString = try String(jsonObject: jsonObject)
//                    
//                    let _ = try CHCache.schema.insertObject(
//                        with: [
//                            "id": cache.identifier,
//                            "data": jsonString,
//                            "createdAt": Date(),
//                            "section": section.name
//                        ],
//                        into: writerContext
//                    )
                
//                }
//                
//                try writerContext.save()
                
//            }
//            catch {
//                
//                DispatchQueue.main.async {
//                    
//                    self.webServiceController(
//                        controller,
//                        didRequest: section,
//                        withFail: (statusCode: nil, error: error)
//                    )
//                    
//                }
//                
//            }
            
        }
        
    }
    
    public func webServiceController<Objects>(_ controller: CHWebServiceController<Objects>, didRequest section: CHWebServiceSectionInfo<Objects>, withFail result: (statusCode: Int?, error: Error?)) { }
    
}


// MARK: UIView

private extension UIView {
    
    func pinEgdesToSuperview() {
        
        guard let superview = self.superview else { fatalError("No superview exists.") }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let leading = NSLayoutConstraint(
            item: self,
            attribute: .leading,
            relatedBy: .equal,
            toItem: superview,
            attribute: .leading,
            multiplier: 1.0,
            constant: 0.0
        )
        
        let top = NSLayoutConstraint(
            item: self,
            attribute: .top,
            relatedBy: .equal,
            toItem: superview,
            attribute: .top,
            multiplier: 1.0,
            constant: 0.0
        )
        
        let trailing = NSLayoutConstraint(
            item: self,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: superview,
            attribute: .trailing,
            multiplier: 1.0,
            constant: 0.0
        )
        
        let bottom = NSLayoutConstraint(
            item: self,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: superview,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0.0
        )
        
        superview.addConstraints([ leading, top, trailing, bottom ])
        
    }
    
}
