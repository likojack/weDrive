//
//  ViewController.swift
//  WeDriveTong
//
//  Created by Jeanette Zhang on 19/07/2015.
//  Copyright (c) 2015 Jeanette Zhang. All rights reserved.
//

import UIKit
import Parse

class LoginVC: UIViewController {
	/*********** Basic login ***********/
	@IBOutlet weak var loginEmailField: UITextField!
	@IBOutlet weak var loginPasswordField: UITextField!
	
	//Login Button	
	@IBAction func loginButton(sender: AnyObject) {
		var loginEmail = self.loginEmailField.text
		var loginPassword = self.loginPasswordField.text
		
		
		//TODO: verify email and password
		if (loginEmail.isEmpty || loginPassword.isEmpty){
			var incompleteLoginInfoAlert = UIAlertView(title: "Invalid", message: "Please enter your email address and password", delegate: self, cancelButtonTitle: "OK")
			incompleteLoginInfoAlert.show()
		} else { //email and password verified
			PFUser.logInWithUsernameInBackground(loginEmail, password: loginPassword, block: {(user, error) -> Void in
			//if inside this block, request was successful
				if ((user) != nil){
					println("User logged in through Parse \(user)")
					self.performSegueWithIdentifier("loginSegue", sender: self)
				} else {
					println("User failed to login")
				}
			})
		}
	}
	
	//Signup Button
	@IBAction func signupButton(sender: AnyObject) { self.performSegueWithIdentifier("signupSegue", sender: self)
	}
	
	
	/*********** Login with Facebook ***********/
	/*
	let permissions = ["public_profile", "email", "user_friends"]

	@IBAction func faceBookLoginButton(sender: UIButton) {
		PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: {(user:PFUser?, error: NSError?) -> Void in
			if user == nil { NSLog("User cancelled the Facebook login.") }
			else if user!.isNew { NSLog("User signed up and logged in through Facebook! \(user)") }
			else if user != nil{NSLog("User logged in through Facebook! \(user)") }
		})
	
	}
	*/



}

