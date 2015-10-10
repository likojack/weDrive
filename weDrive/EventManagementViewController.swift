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
    
    override func viewWillAppear(animated: Bool) {
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        
        let request = NSFetchRequest(entityName: "Event")
        
        let results = try? context.executeFetchRequest(request)
        
        //insert invited event to event management list
        let query = PFQuery(className: "events")
        query.whereKey("participants", containedIn: [PFUser.currentUser()!.username!])
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved ")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        let invited_event : Event? = nil
                        invited_event!.name = object["eventName"] as! String
                        invited_event!.from = object["startPoint"] as! String
                        invited_event!.to = object["endPoint"] as! String
                        invited_event!.people = object["participants"] as! [String]
                        self.eventlist.append(invited_event!)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    
        //until here
        if results != nil {
            self.eventlist = results! as! [Event]
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventlist.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let event = self.eventlist[indexPath.row]
        cell.textLabel!.text = event.name
        cell.imageView!.image = UIImage(data: event.previewimage)
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

