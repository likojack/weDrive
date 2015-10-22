//
//  ForgetPasswordVC.swift
//  weDrive
//
//  Created by Jeanette Zhang on 11/09/2015.
//  Copyright (c) 2015 michelle. All rights reserved.
//

import Foundation
class ForgetPasswordVC: UIViewController, UITextFieldDelegate{
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.emailTextField.delegate = self;
 }
	
	@IBOutlet weak var emailTextField: UITextField!

	@IBAction func sendRecoveryEmailButton(sender: UIButton) {
		let userEmail=emailTextField.text
		PFUser.requestPasswordResetForEmailInBackground(userEmail!){
			(success:Bool, error: NSError?) -> Void in
			if (success){
				print("password reset email sent to \(userEmail)");
			}
			if (error != nil){
				print(error)
			}
		}
	}
	//dismiss keyboard on pressing return
	func textFieldShouldReturn(emailTextField: UITextField) -> Bool {
		emailTextField.resignFirstResponder()
		return true;
	}
	//dismiss keyboard on pressing anywhere
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		self.view.endEditing(true)
	}
}