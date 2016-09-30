//
//  CHCollectionViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/9/28.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit


// MARK: - CHCollectionViewDataSource

public protocol CHCollectionViewDataSource: class {
    
    func collectionView(_ collectionView: UICollectionView, cellIdentifierForRowAt indexPath: IndexPath) -> String?
    
    func configureCell(_ cell: UICollectionViewCell, forRowAt indexPath: IndexPath)
    
}


// MARK: - CHCollectionViewController

open class CHCollectionViewController: UICollectionViewController {
    
    
    // MARK: Property
    
    weak var dataSource: CHCollectionViewDataSource?
    
    
    // MARK: Init
 
    public override init(collectionViewLayout: UICollectionViewLayout) {
        
        super.init(collectionViewLayout: collectionViewLayout)
        
        dataSource = self
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        dataSource = self
        
    }
    
    
    // MARK: UICollectionViewDataSource

    public final override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell!
        
        if let identifier = dataSource?.collectionView(collectionView, cellIdentifierForRowAt: indexPath) {
            
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
            
        }
        else {
            
            cell = UICollectionViewCell()
            
        }
        
        dataSource?.configureCell(cell, forRowAt: indexPath)
    
        return cell
        
    }

}


// MARK: - CHTableViewDataSource

extension CHCollectionViewController: CHCollectionViewDataSource {
    
    open func collectionView(_ collectionView: UICollectionView, cellIdentifierForRowAt indexPath: IndexPath) -> String? {
        
        return nil
        
    }
    
    open func configureCell(_ cell: UICollectionViewCell, forRowAt indexPath: IndexPath) { }
    
}
