//
//  ViewController.swift
//  weDrive
//
//  Created by kejielee on 23/08/2015.
//  Copyright (c) 2015 michelle. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation

class LocationSharingViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    
    var user = "alex@gmail.com"
    
    var sharing:Bool = true
    
    var gname = "alex"
    
    var userdic = [String: String]()
    var tempuserdic = [String: String]()
    
    var notemptyDictionary:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //map initiate
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        builddic(gname)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var map1: MKMapView!
    
    func builddic(groupname: String) {
        var query = PFQuery(className: "Locations")
        query.whereKey("groupname", equalTo:gname )
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved ")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        //println(object.objectId)
                        //println(object["uID"])
                        let temp : String = object.objectId!
                        let temp2 : String = object["uID"]! as! String
                        print("********")
                        self.userdic[temp2] = temp
                        print(self.userdic)
                        
                        self.notemptyDictionary = true
                        
                        
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // println(locations)
        //println("*********************")
        
        
        // this is for map and user location
        let query = PFQuery(className: "Locations")
        
        let userlocation: CLLocation = locations[0] 
        
        let latitude = userlocation.coordinate.latitude
        let longitude = userlocation.coordinate.longitude
        let latDelta:CLLocationDegrees = 0.02
        let lonDelta:CLLocationDegrees = 0.02
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        self.map1.setRegion(region, animated: true)
        self.map1.showsUserLocation = true
        
        //this is for other users
        let anno1 = MKPointAnnotation()
        let anno2 = MKPointAnnotation()
        let anno3 = MKPointAnnotation()
        let anno4 = MKPointAnnotation()
        let anno5 = MKPointAnnotation()
        
        //check current userID for objectID
        let userObjectID = userdic[user] as String!
        //print(userObjectID)
        print("&&&&&&&&&&&&&&&&&&&&&")
        
        
        //sending user location data to parse
        if(userObjectID != nil && sharing)
        {
            query.getObjectInBackgroundWithId(userObjectID, block: { (object:PFObject?, error:NSError?) -> Void in
                
                if error != nil
                {
                    print(error)
                }
                else if let product = object
                {
                    let la = latitude
                    let lo = longitude
                    product["currentLocation"] = PFGeoPoint(latitude: la, longitude: lo)
                    product["latitude"] = la
                    product["longitude"] = lo
                    product["sharing"] = self.sharing
                    product.saveInBackground()
                    
                }
                
            })
        }
        
        
        //to show others locations
        tempuserdic = userdic
        
        tempuserdic[user] = nil
        
        let query1 = PFQuery(className: "Locations")
        let query2 = PFQuery(className: "Locations")
        let query3 = PFQuery(className: "Locations")
        let query4 = PFQuery(className: "Locations")
        let query5 = PFQuery(className: "Locations")
        
        // remove all annotation for renewal
        let annotationsToRemove = map1.annotations.filter { $0 !== self.map1.userLocation }
        map1.removeAnnotations( annotationsToRemove )
        
        
        if(tempuserdic.keys.first != nil && sharing)
        {
            let a1 = tempuserdic.keys.first!
            let a2 = tempuserdic.values.first!
            
            query1.getObjectInBackgroundWithId(a2, block: { (object:PFObject?, error:NSError?) -> Void in
                
                if error != nil
                {
                    print(error)
                }
                else if let product1 = object
                {
                    
                    let tbool = product1["sharing"] as! BooleanLiteralType
                    
                    if(tbool == true )
                    {
                        // this part is for test. Delete from here
                        let la = latitude + 0.0005
                        let lo = longitude + 0.005
                        product1["currentLocation"] = PFGeoPoint(latitude: la, longitude: lo)
                        product1["latitude"] = la
                        product1["longitude"] = lo
                        
                        
                        product1.saveInBackground()
                        
                        // until here
                        
                        let a = product1["latitude"] as! Double
                        let b = product1["longitude"] as! Double
                        let c = product1["uID"] as! String
                        
                        let loc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(a, b)
                        
                        
                        anno1.coordinate = loc
                        anno1.title = c
                        
                        
                        self.map1.addAnnotation(anno1)
                        
                    }
                    
                    
                    
                }
                
            })
            
            tempuserdic[a1] = nil
            print(tempuserdic)
            
        }
        
        
        
        
        
        if(tempuserdic.keys.first != nil && sharing)
        {
            let a1 = tempuserdic.keys.first!
            let a2 = tempuserdic.values.first!
            print("{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{")
            
            
            query2.getObjectInBackgroundWithId(a2, block: { (object:PFObject?, error:NSError?) -> Void in
                
                if error != nil
                {
                    print(error)
                    
                }
                else if let product1 = object
                {
                    
                    let tbool = product1["sharing"] as! BooleanLiteralType
                    
                    if(tbool == true )
                    {
                        // this part is for test. Delete from here
                        let la = latitude - 0.0005
                        let lo = longitude + 0.005
                        product1["currentLocation"] = PFGeoPoint(latitude: la, longitude: lo)
                        product1["latitude"] = la
                        product1["longitude"] = lo
                        
                        
                        product1.saveInBackground()
                        
                        // until here
                        
                        let a = product1["latitude"] as! Double
                        let b = product1["longitude"] as! Double
                        let c = product1["uID"] as! String
                        
                        let loc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(a, b)
                        
                        anno2.coordinate = loc
                        anno2.title = c
                        
                        
                        self.map1.addAnnotation(anno2)
                        
                    }
                    
                    
                    
                }
                
            })
            tempuserdic[a1] = nil
        }
        
        
        
        
        
        if(tempuserdic.keys.first != nil && sharing)
        {
            let a1 = tempuserdic.keys.first!
            let a2 = tempuserdic.values.first!
            
            query3.getObjectInBackgroundWithId(a2, block: { (object:PFObject?, error:NSError?) -> Void in
                
                if error != nil
                {
                    print(error)
                }
                else if let product1 = object
                {
                    
                    let tbool = product1["sharing"] as! BooleanLiteralType
                    
                    if(tbool == true )
                    {
                        // this part is for test. Delete from here
                        let la = latitude + 0.0005
                        let lo = longitude - 0.005
                        product1["currentLocation"] = PFGeoPoint(latitude: la, longitude: lo)
                        product1["latitude"] = la
                        product1["longitude"] = lo
                        
                        
                        product1.saveInBackground()
                        
                        // until here
                        
                        let a = product1["latitude"] as! Double
                        let b = product1["longitude"] as! Double
                        let c = product1["uID"] as! String
                        
                        let loc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(a, b)
                        
                        anno3.coordinate = loc
                        anno3.title = c
                        
                        
                        self.map1.addAnnotation(anno3)
                        
                    }
                    
                    
                    
                }
                
            })
            tempuserdic[a1] = nil
        }
        
        
        
        
        
        
        if(tempuserdic.keys.first != nil && sharing)
        {
            let a1 = tempuserdic.keys.first!
            let a2 = tempuserdic.values.first!
            
            query4.getObjectInBackgroundWithId(a2, block: { (object:PFObject?, error:NSError?) -> Void in
                
                if error != nil
                {
                    print(error)
                }
                else if let product1 = object
                {
                    
                    let tbool = product1["sharing"] as! BooleanLiteralType
                    
                    if(tbool == true )
                    {
                        // this part is for test. Delete from here
                        let la = latitude - 0.0005
                        let lo = longitude - 0.005
                        product1["currentLocation"] = PFGeoPoint(latitude: la, longitude: lo)
                        product1["latitude"] = la
                        product1["longitude"] = lo
                        
                        
                        product1.saveInBackground()
                        
                        // until here
                        
                        let a = product1["latitude"] as! Double
                        let b = product1["longitude"] as! Double
                        let c = product1["uID"] as! String
                        
                        let loc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(a, b)
                        
                        anno4.coordinate = loc
                        anno4.title = c
                        
                        
                        self.map1.addAnnotation(anno4)
                        
                    }
                    
                    
                    
                }
                
            })
            tempuserdic[a1] = nil
        }
        
        
        
        
        
        
        if(tempuserdic.keys.first != nil && sharing)
        {
            var a1 = tempuserdic.keys.first!
            let a2 = tempuserdic.values.first!
            
            query5.getObjectInBackgroundWithId(a2, block: { (object:PFObject?, error:NSError?) -> Void in
                
                if error != nil
                {
                    print(error)
                }
                else if let product1 = object
                {
                    
                    let tbool = product1["sharing"] as! BooleanLiteralType
                    
                    if(tbool == true )
                    {
                        // this part is for test. Delete from here
                        let la = latitude - 0.0005
                        let lo = longitude - 0.003
                        product1["currentLocation"] = PFGeoPoint(latitude: la, longitude: lo)
                        product1["latitude"] = la
                        product1["longitude"] = lo
                        
                        
                        product1.saveInBackground()
                        
                        // until here
                        
                        let a = product1["latitude"] as! Double
                        let b = product1["longitude"] as! Double
                        let c = product1["uID"] as! String
                        
                        let loc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(a, b)
                        
                        anno5.coordinate = loc
                        anno5.title = c
                        
                        
                        self.map1.addAnnotation(anno5)
                        
                    }
                    
                    
                    
                }
                
            })
            
        }
        
        
        
        
        
        
        /* let annotationsToRemove = map1.annotations.filter { $0 !== self.map1.userLocation }
        map1.removeAnnotations( annotationsToRemove )
        
        self.map1.addAnnotation(anno1)
        self.map1.addAnnotation(anno2)
        self.map1.addAnnotation(anno3)
        self.map1.addAnnotation(anno4)
        self.map1.addAnnotation(anno5) */
    }
    
    
    
    
    
    
    
}
