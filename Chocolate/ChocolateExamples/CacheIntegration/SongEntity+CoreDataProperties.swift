//
//  SongEntity+CoreDataProperties.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/7.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Foundation
import CoreData

extension SongEntity {

    @nonobjc class func fetchRequest() -> NSFetchRequest<SongEntity> {
        return NSFetchRequest<SongEntity>(entityName: "Song");
    }

    @NSManaged var trackId: String?
    @NSManaged var artistName: String?
    @NSManaged var trackName: String?
    @NSManaged var lastUpdated: NSDate?
    @NSManaged var sectionName: String?

}
