//
//  EventsViewController.swift
//  socializr
//
//  Created by Max Saienko on 2/26/15.
//  Copyright (c) 2015 Max Saienko. All rights reserved.
//

import UIKit
import MapKit

class EventViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var eventNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    //@IBOutlet var eventUsersLabel: UILabel!
    
    @IBOutlet var notesText: UITextView!
    @IBOutlet var joinView: UIView!
    
    @IBOutlet var namesCollectionView: UICollectionView!
    
    @IBAction func yesButtonClick(sender: AnyObject) {
        joinView.hidden = true
    }
    
    @IBAction func noButtonClick(sender: AnyObject) {
        joinView.hidden = true
    }
    
    var id = "1"
    var name = ""
    var lat:CLLocationDegrees = 0
    var lng:CLLocationDegrees = 0
    var startTime:NSDate = NSDate()
    var endTime:NSDate = NSDate()
    var users:NSMutableArray = NSMutableArray()
    var notes: String = ""
    
    
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
    }
    
    override func viewDidAppear(animated: Bool) {
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        var startDate = dateFormatter.stringFromDate(startTime)
        var endDate = dateFormatter.stringFromDate(endTime)
        
        eventNameLabel.text = name
        dateLabel.text = "\(startDate) - \(endDate)"
        
        if(users.count > 0) {
            var usersString = ""
            for name in self.users {
                usersString += "\(name)\n"
            }
        }
        
        notesText.text = notes
    }

    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let numberOfCellsPerRow : CGFloat = 3.0
        let minGapBetweenCells : CGFloat = 10.0
        let totalSpaceBetweenCells : CGFloat = (numberOfCellsPerRow - 1) * minGapBetweenCells
        let cellWidth : CGFloat = (collectionView.frame.size.width - totalSpaceBetweenCells) / numberOfCellsPerRow

        return CGSize(width: cellWidth, height: 20)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: textViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("textCell", forIndexPath: indexPath) as! textViewCell
        cell.textInCell.text = users[indexPath.row] as? String
        return cell
    }
    
    // not sure if I need it here
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
