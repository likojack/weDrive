//
//  SignupVC.swift
//  WeDriveTong
//
//  Created by Jeanette Zhang on 19/08/2015.
//  Copyright (c) 2015 Jeanette Zhang. All rights reserved.
//

import UIKit
//import Parse
class SignupVC: UIViewController, UITextFieldDelegate{
	
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var signupFirstnameField: UITextField!
	@IBOutlet weak var signupLastnameField: UITextField!
	@IBOutlet weak var signupEmailField: UITextField!
	@IBOutlet weak var signupPasswordField: UITextField!
	@IBOutlet weak var signupRepeatPasswordField: UITextField!
	
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
		scrollView.setContentOffset(CGPointMake(0, 20), animated: true) //250 is size of keyboard
	}
	func textFieldDidEndEditing(textField: UITextField) {
		scrollView.setContentOffset(CGPointMake(0, -55), animated: true) //250 is size of keyboard
	}
	

	
	//TODO: check repeat password is same as password
	@IBAction func creationAccountButton(sender: AnyObject) {
		let signupFirstname = signupFirstnameField.text
		let signupLastname = signupLastnameField.text
		
		let signupEmail = signupEmailField.text
		let signupPassword = signupPasswordField.text
		
		let newUser=PFUser()
		newUser.username = signupEmail //NOTE: use email as username
		newUser["firstName"]=signupFirstname
		newUser["lastName"]=signupLastname
		newUser.password = signupPassword
		newUser.email = signupEmail
		newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
			if(error != nil){
				let incompleteSignupInfoAlert = UIAlertView(title: "Invalid", message: "Please complete all fields", delegate: self, cancelButtonTitle: "OK")
				incompleteSignupInfoAlert.show()
			} else { //user created
				print("User successfully signed up through Parse! \(newUser)")
				self.performSegueWithIdentifier("signupLoginSegue", sender: self)
			}
		})
		

	}
	
}