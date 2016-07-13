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
    // Reference: http://stackoverflow.com/questions/2579544/nsstrings-stringbyappendingpathcomponent-removes-a-in-http
    
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
    
    enum JSONError: ErrorProtocol {
        case fail(Encoding)
    }
    
    // TODO: documentation
    init(jsonObject: AnyObject, encoding: Encoding = .utf8) throws {
        
        do {
            
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            guard let jsonString = String(data: data, encoding: encoding)
                else { throw JSONError.fail(encoding) }
            
            self = jsonString
            
        }
        catch { throw error }
        
    }
    
    
    // TODO: documentation
    func jsonObject(with encoding: Encoding = .utf8, allowLossyConversion isLossy: Bool = true) throws -> AnyObject {
        
        guard let data = self.data(using: encoding, allowLossyConversion: isLossy)
            else { throw JSONError.fail(encoding) }
        
        do {
            
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            return json
            
        }
        catch { throw error }
        
    }
    
}
