//
//  CatalogueTableViewController.swift
//  ChocolateExamples
//
//  Created by 許郁棋 on 2016/6/30.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
import Chocolate
import CoreData

public class CatalogueTableViewController: CHSingleCellTypeTableViewController<CHTableViewCell> {

    enum Row: Int {
        
        case DynamicCellContent
        case CoreDataIntegration
        case WebServiceIntegration
        
        var title: String {
            
            switch self {
            case .DynamicCellContent: return "Dynamic Cell Content"
            case .CoreDataIntegration: return "Core Data Integration"
            case .WebServiceIntegration: return "Web Service Integration"
            }
            
        }
        
    }
    
    
    // MARK: Property
    
    let rows: [Row] = [ .DynamicCellContent, .CoreDataIntegration, .WebServiceIntegration ]
    
    
    // MARK: Init
    
    init() { super.init(cellType: CHTableViewCell.self) }
    
    
    // MARK: View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Chocolate"
        
    }
    
    
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
            
        case .CoreDataIntegration:
            
            let controller = CoreDataIntegrationTableViewController(modelName: "Main", at: .document(mask: .userDomainMask))
            controller.navigationItem.title = row.title
            
            show(controller, sender: nil)
            
        case .WebServiceIntegration:
            
            let url = URL(string: "http://itunes.apple.com/search?term=chocolate&media=music&limit=10&explicit=false")!
            let urlRequest = URLRequest(url: url)
            let webResource = WebResource<[SongModel]>(urlRequest: urlRequest) { json in
                
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
            let webService = WebService(webResource: webResource)
            let controller = CHWebServiceIntegrationTableViewController(webService: webService)
            controller.navigationItem.title = row.title
            
            show(controller, sender: nil)
            
        }
        
    }
    
}
