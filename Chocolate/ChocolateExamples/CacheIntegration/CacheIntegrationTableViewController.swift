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

public class CacheIntegrationTableViewController: CHCacheTableViewController {
    
    
    // MARK: Init
    
    public init() {
        
        super.init(cacheIdentifier: "CacheIntegrationTableViewController")
        
    }
    
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: .refresh
        )
        
        setUpWebServices()
        
        fetchData()
        
    }
    
    
    // MARK: Set Up
    
    private func setUpWebServices() {
        
        let url1 = URL(string: "http://itunes.apple.com/search?term=chocolate&media=music&limit=10&explicit=false")!
        let urlRequest1 = URLRequest(url: url1)
        let webResource1 = WebResource<[AnyObject]>(urlRequest: urlRequest1) { json in
            
            typealias Object = [NSObject: AnyObject]
            
            guard let json = json as? Object else { return nil }
            
            return json["results"] as? [AnyObject]
            
        }
        let webService1 = WebService(webResource: webResource1)
        let section1 = CHWebServiceSectionInfo(name: "Section 1", webService: webService1)
        
        webServiceController.appendSection(section1)
        
        let url2 = URL(string: "http://itunes.apple.com/search?term=chocolate&media=music&limit=10&offset=10&explicit=false")!
        let urlRequest2 = URLRequest(url: url2)
        let webResource2 = WebResource<[AnyObject]>(urlRequest: urlRequest2) { json in
            
            typealias Object = [NSObject: AnyObject]
            
            guard let json = json as? Object else { return nil }
            
            return json["results"] as? [AnyObject]
            
        }
        let webService2 = WebService(webResource: webResource2)
        let section2 = CHWebServiceSectionInfo(name: "Section 2", webService: webService2)
        
        webServiceController.appendSection(section2)
        
    }
    
    
    // MARK: Action
    
    @objc public func refresh(barButtonItem: UIBarButtonItem) { refreshData() }
    
    
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
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let sections = fetchedResultsController?.sections else { return nil }
        
        return sections[section].name
        
    }
    
    public override func tableView(_ tableView: UITableView, heightTypeForRowAt: IndexPath) -> HeightType {
        
        return .fixed(height: 44.0)
        
    }
    
    public override func tableView(_ tableView: UITableView, cellContentViewForRowAt indexPath: IndexPath) -> UIView? {
        
        let jsonObject = self.tableView(tableView, jsonObjectForRowAt: indexPath) as? [NSObject: AnyObject]
        
        let label = UILabel()
        label.text = jsonObject?["trackName"] as? String
        
        return label
        
    }

}


// MARK: - Selector

private extension Selector {
    
    static let refresh = #selector(CacheIntegrationTableViewController.refresh(barButtonItem:))
    
}
