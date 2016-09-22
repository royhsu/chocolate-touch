//
//  CHButton.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/9/22.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

/// This subclass of UIButton is more sensitive from touches to make itself highlighted.
/// Much nicely cooperate with setBackgroundColor(:for:) extension than standard button.
class CHButton: UIButton {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        isHighlighted = true
        
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        isHighlighted = false
        
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        isHighlighted = false
        
        super.touchesCancelled(touches, with: event)
    }

}
