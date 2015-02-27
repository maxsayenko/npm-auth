//
//  ViewController.swift
//  socializr
//
//  Created by Max Saienko on 2/26/15.
//  Copyright (c) 2015 Max Saienko. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate {
    var eventsCollection = EventsCollection()
    var events:NSMutableArray = NSMutableArray()
    var rouletteEvents:NSMutableArray = NSMutableArray()
    var userId = Singleton.sharedInstance.userId

    @IBOutlet var lunchRouletteView: UIView!

    @IBAction func noButtonClick(sender: UIButton) {
        lunchRouletteView.hidden = true
    }

    @IBAction func yesButtonClick(sender: UIButton) {
        //joinLunchRoulette()
        lunchRouletteView.hidden = true
    }

    //var newEvents:NS
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func ButtonClick(sender: UIButton) {
        // joinLunchRoulette();
//        let eventsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("eventView") as EventViewController
//        self.navigationController?.pushViewController(eventsViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        //      self.navigationController?.navigationBarHidden = true
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateList:", name: "EventsUpdated", object: nil)
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
        
        if(event["id"]? != nil) {
            eventsViewController.id = event["id"] as NSString
        }
        
        if(event["name"]? != nil) {
            eventsViewController.name = event["name"] as NSString
        }
        
        if(event["startTime"]? != nil) {
            eventsViewController.startTime = convertStringToDate(event["startTime"] as NSString)
        }
        
        if(event["endTime"]? != nil) {
            eventsViewController.endTime = convertStringToDate(event["endTime"] as NSString)
        }
        
        var location: AnyObject? = event["location"]? as AnyObject?
        
        var lat:Double = location?["lat"] as Double
        var lng:Double = location?["lng"] as Double
        
        eventsViewController.lat = lat
        eventsViewController.lng = lng
        
        if(event["users"]? != nil) {
            eventsViewController.users = event["users"] as NSMutableArray
        }
        
        if(event["notes"]? != nil) {
            eventsViewController.notes = event["notes"] as String
        }
        
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
    
    func joinLunchRoulette() {
        rouletteEvents = NSMutableArray()
        eventsCollection.fetchLunchRouletteEvents()
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "parseRouletteEvents:", name: "GetRouletteEvents", object: nil)
    }
    
    func parseRouletteEvents(notification: NSNotification) {
        for e in notification.userInfo! {
            var users:NSMutableArray = e.1["name"] as NSMutableArray
            if (users.count < 5) {
                rouletteEvents.addObject(e.1)
            }
        }
//         TODO: figure this out
//        rouletteEvents.shuffle()
//        eventsCollection.addUserToEvent(userId)
    }
}

