//
//  CAAnimation+Handlers.swift
//  CHFoundation
//
//  Created by 許郁棋 on 2016/8/30.
//  Copyright © 2016年 Tiny World. All rights reserved.

import QuartzCore

public typealias AnimationBeginHandler = (CAAnimation) -> Void
public typealias AnimationCompletionHandler = (CAAnimation, Bool) -> Void


// MARK: - AnimationDelegate

private class AnimationDelegate: NSObject {
    
    var beginHandler: AnimationBeginHandler?
    var completionHandler: AnimationCompletionHandler?
    
}


// MARK: - CAAnimationDelegate

extension AnimationDelegate: CAAnimationDelegate {
    
    func animationDidStart(_ animation: CAAnimation) {
        
        guard let beginHandler = beginHandler else { return }
        
        beginHandler(animation)
        
    }
    
    func animationDidStop(_ animation: CAAnimation, finished: Bool) {
        
        guard let completionHandler = completionHandler else { return }
        
        completionHandler(animation, finished)
        
    }
    
}


// MARK: - CAAnimation

public extension CAAnimation {
    
    /// This handler will be executed at the beginning of animation.
    var beginHandler: AnimationBeginHandler? {
        
        get {
            
            let delegate = self.delegate as? AnimationDelegate
            
            return delegate?.beginHandler
            
        }
        
        set {
            
            let animationDelegate =
                (self.delegate as? AnimationDelegate) ??
                AnimationDelegate()
            animationDelegate.beginHandler = newValue
            
            delegate = animationDelegate
            
        }
        
    }
    
    /// This handler will be executed after animation finished.
    var completionHandler: AnimationCompletionHandler? {
        
        get {
            
            let delegate = self.delegate as? AnimationDelegate
            
            return delegate?.completionHandler
            
        }
        
        set {
            
            let animationDelegate =
                (self.delegate as? AnimationDelegate) ??
                AnimationDelegate()
            animationDelegate.completionHandler = newValue
            
            delegate = animationDelegate
            
        }
        
    }
    
}
