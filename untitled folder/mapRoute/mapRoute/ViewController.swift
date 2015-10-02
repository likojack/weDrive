//
//  ViewController.swift
//  mapRoute
//
//  Created by Alex Kang on 3/09/2015.
//  Copyright (c) 2015 Alex Kang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, MKMapViewDelegate {


    @IBOutlet var myMap: MKMapView!
    var myRoute : MKRoute?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        var startp = MKPointAnnotation()
        var destp = MKPointAnnotation()
        
        var startp_lat = -35.0
        var startp_long = 149.0
        
        var destp_lat = -37.0
        var destp_long = 144.0
        
        startp.coordinate = CLLocationCoordinate2DMake(startp_lat, startp_long)
        startp.title = "Start"
        startp.subtitle = "We start at 10 am!"
        
        
        myMap.addAnnotation(startp)
        
        destp.coordinate = CLLocationCoordinate2DMake(destp_lat, destp_long)
        destp.title = "Destination"
        destp.subtitle = "Meet here!"
        myMap.addAnnotation(destp)
        myMap.centerCoordinate = destp.coordinate
        myMap.delegate = self
        
        //Span of the map
        myMap.setRegion(MKCoordinateRegionMake(startp.coordinate, MKCoordinateSpanMake(3.0,3.0)), animated: true)
        
        var directionsRequest = MKDirectionsRequest()
        let markStart = MKPlacemark(coordinate: CLLocationCoordinate2DMake(startp.coordinate.latitude, startp.coordinate.longitude), addressDictionary: nil)
        let markDest = MKPlacemark(coordinate: CLLocationCoordinate2DMake(destp.coordinate.latitude, destp.coordinate.longitude), addressDictionary: nil)
        
        directionsRequest.setSource(MKMapItem(placemark: markDest))
        directionsRequest.setDestination(MKMapItem(placemark: markStart))
        directionsRequest.transportType = MKDirectionsTransportType.Automobile
        var directions = MKDirections(request: directionsRequest)
        directions.calculateDirectionsWithCompletionHandler { (response:MKDirectionsResponse!, error: NSError!) -> Void in
            if error == nil {
                self.myRoute = response.routes[0] as? MKRoute
                self.myMap.addOverlay(self.myRoute?.polyline)
        
            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        var myLineRenderer = MKPolylineRenderer(polyline: myRoute?.polyline!)
        myLineRenderer.strokeColor = UIColor.blueColor()
        myLineRenderer.lineWidth = 3
        return myLineRenderer
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

