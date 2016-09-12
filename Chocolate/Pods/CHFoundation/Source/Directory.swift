//
//  Directory.swift
//  CHFoundation
//
//  Created by 許郁棋 on 2016/6/27.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Foundation

public enum Directory {
    
    case document(domainMask: FileManager.SearchPathDomainMask)
    
}

public extension Directory {
    
    var path: String {
        
        switch self {
        case .document(let domainMask):
            
            let documentDirectoryPaths =
                NSSearchPathForDirectoriesInDomains(
                    .documentDirectory,
                    domainMask,
                    true
                )
            
            return documentDirectoryPaths.first!
        }
        
    }
    
    var url: URL {
        
        switch self {
        case .document(let domainMask):
            
            let documentDirectoryURLs =
                FileManager.default.urls(
                    for: .documentDirectory,
                    in: domainMask
                )
            
            return documentDirectoryURLs.first!
        }
        
    }
    
}
