//
//  ProfileDetailViewController.swift
//  weDrive
//
//  Created by ZHAOZIKAI on 8/10/2015.
//  Copyright © 2015 michelle. All rights reserved.
//

import Foundation
import UIKit
import Parse

class ProfileDetailViewController: UIViewController {

    @IBOutlet weak var Email: UILabel!
    
    @IBOutlet weak var Username: UILabel!
    
    @IBOutlet weak var Region: UILabel!
    
    @IBOutlet weak var Status: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Email.text = PFUser.currentUser()?.email
        self.Username.text = PFUser.currentUser()?.email
        self.Region.text = PFUser.currentUser()?.email
        self.Status.text = PFUser.currentUser()?.email
    }
    

    @IBAction func BackButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("BackButtonTapped", sender: self)
    }
    
    
    @IBAction func LogoutButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("LogoutButtonTapped", sender: self)
    }
    
}

//    @IBAction func EditButtonTapped(sender: AnyObject) {
//        self.performSegueWithIdentifier("EditSegue", sender: self)
//    }
//    
//}