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
    @IBOutlet var eventUsersLabel: UILabel!
    
    @IBOutlet var notesText: UITextView!
    
    var id = "1"
    var name = ""
    var lat:CLLocationDegrees = 0
    var lng:CLLocationDegrees = 0
    var startTime:NSDate = NSDate()
    var endTime:NSDate = NSDate()
    var users:NSMutableArray = NSMutableArray()    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressAction:")
        longPressRecognizer.minimumPressDuration = 2
        mapView.addGestureRecognizer(longPressRecognizer)
        
// ancestry coords
//        var latitude:CLLocationDegrees = 37.779492
//        var longditude:CLLocationDegrees = -122.391669
        
        var latitude:CLLocationDegrees = lat
        var longditude:CLLocationDegrees = lng
        
        var latDelta:CLLocationDegrees = 0.03
        var longDelta:CLLocationDegrees = 0.03
        
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
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        var startDate = dateFormatter.stringFromDate(startTime)
        var endDate = dateFormatter.stringFromDate(endTime)
        
        eventNameLabel.text = name
        dateLabel.text = "\(startDate) - \(endDate)"
        
        //println(users.count)
        // println(users[0])
        
        eventUsersLabel.text = "one \n two \n three \n four \n five \n six \n seven"
        notesText.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, mais also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s avec the release of Letraset sheets containing Lorem Ipsum passages, and more recently avec desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
    }
    
    func longPressAction(gestureRecognizer: UIGestureRecognizer) {
        var touchPoint = gestureRecognizer.locationInView(self.mapView)
        var newCoordinate:CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
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
