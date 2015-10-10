//
//  ViewController.swift
//  socializr
//
//  Created by Max Saienko on 2/26/15.
//  Copyright (c) 2015 Max Saienko. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class AllEventsViewController: UIViewController, UITableViewDelegate, EULAViewControllerDelegate {
    // dependecy variables
    var firebaseService: FirebaseService! = FirebaseService()
    var events: NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateList:", name: "EventsUpdated", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "eventChanged:", name: "EventChanged", object: nil)
        
        // Regestering custom table cell
        let nib = UINib(nibName: "EventTableCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "eventTableCellId")
    }
    
    // Get Cell Count
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    // Populate table items
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: EventTableCell = self.tableView.dequeueReusableCellWithIdentifier("eventTableCellId") as! EventTableCell
        cell.label.text = self.events[indexPath.row]["name"] as? String
        
        // find out if this event was flagged by this user already
        if let eventFlags: NSDictionary = self.events[indexPath.row]["flags"] as? NSDictionary {
            // _ is a flagId that not being used (XCode was complaining)
            for (_, flag) in eventFlags {
                if let fbId = flag["fbId"] as? String {
                    if (fbId == PFUser.currentUser()!["fbId"] as! String) {
                        cell.flagIcon.image = UIImage(named: "redFlagIcon")
                        cell.isFlagged = true
                        break
                    }
                }
            }
        }
        
        return cell
    }
    
    // Cell Click
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! EventTableCell
        
        let eventViewController = self.storyboard?.instantiateViewControllerWithIdentifier("eventViewController") as! EventViewController
        
        // TODO: replace with the real model
        eventViewController.isFlagged = currentCell.isFlagged
        
        let event: AnyObject = self.events[indexPath.row] as AnyObject
        
        if(event["id"]! != nil) {
            eventViewController.id = event["id"] as! String
        }
        
        if(event["name"]! != nil) {
            eventViewController.name = event["name"] as! String
        }
        
        if(event["startTime"]! != nil) {
            eventViewController.startTime = convertStringToDate(event["startTime"] as! NSString)
        }
        
        if(event["endTime"]! != nil) {
            eventViewController.endTime = convertStringToDate(event["endTime"] as! NSString)
        }
        
        if let location: AnyObject = event["location"] {
            eventViewController.lat = location["lat"] as! Double
            eventViewController.lng = location["lng"] as! Double
        }
        
        if let users: AnyObject = event["users"] {
            eventViewController.users = users as! NSMutableArray
        }
        
        if(event["notes"]! != nil) {
            eventViewController.notes = event["notes"] as! String
        }
        
        self.navigationController?.pushViewController(eventViewController, animated: true)
    }
    
    func convertStringToDate(date: NSString) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        /*find out and place date format from http://userguide.icu-project.org/formatparse/datetime*/
        // println(dateFormatter.dateFromString(date))
        return dateFormatter.dateFromString(date as String)!
    }
    
    
    // Responds to EventsUpdated event from Firebase. (Initial load of the events)
    func updateList(notification: NSNotification) {
        Console.log("Updating events ...")
        self.events = []
        for event in notification.userInfo!{
            // event.0 is an ID of the event. event.1 is actual event data (with id as property)
            self.events.addObject(event.1)
        }
        
        tableView.reloadData()
        
        scheduleNotification()
    }
    
    func eventChanged(notification: NSNotification) {
        // send notification just for testing when the view is loaded
        // println(notification.userInfo!["name"])
        // println(notification.userInfo!["startTime"])
        // scheduleNotification(notification.userInfo!)
        scheduleNotification()
    }
    
    // schedule notification
    func scheduleNotification() {
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = "Testing notifications on iOS8"
        localNotification.alertBody = "New Ancestry event created, please check it out!"
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 3)
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.category = "invite"
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    override func viewWillAppear(animated: Bool) {
        Console.log("MainViewCtrlr")
        self.navigationController?.navigationBarHidden = false
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let isEULAaccepted: Bool = defaults.boolForKey("isEULAaccepted") {
            if(!isEULAaccepted) {
                let modalsStoryboard = UIStoryboard(name: "Modals", bundle: nil)
                let EULAmodal = modalsStoryboard.instantiateViewControllerWithIdentifier("EULAView") as! EULAViewController
                EULAmodal.modalPresentationStyle = UIModalPresentationStyle.FormSheet
                EULAmodal.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                EULAmodal.delegate = self
                self.presentViewController(EULAmodal, animated: true, completion: nil)
            }
        }
    }
    
    func isEULAaccepted(isAccepted: Bool) {
        if(isAccepted) {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isEULAaccepted")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        Singleton.sharedInstance.eventLocation  = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

