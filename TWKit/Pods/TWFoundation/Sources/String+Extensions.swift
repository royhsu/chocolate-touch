//
//  String+Extensions.swift
//  TWFoundation
//
//  Created by 許郁棋 on 2016/6/27.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Foundation

public extension String {
    
    /**
     A convenience method that help you to append a path to the original string.
     
     - Author:
     Roy Hsu
     
     - parameters:
        - component: The path component to be appending with
     
     - returns:
     The appended result of the string.
     
     - Important:
     This function only works in file path. DO NOT apply it on URL string.
     
    */
    // See details: http://stackoverflow.com/questions/2579544/nsstrings-stringbyappendingpathcomponent-removes-a-in-http
    func appendPathComponent(component: String) -> String {
        
        let URL = NSURL(string: self)!
        
        return URL.URLByAppendingPathComponent(component).path!
        
    }
    
    /**
     A convenience method that help you to append a extension to the original string.
     
     - Author:
     Roy Hsu
     
     - parameters:
     - extension: The path extension to be appending with
     
     - returns:
     The appended result of the string.
     
     - Important:
     This function only works in file path. DO NOT apply it on URL string.
     
    */
    func appendPathExtension(`extension`: String) -> String? {
        
        let URL = NSURL(string: self)!
        
        return URL.URLByAppendingPathExtension(`extension`).path!
        
    }
    
}
