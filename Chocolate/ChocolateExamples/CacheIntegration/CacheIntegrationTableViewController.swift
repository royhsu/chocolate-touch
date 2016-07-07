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

public class CacheIntegrationTableViewController: CHWebServiceTableViewController<CHTableViewCell, SongModel> {

    lazy var fetchedResultsController: NSFetchedResultsController<SongEntity> = {
        
        let modelURL = Bundle.main().urlForResource("Main", withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        let storeURL = try! URL(filename: "Main", withExtension: "sqlite", in: .document(mask: .userDomainMask))
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
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest<SongEntity>(entityName: "Song")
        fetchRequest.sortDescriptors = [
            SortDescriptor(key: "lastUpdated", ascending: true)
        ]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: "countryName",
            cacheName: nil
        )
        
        return fetchedResultsController
    
    }()
    
    
    // MARK: Init
    
    public init() { super.init(cellType: CHTableViewCell.self) }
    
    
    // MARK: View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let url1 = URL(string: "http://itunes.apple.com/search?term=chocolate&media=music&limit=10&explicit=false")!
        let urlRequest1 = URLRequest(url: url1)
        let webResource1 = WebResource<[SongModel]>(urlRequest: urlRequest1, parse: self.dynamicType.parseSongs)
        let webService1 = WebService(webResource: webResource1)
        let section1 = CHWebServiceSectionInfo(name: "Section 1", webService: webService1)
        
        webServiceController.appendSection(section1)
        
        let url2 = URL(string: "http://itunes.apple.com/search?term=chocolate&media=music&limit=10&offset=10&explicit=false")!
        let urlRequest2 = URLRequest(url: url2)
        let webResource2 = WebResource<[SongModel]>(urlRequest: urlRequest2, parse: self.dynamicType.parseSongs)
        let webService2 = WebService(webResource: webResource2)
        let section2 = CHWebServiceSectionInfo(name: "Section 2", webService: webService2)
        
        webServiceController.appendSection(section2)
        
    }
    
    
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

}
