//
//  ViewController.swift
//  WeDriveTong
//
//  Created by Jeanette Zhang123 on 19/07/2015.
//  Copyright (c) 2015 Jeanette Zhang. All rights reserved.
//

import UIKit
import ParseUI
import Parse
class SignupLoginViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate{
    var signUpVC: PFSignUpViewController! = PFSignUpViewController()
    var logInVC: PFLogInViewController! = PFLogInViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (PFUser.currentUser() == nil) { //if no user currently logged in
            self.logInVC.fields = PFLogInFields.UsernameAndPassword | PFLogInFields.LogInButton | PFLogInFields.PasswordForgotten | PFLogInFields.DismissButton | PFLogInFields.SignUpButton
            
            //customize login and signup logo
            var loginLogo=UILabel()
            loginLogo.text="WeDrive"
            loginLogo.font=UIFont(name: "Futura", size: 50)
            loginLogo.textColor=UIColor.darkGrayColor()
            self.logInVC.logInView!.logo=loginLogo
            self.logInVC.delegate=self
            
            var signupLogo=UILabel()
            signupLogo.text="WeDrive"
            signupLogo.font=UIFont(name: "Futura", size: 50)
            signupLogo.textColor=UIColor.darkGrayColor()
            self.signUpVC.signUpView!.logo=signupLogo
            self.signUpVC.delegate=self
            self.logInVC.signUpController=self.signUpVC
        }
    }
    //TONG: Parse Sign up
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
        println("User signed up and logged in through Parse! \(user)")
    }
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        println("User failed to Parse sign up")
    }
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        println("User dismissed Parse sign up")
    }
    
    
    //TONG: Parse Login
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        if (username.isEmpty || password.isEmpty){
            return false
        } else {
            return true
        }
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
        println("User logged in through Parse! \(user)")
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        println("Parse login failed")
    }
    
    
    @IBAction func basicLoginButton(sender: UIButton) {
        self.presentViewController(self.logInVC, animated: true, completion: nil)
        performSegueWithIdentifier("LoginSegue", sender: self)
    }
    
    
    @IBAction func logOutButton(sender: AnyObject) {
        if PFUser.currentUser() != nil {
            PFUser.logOut()
            println("User is logged out")
        } else{
            println("No user is currently logged in")
        }
    }
    
    
}


