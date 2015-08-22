//
//  SignupVC.swift
//  WeDriveTong
//
//  Created by Jeanette Zhang on 19/08/2015.
//  Copyright (c) 2015 Jeanette Zhang. All rights reserved.
//

import UIKit
//import Parse
class SignupVC: UIViewController{
	
	@IBOutlet weak var signupFirstnameField: UITextField!
	
	@IBOutlet weak var signupLastnameField: UITextField!
	
	@IBOutlet weak var signupEmailField: UITextField!
	
	@IBOutlet weak var signupPasswordField: UITextField!
	
	@IBOutlet weak var signupRepeatPasswordField: UITextField!
	//TODO: check repeat password is same as password
	
	@IBAction func creationAccountButton(sender: AnyObject) {
		var signupFirstname = signupFirstnameField.text
		var signupLastname = signupLastnameField.text
		
		var signupEmail = signupEmailField.text
		var signupPassword = signupPasswordField.text
		
		var newUser=PFUser()
		newUser.username = signupEmail //NOTE: use email as username
		newUser.password = signupPassword
		newUser.email = signupEmail
		newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
			if(error != nil){
				var incompleteSignupInfoAlert = UIAlertView(title: "Invalid", message: "Please complete all fields", delegate: self, cancelButtonTitle: "OK")
				incompleteSignupInfoAlert.show()
			} else { //user created
				println("User successfully signed up through Parse! \(newUser)")
				self.performSegueWithIdentifier("signupLoginSegue", sender: self)
			}
		})
		

	}
	
}