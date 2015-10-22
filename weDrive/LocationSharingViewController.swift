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
    var wait:Bool = false
    
    @IBOutlet weak var map1: MKMapView!
    
    var user = ""
    var event : Event? = nil
    
    var sharing:Bool = true
    
    var gname :String = "alex"
//    var from: String = " from "
//    var to: String = " from "
//    var people: [String] = []
//    var note: String = "  "
//    var time: String = "  "
    
    
    
    /////
    var startp = MKPointAnnotation()
    
    
    var destp = MKPointAnnotation()
    /////
    
    var coords_start: CLLocationCoordinate2D = CLLocationCoordinate2DMake(-35.27, 142)
    var coords_dest: CLLocationCoordinate2D = CLLocationCoordinate2DMake(-35.27, 143)
    
    
    var myRoute : MKRoute?
    var operationQueue = NSOperationQueue()
    
    var userdic = [String: String]()
    var tempuserdic = [String: String]()
    
    var notemptyDictionary:Bool = false
    
    override func viewDidLoad() {
//        super.viewDidLoad()
////        self.builddic(self.gname)
////        sleep(5)
//        var coords_start: CLLocationCoordinate2D = CLLocationCoordinate2DMake(-35.27, 142)
//        var coords_dest: CLLocationCoordinate2D = CLLocationCoordinate2DMake(-35.27, 143)
        let serial_queue = dispatch_queue_create( "serial queue", nil)
        dispatch_async(serial_queue) {
            super.viewDidLoad()
            //        self.builddic(self.gname)
            //        sleep(5)
            var coords_start: CLLocationCoordinate2D = CLLocationCoordinate2DMake(-35.27, 142)
            var coords_dest: CLLocationCoordinate2D = CLLocationCoordinate2DMake(-35.27, 143)
            self.builddic(self.gname)
            
        }
        dispatch_async(serial_queue) {
        let query = PFQuery(className: "Events")
        query.whereKey("eventName", equalTo:self.gname )
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects as? [PFObject] {
                    let start_la : Double = objects[0]["start_la"] as! Double!
                    let start_lo : Double = objects[0]["start_long"] as! Double!
                    let end_la : Double = objects[0]["end_la"] as! Double!
                    let end_lo : Double = objects[0]["end_long"] as! Double!
                    self.coords_start.latitude = start_la
                    self.coords_dest.latitude = end_la
                    self.coords_start.longitude = start_lo
                    self.coords_dest.longitude = end_lo
                    self.startp.coordinate = self.coords_start
                    self.destp.coordinate = self.coords_dest
                    
                    self.map1.addAnnotation(self.startp)
                    self.map1.addAnnotation(self.destp)
                    self.map1.delegate = self
                    self.map1.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.startp.coordinate.latitude, self.startp.coordinate.longitude), MKCoordinateSpanMake(3.0,3.0)), animated: true)
                    
                    
                    
                    let directionsRequest = MKDirectionsRequest()
                    let markStart = MKPlacemark(coordinate:CLLocationCoordinate2DMake(self.startp.coordinate.latitude, self.startp.coordinate.longitude), addressDictionary: nil)
                    
                    let markDest = MKPlacemark(coordinate:CLLocationCoordinate2DMake(self.destp.coordinate.latitude, self.destp.coordinate.longitude), addressDictionary: nil)
                    
                    directionsRequest.source = MKMapItem(placemark:markStart)
                    
                    directionsRequest.destination = MKMapItem(placemark: markDest)
                    
                    //print(directionsRequest.destination)
                    directionsRequest.transportType = MKDirectionsTransportType.Automobile
                    let directions = MKDirections(request: directionsRequest)
                    directions.calculateDirectionsWithCompletionHandler({
                        (response:MKDirectionsResponse?, error:NSError?) -> Void in
                        if error == nil {
                            
                            self.myRoute = response!.routes[0] as MKRoute
                            self.map1.addOverlay(self.myRoute!.polyline)
                        }
                    })
                   
                }
            }else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        
    
        }
        }
        dispatch_async( serial_queue) {
            self.locationManager.delegate=self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
            self.locationManager.requestWhenInUseAuthorization()
            
        }


        
//        
//        let serial_queue = dispatch_queue_create( "serial queue", nil)
//        
//        dispatch_async( serial_queue) {
//            self.builddic(self.gname)
//        }
//        
//        dispatch_sync( serial_queue) {
//                        self.locationManager.delegate=self
//                        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//                        self.locationManager.startUpdatingLocation()
//                        self.locationManager.requestWhenInUseAuthorization()
//        }
        
