//
//  Directory.swift
//  CHFoundation
//
//  Created by 許郁棋 on 2016/6/27.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Foundation

public typealias SearchPathDomainMask = FileManager.SearchPathDomainMask
public typealias SearchPathDirectory = FileManager.SearchPathDirectory

public enum Directory { case document(mask: SearchPathDomainMask) }

public extension Directory {
    
    var searchPath: SearchPathDirectory {
        
        switch self {
        case .document: return .documentDirectory
        }
        
    }
    
    var path: String {
        
        switch self {
        case .document(let mask):
            
            let documentDirectoryPaths = NSSearchPathForDirectoriesInDomains(
                self.searchPath,
                mask,
                true
            )
            
            return documentDirectoryPaths.first!
        }
        
    }
    
    var url: URL {
        
        switch self {
        case .document(let mask):
            
            let documentDirectoryURLs = FileManager.default.urlsForDirectory(
                self.searchPath,
                inDomains: mask
            )
            
            return documentDirectoryURLs.first!
        }
        
    }
    
}
