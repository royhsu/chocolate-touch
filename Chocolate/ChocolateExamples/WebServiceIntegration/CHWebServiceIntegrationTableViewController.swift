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
    
    
    // MARK: View Life Cycle
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if songs.isEmpty {
        
            let _ = webService.request(
                with: URLSession.shared(),
                errorParser: nil,
                successHandler: { songs in
                
                    DispatchQueue.main.async {
                        
//                        self.songs = songs
                        self.tableView.reloadData()
                        
                    }
                    
                },
                failHandler: { _, error in print(error) }
            )
            
//        }
        
    }
    
    
    // MARK: UITableViewDataSource
    
    public override func tableView(_ tableView: UITableView, heightTypeForRowAt: IndexPath) -> HeightType {
        
        return .fixed(height: 44.0)
    
    }
    
    public override func tableView(_ tableView: UITableView, configurationFor cell: CHTableViewCell, at indexPath: IndexPath) -> CHTableViewCell {
        
//        let song = songs[indexPath.row]
//        cell.textLabel?.text = "\(song.artist) - \(song.name)"
        
        return cell
        
    }
    
}
