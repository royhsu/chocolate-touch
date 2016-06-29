//
//  Directory.swift
//  TWFoundation
//
//  Created by 許郁棋 on 2016/6/27.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Foundation

public enum Directory { case document(mask: NSSearchPathDomainMask) }

public extension Directory {
    
    var searchPath: NSSearchPathDirectory {
        
        switch self {
        case .document: return .DocumentDirectory
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
    
    var URL: NSURL {
        
        switch self {
        case .document(let mask):
            
            let documentDirectoryURLs = NSFileManager.defaultManager().URLsForDirectory(
                self.searchPath,
                inDomains: mask
            )
            
            return documentDirectoryURLs.first!
        }
        
    }
    
}
