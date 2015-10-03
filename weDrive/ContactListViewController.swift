//
//  ContactListViewController.swift
//  weDrive
//
//  Created by kejielee on 27/07/2015.
//  Copyright (c) 2015 michelle. All rights reserved.
//
import Parse
import UIKit

class ContactListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var people = ["George", "Ben", "Cindy"]
    
    
    
    
    

//    if error == nil {
//    // The find succeeded.
//    
//    for object in objects {
//
//    self.people.append(object.username)
//    
//    
//    }
//    else {
//    // Log details of the failure
//    NSLog("Error: %@ %@", error, error.userInfo!)
//    }
//    
//    dispatch_async(dispatch_get_main_queue()) {
//    self.tableView.reloadData()
//    }
    
    
    var name : String = ""
    var note : String = ""
    var from : String = ""
    var to : String = ""
    var selectedCell : [Int] = []
    var selectedPeople : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ContactListTableView.dataSource = self
        self.ContactListTableView.delegate = self
        
        let backButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelTapped:")
        navigationItem.leftBarButtonItem = backButton
        let rightButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "doneTapped:")
        navigationItem.rightBarButtonItem = rightButton
        
        let que = PFQuery(className: "User")
        que.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                // Do something with the found objects
                if let objs = objects {
                    for object in objs {
                       // self.people.append(object.username)
                    }
                }
                
            } else {
                print("\(error)")
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var ContactListTableView: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.people.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = people[indexPath.row]
        return cell

    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedPeople.append(people[indexPath.row])
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("contactCancelSegue", sender: self)
    }
   
    @IBAction func doneTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("peopleAddedSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "peopleAddedSegue" {
            let eventCreateViewController = segue.destinationViewController as! CreateEventViewController
            eventCreateViewController.people = self.selectedPeople
            eventCreateViewController.name = self.name
            eventCreateViewController.note = self.note
            eventCreateViewController.from = self.from
            eventCreateViewController.to = self.to
            
        }
        if segue.identifier == "contactCancelSegue" {
            let eventCreateViewController = segue.destinationViewController as! CreateEventViewController
            eventCreateViewController.people = self.selectedPeople
            eventCreateViewController.name = self.name
            eventCreateViewController.note = self.note
            eventCreateViewController.from = self.from
            eventCreateViewController.to = self.to
        }
    }

}
