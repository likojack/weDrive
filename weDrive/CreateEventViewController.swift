//
//  CreateEventViewController.swift
//  weDrive
//
//  Created by Michelle Lau on 21/07/2015.
//  Copyright (c) 2015 michelle. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation


class CreateEventViewController: UIViewController,UINavigationControllerDelegate{

	@IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var peopleTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var Timebutton: UIButton!
   
    
    var people : [String] = []
    var name : String = ""
    var note : String = ""
    var from : String = ""
    var to : String = ""
    var selectedDate : String = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()

		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
		self.scrollView.addGestureRecognizer(tap)
        
		
        let backButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelTapped:")
        navigationItem.leftBarButtonItem = backButton
        let rightButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "saveTapped:")
        navigationItem.rightBarButtonItem = rightButton

        
    }
    
	func dismissKeyboard(){ //hide keyboard on tapping anywhere
		view.endEditing(true)
	}
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder() //hide keyboard on return
		return true
	}
	func textFieldDidBeginEditing(textField: UITextField) {
		scrollView.setContentOffset(CGPointMake(0, 100), animated: true) //250 is size of keyboard
	}
	func textFieldDidEndEditing(textField: UITextField) {
		scrollView.setContentOffset(CGPointMake(0, 0), animated: true) //250 is size of keyboard
	}

	
    override func viewWillAppear(animated: Bool) {
        self.nameTextField.text = self.name
        self.fromTextField.text = self.from
        self.toTextField.text = self.to
        self.noteTextField.text = self.note

    }
   
    @IBAction func buttonTapped(sender: AnyObject) {
        DatePickerDialog().show(title: "DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .Date) {
            (date) -> Void in
            self.timeTextField.text = "\(date)"
        }
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("backToManageSegue", sender: self)
    }
    @IBAction func saveTapped(sender: AnyObject) {
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        let event = NSEntityDescription.insertNewObjectForEntityForName("Event", inManagedObjectContext: context) as! Event
        event.name = self.nameTextField.text!
        event.people = self.people
        event.from = self.fromTextField.text!
        event.to = self.toTextField.text!
        event.note = self.noteTextField.text!
               //event.time = selectedDate
        event.time = self.timeTextField.text!
        do {
            try context.save()
        } catch _ {
        }
        let TestObject = PFObject(className: "Events")
        TestObject["eventName"] = event.name
        TestObject["startPoint"] = event.from
        TestObject["endPoint"] = event.to
        
        for i in event.people {
            let object_location = PFObject(className: "Locations")
            object_location["uID"] = i
            object_location["groupname"] = event.name
            let query = PFQuery(className: "_User")
            query.whereKey("firstName", equalTo:i )
            
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    // The find succeeded.
                    print("Successfully retrieved ")
                }
                
                    // Do something with the found objects
                    if let objects = objects as? [PFObject] {
//                        let latitude = objects[0]["latitude"]
//                        let longitude = objects[0]["longitude"]
//                        object_location["latitude"] = latitude
//                        object_location["longitude"] = longitude
                        object_location["sharing"] = true
                        object_location.saveInBackgroundWithBlock{(success:Bool, error: NSError?) -> Void in print("location object saved")}
                
                    } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
        
        }
        let user_location = PFObject(className: "Locations")
        user_location["uID"] = PFUser.currentUser()!.valueForKey("firstName")!
        user_location["groupname"] = event.name
        let query = PFQuery(className: "_User")
        query.whereKey("username", equalTo:PFUser.currentUser()!.username!)
        print(PFUser.currentUser()?.username!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved ")
            }
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
//                    let latitude = objects[0]["latitude"]
//                    let longitude = objects[0]["longitude"]
//                    user_location["latitude"] = latitude
//                    user_location["longitude"] = longitude
                    user_location["sharing"] = true
                    user_location.saveInBackgroundWithBlock{(success:Bool, error: NSError?) -> Void in print("location object saved")}
                
                } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(event.from, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error)
            }
            if let placemark_start = placemarks?.first {
                let coordinates_start:CLLocationCoordinate2D = placemark_start.location!.coordinate
                
                let geocoder_end = CLGeocoder()
                
                geocoder_end.geocodeAddressString(event.to, completionHandler: {(placemarks, error) -> Void in
                    if((error) != nil){
                        print("Error", error)
                    }
                    if let placemark_end = placemarks?.first {
                        let coordinates_end:CLLocationCoordinate2D = placemark_end.location!.coordinate
                        print("@@@@")
                        print(event.from)
                        print(event.to)
                        TestObject["start_long"] = coordinates_start.longitude
                        TestObject["start_la"] = coordinates_start.latitude
                        TestObject["end_long"] = coordinates_end.longitude
                        TestObject["end_la"] = coordinates_end.latitude
                        TestObject.saveInBackgroundWithBlock{(success:Bool, error: NSError?) -> Void in print("object saved")}
                        
                    }
                })
                
            }
        })
        
        
        
        
        
        
        
        
        
        self.performSegueWithIdentifier("backToManageSegue", sender: self)
    }
    
   
    @IBAction func contactTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("contactListSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "contactListSegue" {
            let contactListViewController = segue.destinationViewController as! ContactListViewController
            contactListViewController.name = self.nameTextField.text!
            contactListViewController.from = self.fromTextField.text!
            contactListViewController.to = self.toTextField.text!
            contactListViewController.note = self.noteTextField.text!
            contactListViewController.selectedPeople = self.people
        }
    }
    //@IBOutlet weak var DatePicker: UIDatePicker!
    
//    @IBAction func dataPickerAction(sender: AnyObject) {
//        var dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
//        var strDate = dateFormatter.stringFromDate(DatePicker.date)
//        self.selectedDate = strDate
//        
//    }
}
