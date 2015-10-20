//
//  ViewController.swift
//  WeDriveTong
//
//  Created by Jeanette Zhang on 19/07/2015.
//  Copyright (c) 2015 Jeanette Zhang. All rights reserved.
//

import UIKit
//import Parse

class LoginVC: UIViewController, UITextFieldDelegate{
	
	/*********** Basic login ***********/
	
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var loginEmailField: UITextField!
	@IBOutlet weak var loginPasswordField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
		self.scrollView.addGestureRecognizer(tap)
	}
	
	func dismissKeyboard(){ //hide keyboard on tapping anywhere
		view.endEditing(true)
	}
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder() //hide keyboard on return
		return true
	}
	func textFieldDidBeginEditing(textField: UITextField) {
		scrollView.setContentOffset(CGPointMake(0, 60), animated: true) //250 is size of keyboard
	}
	func textFieldDidEndEditing(textField: UITextField) {
		scrollView.setContentOffset(CGPointMake(0, 0), animated: true) //250 is size of keyboard
	}
	//Login Button	
	@IBAction func loginButton(sender: AnyObject) {
		let loginEmail = self.loginEmailField.text
		let loginPassword = self.loginPasswordField.text
		
		
		//TODO: verify email and password
		if (loginEmail!.isEmpty || loginPassword!.isEmpty){
			let incompleteLoginInfoAlert = UIAlertView(title: "Invalid", message: "Please enter your email address and password", delegate: self, cancelButtonTitle: "OK")
			incompleteLoginInfoAlert.show()
		} else { //email and password verified
			PFUser.logInWithUsernameInBackground(loginEmail!, password: loginPassword!, block: {(user, error) -> Void in
			//if inside this block, request was successful
				if ((user) != nil){
					print("User logged in through Parse \(user)")
					self.performSegueWithIdentifier("loginSegue", sender: self)
				} else {
					print("User failed to login")
				}
			})
		}
	}
	
	//Signup Button
	@IBAction func signupButton(sender: AnyObject) { self.performSegueWithIdentifier("signupSegue", sender: self)
	}
	
	
	/*********** Login with Facebook ***********/
	let permissions = ["public_profile", "email", "user_friends"]
	
	@IBAction func faceBookLoginButton(sender: UIButton) {
		PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: {(user:PFUser?, error: NSError?) -> Void in
			if user == nil { NSLog("User cancelled the Facebook login.") }
			else if user!.isNew {
				NSLog("User signed up and logged in through Facebook! \(user)")
				self.performSegueWithIdentifier("loginSegue", sender: self)
			} else if user != nil{
				NSLog("User logged in through Facebook! \(user)")
				self.performSegueWithIdentifier("loginSegue", sender: self)
			}
		})
	}
	



}

