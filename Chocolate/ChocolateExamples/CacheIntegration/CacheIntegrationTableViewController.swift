//
//  CacheIntegrationTableViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/7.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
import Chocolate
import CoreData

public class CacheIntegrationTableViewController: CHSingleCellTypeTableViewController<CHTableViewCell>, CHWebServiceControllerDelegate, NSFetchedResultsControllerDelegate {
    
    struct UserDefaultsKey {
        static let lastUpdated = "CacheIntegrationTableViewController.UserDefaultsKey.lastUpdated"
    }
    
    var managedObjectContext: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController<SongEntity>!
    
    lazy var webServiceController: CHWebServiceController<[SongModel]> = { [unowned self] in
    
        let controller = CHWebServiceController<[SongModel]>()
    
        controller.delegate = self
        
        return controller
        
    }()
    
    
    // MARK: CHWebServiceControllerDelegate
    
    public func webServiceController<Objects: Sequence where Objects: ArrayLiteralConvertible>(_ controller: CHWebServiceController<Objects>, didRequest section: CHWebServiceSectionInfo<Objects>, withSuccess objects: Objects) {
        
        let songs = objects.map { $0 as! SongModel }
        
        for song in songs {
            
            let songEntity = NSEntityDescription.insertNewObject(forEntityName: "Song", into: managedObjectContext) as! SongEntity
            
            songEntity.sectionName = section.name
            songEntity.lastUpdated = Date()
            
            songEntity.trackId = song.identifier
            songEntity.trackName = song.name
            songEntity.artistName = song.artist
            
        }
        
        managedObjectContext.perform {
            
            do { try self.managedObjectContext.save() }
            catch { fatalError("Cannot save: \(error)") }
            
        }
        
    }
    
    public func webServiceController<Objects: Sequence where Objects: ArrayLiteralConvertible>(_ controller: CHWebServiceController<Objects>, didRequest section: CHWebServiceSectionInfo<Objects>, withFail result: (statusCode: Int?, error: ErrorProtocol?)) {
        
        print("Error: \(result.error)")
        
    }
    
    
    // MARK: NSFetchedResultsControllerDelegate
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: AnyObject, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.reloadData()
        
    }
    
    
    // MARK: Init
    
    public init() { super.init(cellType: CHTableViewCell.self) }
    
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: .refresh
        )
        
        let modelURL = Bundle.main.urlForResource("Cache", withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        let storeURL = try! URL(filename: "Cache", withExtension: "sqlite", in: .document(mask: .userDomainMask))
        
        print("storeURL: \(storeURL)")
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        try! persistentStoreCoordinator.addPersistentStore(
            ofType: NSSQLiteStoreType,
            configurationName: nil,
            at: storeURL,
            options: [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
            ]
        )
        
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest<SongEntity>(entityName: "Song")
        fetchRequest.sortDescriptors = [
            SortDescriptor(key: "lastUpdated", ascending: true)
        ]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: "sectionName",
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
        
        if UserDefaults.standard
            .object(forKey: UserDefaultsKey.lastUpdated) == nil {
            
            fetchData()
            
        }
        
    }
    
    private func deleteCachedData(completionHandler: (() -> Void)?) {
        
        guard let objects = fetchedResultsController.fetchedObjects else { return }
        
        let context = fetchedResultsController.managedObjectContext
        
        DispatchQueue.global(attributes: .qosBackground).async { 
            
            context.perform {
                
                objects.forEach { context.delete($0) }
                
                do { try context.save() }
                catch { print("Error: \(error)") }
                
                DispatchQueue.main.async { completionHandler?() }
        
            }
            
        }
        
    }
    
    private func fetchData() {
        
        deleteCachedData {
        
            UserDefaults.standard.set(Date(), forKey: UserDefaultsKey.lastUpdated)
            UserDefaults.standard.synchronize()
            
            let url1 = URL(string: "http://itunes.apple.com/search?term=chocolate&media=music&limit=10&explicit=false")!
            let urlRequest1 = URLRequest(url: url1)
            let webResource1 = WebResource<[SongModel]>(urlRequest: urlRequest1, parse: self.dynamicType.parseSongs)
            let webService1 = WebService(webResource: webResource1)
            let section1 = CHWebServiceSectionInfo(name: "Section 1", webService: webService1)
            
            self.webServiceController.appendSection(section1)
            
            let url2 = URL(string: "http://itunes.apple.com/search?term=chocolate&media=music&limit=10&offset=10&explicit=false")!
            let urlRequest2 = URLRequest(url: url2)
            let webResource2 = WebResource<[SongModel]>(urlRequest: urlRequest2, parse: self.dynamicType.parseSongs)
            let webService2 = WebService(webResource: webResource2)
            let section2 = CHWebServiceSectionInfo(name: "Section 2", webService: webService2)

            self.webServiceController.appendSection(section2)
            
            self.webServiceController.performReqeust()
            
        }
        
    }
    
    
    // MARK: Action
    
    @objc public func refresh(barButtonItem: UIBarButtonItem) { fetchData() }
    
    
    // MARK: Parsing
    
    private class func parseSongs(with json: AnyObject) -> [SongModel]? {
        
        typealias Object = [NSObject: AnyObject]
        
        guard let json = json as? Object,
            songObjects = json["results"] as? [Object]
            else { return nil }
        
        var songs: [SongModel] = []
        
        for songObject in songObjects {
            
            guard let identifier = songObject["trackId"] as? Int,
                artist = songObject["artistName"] as? String,
                name = songObject["trackName"] as? String
                else { continue }
            
            let song = SongModel(
                identifier: "\(identifier)",
                artist: artist,
                name: name
            )
            
            songs.append(song)
            
        }
        
        return songs
        
    }
    
    
    // MARK: UITableViewDataSource
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        
        return fetchedResultsController.sections?.count ?? 0
        
    }
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return fetchedResultsController.sections?[section].name
        
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = fetchedResultsController.sections else { return 0 }
        
        return sections[section].numberOfObjects
        
    }
    
    public override func tableView(_ tableView: UITableView, heightTypeForRowAt: IndexPath) -> HeightType {
        
        return .fixed(height: 44.0)
        
    }
    
    
    // MARK: CHSingleCellTypeTableViewControllerProtocol
    
    public override func tableView(_ tableView: UITableView, configurationFor cell: CHTableViewCell, at indexPath: IndexPath) -> CHTableViewCell {
        
        let song = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = "\(song.artistName!) - \(song.trackName!)"
        
        return cell
        
    }

}


// MARK: - Selector

private extension Selector {
    
    static let refresh = #selector(CacheIntegrationTableViewController.refresh(barButtonItem:))
    
}
