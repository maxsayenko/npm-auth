//
//  EventsViewController.swift
//  socializr
//
//  Created by Max Saienko on 2/26/15.
//  Copyright (c) 2015 Max Saienko. All rights reserved.
//

import UIKit
import MapKit

class EventViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var eventNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    
    var id = "1"
    
    
    override func viewDidLoad() {
        println(id)
        super.viewDidLoad()

        var longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressAction:")
        longPressRecognizer.minimumPressDuration = 2
        mapView.addGestureRecognizer(longPressRecognizer)
        
        
        var latitude:CLLocationDegrees = 37.779492
        var longditude:CLLocationDegrees = -122.391669
        
        var latDelta:CLLocationDegrees = 0.01
        var longDelta:CLLocationDegrees = 0.01
        
        var theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        var placeLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longditude)
        
        var theRegion:MKCoordinateRegion = MKCoordinateRegionMake(placeLocation, theSpan)
        
        mapView.setRegion(theRegion, animated: true)
        
        var annotation = MKPointAnnotation()
        annotation.coordinate = placeLocation
        annotation.title = "Start"
        annotation.subtitle = "Details..."
        mapView.addAnnotation(annotation)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        eventNameLabel.text = "Running"
        dateLabel.text = "date goes here"
    }
    
    func longPressAction(gestureRecognizer: UIGestureRecognizer) {
        var touchPoint = gestureRecognizer.locationInView(self.mapView)
        var newCoordinate:CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
        println(newCoordinate)
        var annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinate
        annotation.title = "Finish"
        annotation.subtitle = "Details..."
        mapView.addAnnotation(annotation)
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
