//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation




class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    
    
    @IBOutlet var map1: MKMapView!
    
    var locationManager = CLLocationManager()
    
    //user ID
    
    var user = "alex@gmail.com"
    
    //locatin sharing option
    var sharing:Bool = true
    
    //group name
    var gname = "alex"
    
    
    //group list (uID and objectID dictionary)
    
    var userdic = [String: String]()
    var tempuserdic = [String:String]()
    
    //checking empty dictionay
    
    var notemptyDictionary:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // map initiate
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        /*
        //get objectIDs of all group members
        var query = PFQuery(className:"Locations")
        query.whereKey("groupname", equalTo:gname)
        //query.whereKey("sharing", equalTo:sharing)
        //query.whereKey("uID", notEqualTo:"alex@gmail.com")
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved ")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        //println(object.objectId)
                        //println(object["uID"])
                        let temp : String = object.objectId!
                        let temp2 : String = object["uID"]! as! String
                        println(temp)
                        println(temp2)
                        
                    }
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
        */


        builddic(gname )
        
    }

    func builddic(groupname: String)
    {
        
        var query = PFQuery(className:"Locations")
        query.whereKey("groupname", equalTo:gname)
        //query.whereKey("sharing", equalTo:sharing)
        //query.whereKey("uID", notEqualTo:"alex@gmail.com")
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved ")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        //println(object.objectId)
                        //println(object["uID"])
                        let temp : String = object.objectId!
                        let temp2 : String = object["uID"]! as! String
                        println("********")
                        self.userdic[temp2] = temp
                        println(self.userdic)
                        
                        self.notemptyDictionary = true

                        
                    }
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
        
       

    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
       // println(locations)
        //println("*********************")

        
        // this is for map and user location
        var query = PFQuery(className: "Locations")
        
        var userlocation: CLLocation = locations[0] as! CLLocation
        
        var latitude = userlocation.coordinate.latitude
        var longitude = userlocation.coordinate.longitude
        var latDelta:CLLocationDegrees = 0.02
        var lonDelta:CLLocationDegrees = 0.02
        
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        self.map1.setRegion(region, animated: true)
        self.map1.showsUserLocation = true
        
        //this is for other users
        var anno1 = MKPointAnnotation()
        var anno2 = MKPointAnnotation()
        var anno3 = MKPointAnnotation()
        var anno4 = MKPointAnnotation()
        var anno5 = MKPointAnnotation()
        
        //check current userID for objectID
        var userObjectID = userdic[user] as String!
        println(userObjectID)
        println("&&&&&&&&&&&&&&&&&&&&&")

        
        //sending user location data to parse
        if(userObjectID != nil && sharing)
        {
            query.getObjectInBackgroundWithId(userObjectID, block: { (object:PFObject?, error:NSError?) -> Void in
            
            if error != nil
            {
                println(error)
            }
            else if let product = object
            {
                var la = latitude
                var lo = longitude
                product["currentLocation"] = PFGeoPoint(latitude: la, longitude: lo)
                product["latitude"] = la
                product["longitude"] = lo
                product.saveInBackground()
                
            }

            })
        }
        

        //to show others locations
        tempuserdic = userdic
        
        tempuserdic[user] = nil
        
        var query1 = PFQuery(className: "Locations")
        var query2 = PFQuery(className: "Locations")
        var query3 = PFQuery(className: "Locations")
        var query4 = PFQuery(className: "Locations")
        var query5 = PFQuery(className: "Locations")
        
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
                    println(error)
                }
                else if let product1 = object
                {
                    
                    var tbool = product1["sharing"] as! BooleanLiteralType
                    
                    if(tbool == true )
                    {
                        // this part is for test. Delete from here
                        var la = latitude + 0.0005
                        var lo = longitude + 0.005
                        product1["currentLocation"] = PFGeoPoint(latitude: la, longitude: lo)
                        product1["latitude"] = la
                        product1["longitude"] = lo
                        
                        
                        product1.saveInBackground()
                        
                        // until here
                        
                        let a = product1["latitude"] as! Double
                        let b = product1["longitude"] as! Double
                        let c = product1["uID"] as! String
                        
                        var loc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(a, b)
                        
                        anno1.coordinate = loc
                        anno1.title = c
                        
                        
                        self.map1.addAnnotation(anno1)
                    
                    }

                    
                    
                }
                
            })
            
             tempuserdic[a1] = nil
             println(tempuserdic)
            
        }
        
        
       
        
        
        if(tempuserdic.keys.first != nil && sharing)
        {
            let a1 = tempuserdic.keys.first!
            let a2 = tempuserdic.values.first!
             println("{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{")
            
            
            query1.getObjectInBackgroundWithId(a2, block: { (object:PFObject?, error:NSError?) -> Void in
                
                if error != nil
                {
                    println(error)
                    
                }
                else if let product1 = object
                {
                   
                    var tbool = product1["sharing"] as! BooleanLiteralType
                   
                    if(tbool == true )
                    {
                        // this part is for test. Delete from here
                        var la = latitude - 0.0005
                        var lo = longitude + 0.005
                        product1["currentLocation"] = PFGeoPoint(latitude: la, longitude: lo)
                        product1["latitude"] = la
                        product1["longitude"] = lo
                        
                        
                        product1.saveInBackground()
                        
                        // until here
                        
                        let a = product1["latitude"] as! Double
                        let b = product1["longitude"] as! Double
                        let c = product1["uID"] as! String
                        
                        var loc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(a, b)
                        
                        anno2.coordinate = loc
                        anno2.title = c
                        
                        
                        self.map1.addAnnotation(anno2)
                        
                    }
                    
                    
                    
                }
                
            })
            tempuserdic[a1] = nil
        }
        
        
       
        /*
        
        if(tempuserdic.keys.first != nil && sharing)
        {
            let a1 = tempuserdic.keys.first!
            let a2 = tempuserdic.values.first!
            
            query1.getObjectInBackgroundWithId(a2, block: { (object:PFObject?, error:NSError?) -> Void in
                
                if error != nil
                {
                    println(error)
                }
                else if let product1 = object
                {
                    
                    var tbool = product1["sharing"] as! BooleanLiteralType
                    
                    if(tbool == true )
                    {
                        // this part is for test. Delete from here
                        var la = latitude + 0.0005
                        var lo = longitude - 0.005
                        product1["currentLocation"] = PFGeoPoint(latitude: la, longitude: lo)
                        product1["latitude"] = la
                        product1["longitude"] = lo
                        
                        
                        product1.saveInBackground()
                        
                        // until here
                        
                        let a = product1["latitude"] as! Double
                        let b = product1["longitude"] as! Double
                        let c = product1["uID"] as! String
                        
                        var loc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(a, b)
                        
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
            
            query1.getObjectInBackgroundWithId(a2, block: { (object:PFObject?, error:NSError?) -> Void in
                
                if error != nil
                {
                    println(error)
                }
                else if let product1 = object
                {
                    
                    var tbool = product1["sharing"] as! BooleanLiteralType
                    
                    if(tbool == true )
                    {
                        // this part is for test. Delete from here
                        var la = latitude - 0.0005
                        var lo = longitude - 0.005
                        product1["currentLocation"] = PFGeoPoint(latitude: la, longitude: lo)
                        product1["latitude"] = la
                        product1["longitude"] = lo
                        
                        
                        product1.saveInBackground()
                        
                        // until here
                        
                        let a = product1["latitude"] as! Double
                        let b = product1["longitude"] as! Double
                        let c = product1["uID"] as! String
                        
                        var loc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(a, b)
                        
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
            let a1 = tempuserdic.keys.first!
            let a2 = tempuserdic.values.first!
            
            query1.getObjectInBackgroundWithId(a2, block: { (object:PFObject?, error:NSError?) -> Void in
                
                if error != nil
                {
                    println(error)
                }
                else if let product1 = object
                {
                    
                    var tbool = product1["sharing"] as! BooleanLiteralType
                    
                    if(tbool == true )
                    {
                        // this part is for test. Delete from here
                        var la = latitude - 0.0005
                        var lo = longitude - 0.003
                        product1["currentLocation"] = PFGeoPoint(latitude: la, longitude: lo)
                        product1["latitude"] = la
                        product1["longitude"] = lo
                        
                        
                        product1.saveInBackground()
                        
                        // until here
                        
                        let a = product1["latitude"] as! Double
                        let b = product1["longitude"] as! Double
                        let c = product1["uID"] as! String
                        
                        var loc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(a, b)
                        
                        anno5.coordinate = loc
                        anno5.title = c
                        
                        
                        self.map1.addAnnotation(anno5)
                        
                    }
                    
                    
                    
                }
                
            })
            
        }

        */

        

        
       /* let annotationsToRemove = map1.annotations.filter { $0 !== self.map1.userLocation }
        map1.removeAnnotations( annotationsToRemove )

        self.map1.addAnnotation(anno1)
        self.map1.addAnnotation(anno2)
        self.map1.addAnnotation(anno3)
        self.map1.addAnnotation(anno4)
        self.map1.addAnnotation(anno5) */
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

