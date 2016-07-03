//
//  String+Extensions.swift
//  CHFoundation
//
//  Created by 許郁棋 on 2016/6/27.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Foundation

public extension String {
    
    /**
     A convenience method that help you to append a path to the original string.
     
     - Author: Roy Hsu
     
     - Parameter component: The path component to be appending with
     
     - Returns: The appended result of the string.
     
     - Important: This function only works in file path. DO NOT apply it on URL string.
    */
    // See details: http://stackoverflow.com/questions/2579544/nsstrings-stringbyappendingpathcomponent-removes-a-in-http
    
    func appendingPathComponent(_ pathComponent: String) -> String {
        
        return (self as NSString).appendingPathComponent(pathComponent)
        
    }
    
    /**
     A convenience method that help you to append a extension to the original string.
     
     - Author: Roy Hsu
     
     - Parameter extension: The path extension to be appending with
     
     - Returns: The appended result of the string.
     
     - Important: This function only works in file path. DO NOT apply it on URL string.
    */
    
    enum AppendingPathExtensionError: ErrorProtocol {
        case noValidFilePath
    }
    
    func appendingPathExtension(_ pathExtension: String) throws -> String {
        
        guard let filePath = (self as NSString).appendingPathExtension(pathExtension)
            else { throw AppendingPathExtensionError.noValidFilePath }
        
        return filePath
        
    }
    
}
