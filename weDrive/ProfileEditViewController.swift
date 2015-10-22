//
//  ProfileEditViewController.swift
//  weDrive
//
//  Created by ZHAOZIKAI on 8/10/2015.
//  Copyright © 2015 michelle. All rights reserved.
//

import Foundation
import UIKit
import Parse

class ProfileEditViewController: UIViewController{
    
    @IBOutlet weak var Email: UITextField!
   
    @IBOutlet weak var Username: UITextField!
    
    @IBOutlet weak var Region: UITextField!
    
    @IBOutlet weak var Status: UITextField!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.Email.text = PFUser.currentUser()?.email
        self.Username.text = PFUser.currentUser()?.email
        self.Region.text = PFUser.currentUser()?.email
        self.Status.text = PFUser.currentUser()?.email
        }
    
    @IBAction func CancelButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("CancelButtonTapped", sender: self)
    }
 
    @IBAction func SaveButtonTapped(sender: AnyObject) {
        PFUser.currentUser()?.email = self.Email.text
        PFUser.currentUser()?.email = self.Username.text
        PFUser.currentUser()?.email = self.Region.text
        PFUser.currentUser()?.email = self.Status.text
        self.performSegueWithIdentifier("CancelButtonTapped", sender: self)
    }
    
}