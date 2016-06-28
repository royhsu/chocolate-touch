//
//  ViewController.swift
//  TWKitExamples
//
//  Created by 許郁棋 on 2016/6/28.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit
import TWFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filePath = NSURL(
            filename: "hello",
            withExtension: "world",
            in: Directory.document(mask: .UserDomainMask)
        )
        
        print(filePath)
        
    }

}