//        self.locationManager.delegate=self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        self.locationManager.startUpdatingLocation()
//        self.locationManager.requestWhenInUseAuthorization()
        


    
//        let operation1 : NSBlockOperation = NSBlockOperation (block: {
//            self.builddic(self.gname)
//            
//            let operation2 : NSBlockOperation = NSBlockOperation (block: {
//                
//                self.locationManager.delegate=self
//                
//                let operation3 : NSBlockOperation = NSBlockOperation (block: {
//                    
//                    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//                    
//                    let operation4: NSBlockOperation = NSBlockOperation (block: {
//                        
//                        self.locationManager.startUpdatingLocation()
//                        
//                        let operation5: NSBlockOperation = NSBlockOperation (block: {
//                            self.locationManager.requestWhenInUseAuthorization()
//                            
//                        })
//                        self.operationQueue.addOperation(operation5)
//                    })
//                    self.operationQueue.addOperation(operation4)
//                    
//                })
//                self.operationQueue.addOperation(operation3)
//            })
//            self.operationQueue.addOperation(operation2)
//            })
//        self.operationQueue.addOperation(operation1)
//        self.locationManager.delegate = self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        self.locationManager.startUpdatingLocation()
//        self.locationManager.requestWhenInUseAuthorization()
        
        
        
        
        
    }
    
