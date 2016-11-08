//
//  TableViewController.swift
//  SlapChat
//
//  Created by Ian Rahman on 7/16/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var store = DataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        store.fetchData()
        
        if store.messages.isEmpty {
            generateTestData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.fetchData()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
        
        let message = store.messages[indexPath.row]
        if let content = message.value(forKey: "content") as? String,
            let date = message.value(forKey: "createdAt") as? Date {
            cell.textLabel?.text = content
            cell.detailTextLabel?.text = self.dateFormat(date: date)
        }
        
        return cell
    }
    
    
}


extension TableViewController {
    
    func generateTestData() {
        let managedObjectContext = store.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Message", in: managedObjectContext) else {
            fatalError("Could not find entity descriptions!")
        }
        
        guard let message1 = NSManagedObject(entity: entity, insertInto: managedObjectContext) as? Message else { return }
        message1.setValue("labs overload t(-_-t)", forKey: "content")
        message1.setValue(NSDate.distantFuture, forKey: "createdAt")
        
        do { try managedObjectContext.save()
            store.messages.append(message1)
            tableView.reloadData()
            
        } catch let error { print(error) }
        
    }
    
    
    
    func dateFormat(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: date)
        
    }
}
