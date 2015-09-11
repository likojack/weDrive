//
//  ForgetPasswordVC.swift
//  weDrive
//
//  Created by Jeanette Zhang on 11/09/2015.
//  Copyright (c) 2015 michelle. All rights reserved.
//

import Foundation
class ForgetPasswordVC: UIViewController{
	
	@IBOutlet weak var emailTextField: UITextField!
	
	@IBAction func sendRecoveryEmailButton(sender: UIButton) {
		let userEmail=emailTextField.text
		PFUser.requestPasswordResetForEmailInBackground(userEmail){
			(success:Bool, error: NSError?) -> Void in
			if (success){
				println("password reset email sent to \(userEmail)");
			}
			if (error != nil){
				println(error)
			}
		}
	}
}