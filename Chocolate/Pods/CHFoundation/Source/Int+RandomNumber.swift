//
//  Int+RandomNumber.swift
//  CHFoundation
//
//  Created by 許郁棋 on 2016/7/4.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Foundation


// MARK: - Random number

public extension Int {
    
    /**
     A convenience method that generate a random number with the given range.
     
     - Author: Roy Hsu.
     
     - Parameter range: The range of numbers.
     
     - returns: A random number in the given range.
    */
    // Reference: http://stackoverflow.com/questions/24132399/how-does-one-make-random-number-between-range-for-arc4random-uniform
    
    static func random(in range: Range<Int>) -> Int {
        
        var offset = 0
        
        if range.lowerBound < 0 { offset = abs(range.lowerBound) }
        
        let min = UInt32(range.lowerBound + offset)
        let max = UInt32(range.upperBound + offset)
        
        return Int(min + arc4random_uniform(max - min)) - offset
        
    }
    
}
