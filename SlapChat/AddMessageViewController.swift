//
//  AddMessageViewController.swift
//  SlapChat
//
//  Created by Arvin San Miguel on 11/8/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import CoreData

class AddMessageViewController: UIViewController {

    
    var store = DataStore.sharedInstance
    
    @IBOutlet weak var messageTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func saveTapped(_ sender: AnyObject) {
        
        if let text = messageTextfield.text {
            
            addData(message: text)
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func addData(message: String) {
        let managedObjectContext = store.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Message", in: managedObjectContext) else {
            fatalError("Could not find entity descriptions!")
        }
        
        guard let message1 = NSManagedObject(entity: entity, insertInto: managedObjectContext) as? Message else { return }
        message1.setValue(message, forKey: "content")
        message1.setValue(NSDate.distantFuture, forKey: "createdAt")
        
        do { try managedObjectContext.save()
            store.messages.append(message1)
        } catch let error { print(error) }
        
    }
    
}
