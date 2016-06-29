//
//  DynamicCellContentTableViewController.swift
//  TWKit
//
//  Created by 許郁棋 on 2016/6/29.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import TWKit

class DynamicCellContentTableViewController: TWTableViewController<TemplateTableViewCell> {
    
    struct Content {
        
        let image: UIImage
        let title: String
        let body: String
        
    }
    
    var contents: [Content] = [
        Content(image: UIImage(), title: "Magna Pellentesque", body: "Cras justo odio, dapibus ac facilisis in, egestas eget quam. Nullam quis risus eget urna mollis ornare vel eu leo. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Etiam porta sem malesuada magna mollis euismod. Aenean lacinia bibendum nulla sed consectetur. Donec id elit non mi porta gravida at eget metus. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor."),
        Content(image: UIImage(), title: "Etiam porta sem malesuada magna mollis euismod.", body: "Donec ullamcorper nulla."),
        Content(image: UIImage(), title: "Maecenas faucibus mollis interdum.", body: "Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Maecenas sed diam eget risus varius blandit sit amet non magna."),
        Content(image: UIImage(), title: "Ullamcorper Fusce Inceptos Ipsum", body: "Maecenas faucibus mollis interdum. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
        Content(image: UIImage(), title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", body: "Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus."),
        Content(image: UIImage(), title: "Quam Ridiculus", body: "Cras mattis consectetur purus sit amet fermentum."),
        Content(image: UIImage(), title: "Morbi leo risus, porta ac consectetur ac, vestibulum at eros. Praesent commodo cursus magna, vel scelerisque nisl consectetur et.", body: "Quam Purus Mattis"),
        Content(image: UIImage(), title: "Mattis Cras Ultricies", body: "Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor."),
        Content(image: UIImage(), title: "Malesuada", body: "Donec sed odio dui. Etiam porta sem malesuada magna mollis euismod."),
        Content(image: UIImage(), title: "Curabitur blandit tempus porttitor.", body: "Ornare Pellentesque Lorem Venenatis Fermentum")
    ]
    
    
    // MARK: Init
    
    init() {
        
        super.init(nibType: TemplateTableViewCell.self)
        
        cellConfigurator = { cell, index in
            
            let content = self.contents[index]
            
            cell.mainImageView.image = content.image
            cell.titleLabel.text = content.title
            cell.bodyLabel.text = content.body
            
        }
        numberOfRows = contents.count
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
}
