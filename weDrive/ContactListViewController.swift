//
//  ContactListViewController.swift
//  weDrive
//
//  Created by kejielee on 27/07/2015.
//  Copyright (c) 2015 michelle. All rights reserved.
//
import Parse
import UIKit


var userName = ""


class ContactListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var resultsTable: UITableView!
    var name : String = ""
    var note : String = ""
    var from : String = ""
    var to : String = ""
    var selectedCell : [Int] = []
    var selectedPeople : [String] = []
    
    
    
    var resultsProfileNameArray = [String]()
    var resultsUsernameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = view.frame.size.width
        let theHeight = view.frame.size.height
        self.resultsTable.dataSource = self
        self.resultsTable.delegate = self
        
        let backButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelTapped:")
        navigationItem.leftBarButtonItem = backButton
        let rightButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "doneTapped:")
        navigationItem.rightBarButtonItem = rightButton
        
        resultsTable.frame = CGRectMake(0, 0, theHeight, theHeight-64)
        
        userName = PFUser.currentUser()!.objectId!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        resultsProfileNameArray.removeAll(keepCapacity: false)
        resultsUsernameArray.removeAll(keepCapacity: false)
        
        //let predicate = NSPredicate(format: "objectId != '" + userName + "'")
        let query = PFQuery(className: "_User")
        query.whereKey("objectId", notEqualTo: userName)
        let objects = query.findObjects()
        
        for object in objects!
        {
            self.resultsUsernameArray.append(object.username!!)
            self.resultsProfileNameArray.append(object["firstName"] as! String)
            
            self.resultsTable.reloadData()
        }
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsUsernameArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.resultsUsernameArray[indexPath.row]
        return cell
        
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
        
        if segue.identifier == "peopleAddedSegue" {
            _ = segue.destinationViewController as! CreateEventViewController
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
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if (cell!.selected == true) {
            selectedPeople.append(cell!.textLabel!.text!)
        }
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("contactCancelSegue", sender: self)
    }
    
    @IBAction func doneTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("peopleAddedSegue", sender: self)
    }
    
}
