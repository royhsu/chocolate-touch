//
//  String+JSON.swift
//  CHFoundation
//
//  Created by 許郁棋 on 2016/6/27.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Foundation


// MARK: - JSON

public extension String {
    
    enum JSONObjectError: Error {
        case invalidData
        case invalidJSONObject
        case invalidString
    }
    
    /**
     Generating json string with json object.
     
     - Author: Roy Hsu.
     
     - Parameter jsonObject: The json object to convert with.
     
     - Parameter encoding: The encoding method. Default is .utf8.
     
     - Parameter options: The options for JSONSerialization. Default is empty.
     
     - Returns: The converted json string.
    */
    
    init(jsonObject: Any, encoding: Encoding = .utf8, options: JSONSerialization.WritingOptions = []) throws {
        
        do {
            
            if !JSONSerialization.isValidJSONObject(jsonObject) {
                
                throw JSONObjectError.invalidJSONObject
                
            }
            
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: options)
            guard
                let jsonString = String(data: data, encoding: encoding)
                else {
                    
                    throw JSONObjectError.invalidData
                    
            }
            
            self = jsonString
            
        }
        catch { throw error }
        
    }
    
    /**
     Converting string to json object.
     
     - Author: Roy Hsu.
     
     - Parameter encoding: The encoding method. Default is .utf8.
     
     - Parameter isLossy: Is allowing loss during converstion or not.
     
     - Parameter options: The options for JSONSerialization. Default is empty.
     
     - Returns: The converted json object.
    */
    
    func jsonObject(using encoding: Encoding = .utf8, allowLossyConversion isLossy: Bool = true, options: JSONSerialization.ReadingOptions = []) throws -> Any {
        
        guard
            let data = self.data(using: encoding, allowLossyConversion: isLossy)
            else {
                
                throw JSONObjectError.invalidString
                
        }
        
        do {
            
            let json = try JSONSerialization.jsonObject(with: data, options: options)
            
            return json
            
        }
        catch { throw error }
        
    }
    
}
