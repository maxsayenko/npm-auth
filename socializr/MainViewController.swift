//
//  ViewController.swift
//  socializr
//
//  Created by Max Saienko on 2/26/15.
//  Copyright (c) 2015 Max Saienko. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class MainViewController: UIViewController, UITableViewDelegate {
    var eventsCollection: EventsCollection! = EventsCollection()
    var events: NSMutableArray = NSMutableArray()
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateList:", name: "EventsUpdated", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "eventChanged:", name: "EventChanged", object: nil)

        // Regestering custom table cell
        let nib = UINib(nibName: "eventTableCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "eventTableCellId")
    }
    
    // Get Cell Count
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    // Populate table items
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:eventTableCellClass = self.tableView.dequeueReusableCellWithIdentifier("eventTableCellId") as! eventTableCellClass
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
        //CODE TO BE RUN ON CELL TOUCH
        let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! eventTableCellClass
        
        let eventViewController = self.storyboard?.instantiateViewControllerWithIdentifier("eventView") as! EventViewController

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
        Console.log("Updating events ..")
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
    
    func joinLunchRoulette() {
        rouletteEvents = NSMutableArray()
        eventsCollection.fetchLunchRouletteEvents()
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "parseRouletteEvents:", name: "GetRouletteEvents", object: nil)
    }
    
    func parseRouletteEvents(notification: NSNotification) {
        for e in notification.userInfo! {
            let users:NSMutableArray = e.1["users"] as! NSMutableArray
            if (users.count < 5) {
                self.rouletteEvents.addObject(e.1)
            }
        }
        addUserToEvent()
    }
    
    func addUserToEvent() {
        let index = randomInt(0, max: self.rouletteEvents.count)
        let event:NSDictionary = self.rouletteEvents[index] as! NSDictionary
        eventsCollection.addUserToEvent(event["id"] as! String)
    }
    
    func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    override func viewWillAppear(animated: Bool) {
        Console.log("MainViewCtrlr")
        self.navigationController?.navigationBarHidden = false
    }
    
    
    override func viewDidAppear(animated: Bool) {
        Console.log("MainViewCtrlrDid")
        Singleton.sharedInstance.eventLocation  = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

