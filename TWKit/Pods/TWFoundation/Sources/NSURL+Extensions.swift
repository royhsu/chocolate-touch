//
//  NSURL+Extensions.swift
//  TWFoundation
//
//  Created by 許郁棋 on 2016/6/27.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Foundation

public extension NSURL {
    
    /**
     A convenience method that returns complete file path in specific directory.
     
     - Author:
     Roy Hsu
     
     - parameters:
     - filename: The file name.
     - extension: The file extension.
     - directory: The directory.
     
     - returns:
     The specific file path in document directory.
     
     - Important:
     If you need to get the file path from the returned URL, please access self.path instead of self.absoluteString.
    */
    // See details: http://stackoverflow.com/questions/32716895/error-the-file-doesnt-exist-when-calling-writetofile-on-imagedata
    convenience init(filename: String, withExtension `extension`: String, `in` directory: Directory) {
        
        let filePath = directory.path
            .appendPathComponent(filename)
            .appendPathExtension(`extension`)!
        
        self.init(fileURLWithPath: filePath, isDirectory: false)
        
    }
    
}
