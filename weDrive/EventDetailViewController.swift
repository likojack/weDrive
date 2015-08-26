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
    var tappedImage : UIImage? = nil
    
    @IBOutlet weak var previewImageView: UIImageView!
    
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
        self.previewImageView.image = UIImage(data: self.event!.previewimage)
        self.eventLabel.text = self.event?.name
        self.fromLabel.text = self.event!.from
        self.toLabel.text = self.event!.to
        self.peopleLabel.text = printPeople
        self.noteLabel.text = self.event!.note
        self.timeLabel.text = self.event?.time
        
        var previewTapRecognizer = UITapGestureRecognizer(target: self, action: "previewTapped")
        self.previewImageView.addGestureRecognizer(previewTapRecognizer)
        
    }
    
    func previewTapped() {
        self.tappedImage = self.previewImageView.image
        self.performSegueWithIdentifier("zoomSegue", sender: self)
    }
    
    @IBAction func StartTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("ToLocationSharing", sender: self)
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "zoomSegue" {
            var zoomViewController = segue.destinationViewController as! ZoomViewController
            zoomViewController.image = self.tappedImage!
        }
        
        if segue.identifier == "ToLocationSharing" {
            var locationViewController = segue.destinationViewController as! LocationSharingViewController
            locationViewController.user = PFUser.currentUser()!.username!
            locationViewController.gname = self.event!.name
        }
    }

    @IBAction func backTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("detailBackSegue", sender: self)
    }
    


}
