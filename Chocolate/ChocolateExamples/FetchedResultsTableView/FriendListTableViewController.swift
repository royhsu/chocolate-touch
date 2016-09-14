//
//  FriendListTableViewController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/9/14.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CHFoundation
import Chocolate
import CoreData
import UIKit

class FriendListTableViewController: CHFetchedResultsTableViewController {

    
    // MARK: Property
    
    private let stack: CoreDataStack
    
    
    // MARK: Init
    
    init() {
        
        stack = FriendListTableViewController.setUpStack()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: stack.viewContext,
            sectionNameKeyPath: "firstLetterOfName",
            cacheName: nil
        )
        
        super.init(fetchedResultsController: fetchedResultsController)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError()
        
    }
    
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpDumpData()
        
    }
    
    
    // MARK: Set Up
    
    private class func setUpStack() -> CoreDataStack {
        
        let nameProperty = NSAttributeDescription()
        nameProperty.name = "name"
        nameProperty.attributeType = .stringAttributeType
        nameProperty.isOptional = false
        
        let firstLetterOfName = NSAttributeDescription()
        firstLetterOfName.name = "firstLetterOfName"
        firstLetterOfName.attributeType = .stringAttributeType
        firstLetterOfName.isOptional = false
        
        let entity = NSEntityDescription()
        entity.name = "Person"
        entity.properties.append(nameProperty)
        entity.properties.append(firstLetterOfName)
        
        let model = NSManagedObjectModel()
        model.entities.append(entity)
        
        let storeURL = URL.fileURL(filename: "Friend", withExtension: "sqlite", in: .document(domainMask: .userDomainMask))
        
        print("Store url: \(storeURL)")
        
        return try! CoreDataStack(name: "", model: model, options: nil, storeType: .local(storeURL: storeURL))
        
    }
    
    private func setUpDumpData() {
    
        let context = stack.viewContext
        
        let roy = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context)
        roy.setValue("Roy", forKey: "name")
        roy.setValue("r", forKey: "firstLetterOfName")
        
        let allen = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context)
        allen.setValue("Allen", forKey: "name")
        allen.setValue("a", forKey: "firstLetterOfName")
        
        let alex = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context)
        alex.setValue("Alex", forKey: "name")
        alex.setValue("a", forKey: "firstLetterOfName")
        
        try! context.save()
    
    }
    
}
