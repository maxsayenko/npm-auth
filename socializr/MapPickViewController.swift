//
//  MapPickViewController.swift
//  socializr
//
//  Created by Max Saienko on 2/26/15.
//  Copyright (c) 2015 Max Saienko. All rights reserved.
//

import UIKit
import MapKit

class MapPickViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressAction:")
        //longPressRecognizer.minimumPressDuration = 2
        mapView.addGestureRecognizer(longPressRecognizer)
        
        
        var latitude:CLLocationDegrees = 37.779492
        var longditude:CLLocationDegrees = -122.391669
        
        var latDelta:CLLocationDegrees = 0.01
        var longDelta:CLLocationDegrees = 0.01
        
        var theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        var placeLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longditude)
        
        if(Singleton.sharedInstance.eventLocation != nil) {
            placeLocation = Singleton.sharedInstance.eventLocation
            
            var annotation = MKPointAnnotation()
            annotation.coordinate = placeLocation
            annotation.title = "Start"
            annotation.subtitle = "Details..."
            mapView.addAnnotation(annotation)
        }
        
        var theRegion:MKCoordinateRegion = MKCoordinateRegionMake(placeLocation, theSpan)
        mapView.setRegion(theRegion, animated: true)
    }

    
    func longPressAction(gestureRecognizer: UIGestureRecognizer) {
        if(gestureRecognizer.state == UIGestureRecognizerState.Began) {
            var touchPoint = gestureRecognizer.locationInView(self.mapView)
            var newCoordinate:CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            
            Singleton.sharedInstance.eventLocation = newCoordinate
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
