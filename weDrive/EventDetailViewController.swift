//
//  EventDetailViewController.swift
//  weDrive
//
//  Created by Michelle Lau on 21/07/2015.
//  Copyright (c) 2015 michelle. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {

    var event : Event? = nil
    
    @IBOutlet weak var peopleLabel: UILabel!
    
    @IBOutlet weak var fromLabel: UILabel!
    
    @IBOutlet weak var toLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var eventLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var printPeople : String = ""
        for var i = 0; i < self.event?.people.count; i++ {
            printPeople = printPeople + " " + self.event!.people[i]
        }
        
        
        self.navigationItem.title = self.event!.name
        self.eventLabel.text = self.event?.name
        self.fromLabel.text = self.event!.from
        self.toLabel.text = self.event!.to
        self.peopleLabel.text = printPeople
        self.noteLabel.text = self.event!.note
        self.timeLabel.text = self.event?.time
        
        
    }
    
    
    @IBAction func StartTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("ToLocationSharing", sender: self)
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "ToLocationSharing" {
            let locationViewController = segue.destinationViewController as! LocationSharingViewController
            locationViewController.user = PFUser.currentUser()!.username!
            locationViewController.gname = self.event!.name
        }
    }

    @IBAction func backTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("detailBackSegue", sender: self)
    }
    


}
