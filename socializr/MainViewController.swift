//
//  ViewController.swift
//  socializr
//
//  Created by Max Saienko on 2/26/15.
//  Copyright (c) 2015 Max Saienko. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate {
    var events:NSMutableArray = NSMutableArray()
    
    //var newEvents:NS
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func ButtonClick(sender: UIButton) {
        let eventsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("eventView") as EventViewController
        self.navigationController?.pushViewController(eventsViewController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
//      self.navigationController?.navigationBarHidden = true
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateList:", name: "EventsUpdated", object: nil)
        
        EventsCollection()
    }
    
    override func viewDidAppear(animated: Bool) {
        Singleton.sharedInstance.eventLocation  = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Get Cell Count
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    // Populate table items
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // just testing
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = self.events[indexPath.row]["name"] as NSString
        return cell
    }
    
    // Cell Click
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //CODE TO BE RUN ON CELL TOUCH
        let eventsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("eventView") as EventViewController
        
        var event: AnyObject = self.events[indexPath.row] as AnyObject
        
        eventsViewController.id = event["id"] as NSString
        eventsViewController.name = event["name"] as NSString
        eventsViewController.startTime = convertStringToDate(event["startTime"] as NSString)
        eventsViewController.endTime = convertStringToDate(event["endTime"] as NSString)
        
        var location = event["location"]? as AnyObject?
        
        println(location?["lat"])
        
        var lat:Double = location?["lat"] as Double
        var lng:Double = location?["lng"] as Double
        
        eventsViewController.lat = lat
        eventsViewController.lng = lng
        
        self.navigationController?.pushViewController(eventsViewController, animated: true)
    }
    
    func convertStringToDate(date: NSString) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        /*find out and place date format from http://userguide.icu-project.org/formatparse/datetime*/
        // println(dateFormatter.dateFromString(date))
        return dateFormatter.dateFromString(date)!
    }
    
    func updateList(notification: NSNotification) {
        for e in notification.userInfo!{
            self.events.addObject(e.1)
        }
        
        // send notification just for testing when the view is loaded
        scheduleNotification()

        tableView.reloadData()
    }
    
    // schedule notification
    func scheduleNotification() {
        var localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = "Testing notifications on iOS8"
        localNotification.alertBody = "Local notifications are working"
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 5)
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.category = "invite"
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
}

