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
        
        return try! CoreDataStack(name: "", model: model, options: nil, storeType: .memory)
        
    }
    
    private func setUpDumpData() {
    
        let context = stack.viewContext
        
        let names = [ "Roy", "Allen", "Alex", "Bob", "Christen", "Tiffany", "Helen", "Kevin", "David", "Kitty", "Darren", "Candy", "Carol" ]
        
        names.forEach { insert(name: $0, in: context) }
        
        try! context.save()
    
    }
    
    private func insert(name: String, in context: NSManagedObjectContext) {
    
        let person = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context)
        person.setValue(name, forKey: "name")
        let firstCharacter = name[name.startIndex]
        let lowercasedFirstCharacter = String(firstCharacter).lowercased()
        person.setValue(lowercasedFirstCharacter, forKey: "firstLetterOfName")
    
    }
    
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return fetchedResultsController.sections?[section].name.uppercased()
        
    }
    
    override func configure(cell: CHTableViewCell, forRowAt indexPath: IndexPath) {
        
        let person = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = person.value(forKey: "name") as? String
        
    }
    
}
