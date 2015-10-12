//
//  EventManagementViewController.swift
//  weDrive
//
//  Created by Michelle Lau on 21/07/2015.
//  Copyright (c) 2015 michelle. All rights reserved.
//

import UIKit
import CoreData

class EventManagementViewController: UIViewController, UITableViewDataSource, UITableViewDelegate   {

    @IBOutlet weak var eventListTableView: UITableView!
    @IBOutlet weak var createButton: UIBarButtonItem!
    
    var eventlist : [Event] = []
    var selectedEvent : Event? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eventListTableView.dataSource = self
        self.eventListTableView.delegate = self
        
    }
    func removeDuplicates(array: [Event]) -> [Event] {
        var encountered = Set<Event>()
        var result: [Event] = []
        for value in array {
            if encountered.contains(value) {
                // Do not add a duplicate element.
            }
            else {
                // Add value to the set.
                encountered.insert(value)
                // ... Append the value.
                result.append(value)
            }
        }
        return result
    }
    
    override func viewWillAppear(animated: Bool) {
        //insert invited event to event management list
        let query = PFQuery(className: "Events")
        query.whereKey("participants", containedIn: [PFUser.currentUser()!.username!])
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    
                    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
                    
                    let request = NSFetchRequest(entityName: "Event")
                    
                    let results = try? context.executeFetchRequest(request)
                    
                    if results != nil {
                        self.eventlist = results! as! [Event]
                    }
                    for object in objects {
                        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
                        let invited_event = NSEntityDescription.insertNewObjectForEntityForName("Event", inManagedObjectContext: context) as! Event
                        print(object["eventName"] as! String)
                        invited_event.name = object["eventName"] as! String
                        invited_event.from = object["startPoint"] as! String
                        invited_event.to = object["endPoint"] as! String
                        invited_event.people = object["participants"] as! [String]
                        self.eventlist.append(invited_event)
                    }
                    self.eventlist = self.removeDuplicates(self.eventlist)
                    self.eventListTableView.reloadData()
                    
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        //until here
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventlist.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel!.text = self.eventlist[indexPath.row].name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedEvent = self.eventlist[indexPath.row]
        self.performSegueWithIdentifier("eventDetialSegue", sender: self)
    }
    
    
    @IBAction func createTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("createSegue", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "eventDetialSegue" {
            let detailViewController = segue.destinationViewController as! EventDetailViewController
            detailViewController.event = self.selectedEvent
        } 
    }

}