//    func coordstart()
//    {
//        let query = PFQuery(className: "Events")
//        query.whereKey("eventName", equalTo:gname )
//        
//        query.findObjectsInBackgroundWithBlock {
//            (objects: [AnyObject]?, error: NSError?) -> Void in
//            
//            if error == nil {
//                // The find succeeded.
//                print("Successfully retrieved!!!!!!! ")
//                // Do something with the found objects
//                if let objects = objects as? [PFObject] {
//                    for object in objects {
//                        let start_la : Double = object["start_la"] as! Double!
//                        let start_lo : Double = object["start_long"] as! Double!
//                        let end_la : Double = object["end_la"] as! Double!
//                        let end_lo : Double = object["end_long"] as! Double!
//                        self.coords_start.latitude = start_la
//                        self.coords_dest.latitude = end_la
//                        self.coords_start.longitude = start_lo
//                        self.coords_start.longitude = end_lo
//                        self.startp.coordinate = self.coords_start
//                        self.destp.coordinate = self.coords_dest
//                        
//                        print("@@@@@@@@")
//                        print(self.coords_start)
//                        print(self.coords_dest)
//                        print("@@@@@@@@@@")
//                    }
//                }
//            } else {
//                // Log details of the failure
//                print("Error: \(error!) \(error!.userInfo)")
//            }
//        }
//        //print("!!!!!!!!")
//        //print(startp)
//        //print(destp)
//        //print("!!!!!!")
//        
//    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func builddic(groupname: String) {
        print("!!!!!@@@@@@")
        let query = PFQuery(className: "Locations")
        query.whereKey("groupname", equalTo:gname )
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
//                print("Successfully retrieved ")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        print(object.objectId)
                        print(object["uID"])
                        let temp : String = object.objectId!
                        let temp2 : String = object["uID"]! as! String
                        print("********")
                        self.userdic[temp2] = temp
                        print(self.userdic)
                        self.wait = true
                        self.notemptyDictionary = true
                    } 
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    
    @objc func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // this is for map and user location
        
        let query = PFQuery(className: "Locations")
        
        let userlocation: CLLocation = locations[0]
        print("@@@@@@@@@@@@")
        print(locations)
        print("@@@@@@@@@@@@")
        
        let latitude = userlocation.coordinate.latitude
        let longitude = userlocation.coordinate.longitude
        let latDelta:CLLocationDegrees = 0.02
        let lonDelta:CLLocationDegrees = 0.02
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        //self.map1.setRegion(region, animated: true)
        self.map1.showsUserLocation = true
        
        //this is for other users
        let anno1 = MKPointAnnotation()
        let anno2 = MKPointAnnotation()
        let anno3 = MKPointAnnotation()
        let anno4 = MKPointAnnotation()
        let anno5 = MKPointAnnotation()
        
        //check current userID for objectID
        let userObjectID = userdic[PFUser.currentUser()!.valueForKey("firstName")! as! String]
        print(userObjectID)
        
        
        //sending user location data to parse
        if(userObjectID != nil)
        {
            query.getObjectInBackgroundWithId(userObjectID!, block: { (object:PFObject?, error:NSError?) -> Void in
                
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
                        //                        // this part is for test. Delete from here
                        //                        let la = latitude + 0.0005
                        //                        let lo = longitude + 0.005
                        //                        product1["currentLocation"] = PFGeoPoint(latitude: la, longitude: lo)
                        //                        product1["latitude"] = la
                        //                        product1["longitude"] = lo
                        //
                        //
                        //                        product1.saveInBackground()
                        
                        // until here
                        if(product1["latitude"] != nil && product1["longitude"] != nil){
                            let a = product1["latitude"] as! Double
                            let b = product1["longitude"] as! Double
                            let c = product1["uID"] as! String
                        
                            let loc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(a, b)
                        
                        
                            anno1.coordinate = loc
                            anno1.title = c
                        
                        
                            self.map1.addAnnotation(anno1)
                        }
                        
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
                        //                        let la = latitude - 0.0005
                        //                        let lo = longitude + 0.005
                        //                        product1["currentLocation"] = PFGeoPoint(latitude: la, longitude: lo)
                        //                        product1["latitude"] = la
                        //                        product1["longitude"] = lo
                        //
                        //
                        //                        product1.saveInBackground()
                        
                        // until here
                        if(product1["latitude"] != nil && product1["longitude"] != nil){
                            let a = product1["latitude"] as! Double
                            let b = product1["longitude"] as! Double
                            let c = product1["uID"] as! String
                        
                            let loc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(a, b)
                        
                            anno2.coordinate = loc
                            anno2.title = c
                        
                        
                            self.map1.addAnnotation(anno2)
                        }
                        
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
                        //                        let la = latitude + 0.0005
                        //                        let lo = longitude - 0.005
                        //                        product1["currentLocation"] = PFGeoPoint(latitude: la, longitude: lo)
                        //                        product1["latitude"] = la
                        //                        product1["longitude"] = lo
                        //
                        //
                        //                        product1.saveInBackground()
                        
                        // until here
                        if(product1["latitude"] != nil && product1["longitude"] != nil){
                            let a = product1["latitude"] as! Double
                            let b = product1["longitude"] as! Double
                            let c = product1["uID"] as! String
                        
                            let loc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(a, b)
                        
                            anno3.coordinate = loc
                            anno3.title = c
                        
                        
                            self.map1.addAnnotation(anno3)
                        }
                        
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
                        //                        let la = latitude - 0.0005
                        //                        let lo = longitude - 0.005
                        //                        product1["currentLocation"] = PFGeoPoint(latitude: la, longitude: lo)
                        //                        product1["latitude"] = la
                        //                        product1["longitude"] = lo
                        //
                        //
                        //                        product1.saveInBackground()
                        
                        // until here
                        if(product1["latitude"] != nil && product1["longitude"] != nil){
                            let a = product1["latitude"] as! Double
                            let b = product1["longitude"] as! Double
                            let c = product1["uID"] as! String
                        
                            let loc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(a, b)
                        
                            anno4.coordinate = loc
                            anno4.title = c
                        
                        
                            self.map1.addAnnotation(anno4)
                        }
                        
                    }
                    
                    
                    
                }
                
            })
            tempuserdic[a1] = nil
        }
        
        
        
        
        
        
        if(tempuserdic.keys.first != nil && sharing)
        {
            _ = tempuserdic.keys.first!
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
                        //                        let la = latitude - 0.0005
                        //                        let lo = longitude - 0.003
                        //                        product1["currentLocation"] = PFGeoPoint(latitude: la, longitude: lo)
                        //                        product1["latitude"] = la
                        //                        product1["longitude"] = lo
                        //
                        //
                        //                        product1.saveInBackground()
                        
                        // until here
                        if(product1["latitude"] != nil && product1["longitude"] != nil){
                            let a = product1["latitude"] as! Double
                            let b = product1["longitude"] as! Double
                            let c = product1["uID"] as! String
                        
                            let loc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(a, b)
                        
                            anno5.coordinate = loc
                            anno5.title = c
                        
                        
                            self.map1.addAnnotation(anno5)
                        }
                        
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
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let myLineRenderer = MKPolylineRenderer(polyline: (myRoute!.polyline))
        myLineRenderer.strokeColor = UIColor.blueColor()
        myLineRenderer.lineWidth = 3
        return myLineRenderer
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if segue.identifier == "backToViewSegue" {
//            let detailViewController = segue.destinationViewController as! EventDetailViewController
//            detailViewController.name = self.gname
//            detailViewController.from = self.from
//            detailViewController.to = self.to
//            detailViewController.note = self.note
//            detailViewController.time = self.time
//            detailViewController.people = self.people
//        }
//    }
    
    
    @IBAction func backTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("backToListSegue", sender: self)
    }

    
    
    
    
    
}
