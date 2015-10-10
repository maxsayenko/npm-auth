//
//  EventsViewController.swift
//  socializr
//
//  Created by Max Saienko on 2/26/15.
//  Copyright (c) 2015 Max Saienko. All rights reserved.
//

import UIKit
import MapKit

@available(iOS 8.0, *)
class EventViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var eventNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var notesText: UITextView!
    @IBOutlet var joinView: UIView!
    
    @IBOutlet var namesCollectionView: UICollectionView!
    
    @IBAction func yesButtonClick(sender: AnyObject) {
        joinView.hidden = true
    }
    
    @IBAction func noButtonClick(sender: AnyObject) {
        joinView.hidden = true
    }
    
    @IBAction func flagButtonClick(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Flag this event", message: "You can report this event if it contains offensive message. Do you want to report it?", preferredStyle: .Alert)

        let okAction = UIAlertAction(title: "Report", style:UIAlertActionStyle.Default,
        handler: {
            (alertCtrl: UIAlertAction) -> Void in
            FirebaseService.flagEvent(self.eventDataModel.id)
            self.navigationItem.rightBarButtonItem = nil
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style:UIAlertActionStyle.Cancel,
            handler: {
                (alertCtrl: UIAlertAction) -> Void in
        })
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: {
            () -> Void in
        })
    }
    
    var eventDataModel: EventDataModel = EventDataModel()
    var isFlagged: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFlagged {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressAction:")
        longPressRecognizer.minimumPressDuration = 2
        mapView.addGestureRecognizer(longPressRecognizer)

        let latDelta:CLLocationDegrees = 0.03
        let longDelta:CLLocationDegrees = 0.03
        
        let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        let placeLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(eventDataModel.location.lat, eventDataModel.location.lng)
        let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(placeLocation, theSpan)
        mapView.setRegion(theRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placeLocation
        annotation.title = "Start"
        annotation.subtitle = "Details..."
        mapView.addAnnotation(annotation)
    }
    
    override func viewDidAppear(animated: Bool) {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let startDate = dateFormatter.stringFromDate(eventDataModel.startTime)
        let endDate = dateFormatter.stringFromDate(eventDataModel.endTime)
        dateLabel.text = "\(startDate) - \(endDate)"
        
        eventNameLabel.text = eventDataModel.name

        notesText.text = eventDataModel.notes
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
        return eventDataModel.users.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: TextViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("textCell", forIndexPath: indexPath) as! TextViewCell
        if let name: String = eventDataModel.users[indexPath.row]["name"] as? String {
            cell.textInCell.text = name
        }
        return cell
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
