//
//  CHWebServiceIntegrationTableViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/5.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
import Chocolate

public class CHWebServiceIntegrationTableViewController: CHWebServiceTableViewController<CHTableViewCell, SongModel> {

    
    
    
    // MARK: Init
    
    public init() { super.init(cellType: CHTableViewCell.self) }
    
    
    // MARK: View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "http://itunes.apple.com/search?term=chocolate&media=music&limit=10&explicit=false")!
        let urlRequest = URLRequest(url: url)
        let webResource = WebResource<[SongModel]>(urlRequest: urlRequest, parse: self.dynamicType.parseSongs)
        let webService = WebService(webResource: webResource)
        let section = CHWebServiceSectionInfo(name: "Section 1", webService: webService)
        
        webServiceController.append(section: section)
        
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        webServiceController.performReqeust()
        
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
    
    
    // MARK: UITableViewDataSource
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let section = webServiceController.sections[section]
        
        return section.name
        
    }
    
    public override func tableView(_ tableView: UITableView, heightTypeForRowAt: IndexPath) -> HeightType {
        
        return .fixed(height: 44.0)
    
    }
    
    public override func tableView(_ tableView: UITableView, configurationFor cell: CHTableViewCell, at indexPath: IndexPath) -> CHTableViewCell {
        
        let section = webServiceController.sections[indexPath.section]
        let song = section.objects[indexPath.row]
        
        cell.textLabel?.text = "\(song.artist) - \(song.name)"
        
        return cell
        
    }
    
}
