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
    
    //locatin sharing option
    var sharing:Bool = true
    
    //group name
    var gname = "alex"
    
    
    //group list (uID and objectID dictionary)
    
    var userdic = [String: String]()
    
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
        if(self.notemptyDictionary == true)
        {
            println(userdic)
            println("######")
            
        }
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
        
        var query = PFQuery(className: "GPS_TEST")
        
        
        var userlocation: CLLocation = locations[0] as! CLLocation
        
        var latitude = userlocation.coordinate.latitude
        var longtitude = userlocation.coordinate.longitude
        var latDelta:CLLocationDegrees = 0.02
        var lonDelta:CLLocationDegrees = 0.02
        
        
        var anno1 = MKPointAnnotation()
        var anno2 = MKPointAnnotation()
        var anno3 = MKPointAnnotation()
        var anno4 = MKPointAnnotation()
        var anno5 = MKPointAnnotation()
        

        
        query.getObjectInBackgroundWithId("1Y2Encb4v5", block: { (object:PFObject?, error:NSError?) -> Void in
            
            if error != nil
            {
                println(error)
            }
            else if let product = object
            {
                var la = latitude
                var lo = longtitude
                product["gps"] = PFGeoPoint(latitude: la, longitude: lo)
                product["lat"] = la
                product["lon"] = lo
                product.saveInBackground()
                
            }

        })
        
        
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longtitude)
        
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        
        self.map1.setRegion(region, animated: true)
        
        self.map1.showsUserLocation = true
        
        var query1 = PFQuery(className: "GPS_TEST")
        var query2 = PFQuery(className: "GPS_TEST")
        var query3 = PFQuery(className: "GPS_TEST")
        var query4 = PFQuery(className: "GPS_TEST")
        var query5 = PFQuery(className: "GPS_TEST")
        
        
        let annotationsToRemove = map1.annotations.filter { $0 !== self.map1.userLocation }
        map1.removeAnnotations( annotationsToRemove )


        
        query1.getObjectInBackgroundWithId("QDDXMfJ6D0", block: { (object:PFObject?, error:NSError?) -> Void in
            
            if error != nil
            {
                println(error)
            }
            else if let product1 = object
            {
                var la = latitude + 0.0005
                var lo = longtitude + 0.005
                product1["gps"] = PFGeoPoint(latitude: la, longitude: lo)
                product1["lat"] = la
                product1["lon"] = lo
                
               
                product1.saveInBackground()
                
                let a = product1["lat"] as! Double
                let b = product1["lon"] as! Double
                let c = product1["name"] as! String
                
                var loc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(a, b)
                
                anno1.coordinate = loc
                anno1.title = c
                
               
                self.map1.addAnnotation(anno1)
                
                                
            }
            
        })
        

       
        query2.getObjectInBackgroundWithId("uHmFtBY09t", block: { (object:PFObject?, error:NSError?) -> Void in
            
            if error != nil
            {
                println(error)
            }
            else if let product1 = object
            {
                var la = latitude + 0.005
                var lo = longtitude + 0.0005
                product1["gps"] = PFGeoPoint(latitude: la, longitude: lo)
                product1["lat"] = la
                product1["lon"] = lo
                
                
                product1.saveInBackground()
                
                let a = product1["lat"] as! Double
                let b = product1["lon"] as! Double
                let c = product1["name"] as! String
                
                var loc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(a, b)
                
                anno2.coordinate = loc
                anno2.title = c
                
                
                
                self.map1.addAnnotation(anno2)
                
                
            }
            
        })
        

        
        query3.getObjectInBackgroundWithId("lkvA4gSd4q", block: { (object:PFObject?, error:NSError?) -> Void in
            
            if error != nil
            {
                println(error)
            }
            else if let product1 = object
            {
                var la = latitude - 0.005
                var lo = longtitude + 0.0005
                product1["gps"] = PFGeoPoint(latitude: la, longitude: lo)
                product1["lat"] = la
                product1["lon"] = lo
                
                
                product1.saveInBackground()
                
                let a = product1["lat"] as! Double
                let b = product1["lon"] as! Double
                let c = product1["name"] as! String
                
                var loc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(a, b)
                
                anno3.coordinate = loc
                anno3.title = c
                
                
                
                self.map1.addAnnotation(anno3)
                
                
            }
            
        })
        

        query4.getObjectInBackgroundWithId("Fm21GSz1zy", block: { (object:PFObject?, error:NSError?) -> Void in
            
            if error != nil
            {
                println(error)
            }
            else if let product1 = object
            {
                var la = latitude - 0.0005
                var lo = longtitude - 0.005
                product1["gps"] = PFGeoPoint(latitude: la, longitude: lo)
                product1["lat"] = la
                product1["lon"] = lo
                
                
                product1.saveInBackground()
                
                let a = product1["lat"] as! Double
                let b = product1["lon"] as! Double
                let c = product1["name"] as! String
                
                var loc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(a, b)
                
                anno4.coordinate = loc
                anno4.title = c
                
                
                
                self.map1.addAnnotation(anno4)
                
                
            }
            
        })
        
        
        
        query5.getObjectInBackgroundWithId("BC4JlZm0aq", block: { (object:PFObject?, error:NSError?) -> Void in
            
            if error != nil
            {
                println(error)
            }
            else if let product1 = object
            {
                var la = latitude - 0.005
                var lo = longtitude - 0.005
                product1["gps"] = PFGeoPoint(latitude: la, longitude: lo)
                product1["lat"] = la
                product1["lon"] = lo
                
                
                product1.saveInBackground()
                
                let a = product1["lat"] as! Double
                let b = product1["lon"] as! Double
                let c = product1["name"] as! String
                
                var loc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(a, b)
                
                anno5.coordinate = loc
                anno5.title = c
                
                
                
                self.map1.addAnnotation(anno5)
                
                
            }
            
        })
        
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

