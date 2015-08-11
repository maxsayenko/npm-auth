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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "eventChanged:", name: "EventChanged", object: nil)
        
//        var permissions = ["public_profile", "email"]
        
//        PFFacebookUtils.logInWithPermissions(permissions, {
//            (user: PFUser!, error: NSError!) -> Void in
//            if let user = user {
//                if (user.isNew) {
//                    println("User signed up and logged in through Facebook!")
//                    println(user)
//                } else {
//                    println("User logged in through Facebook!")
//                    println(user)
//                }
//            } else {
//                println("Uh oh. The user cancelled the Facebook login.")
//            }
//        })
//        
//        var usr:PFUser = PFUser.currentUser()
//
//        println("usr=\(usr) -- \(usr.email) -- \(usr.username)")
        
        
        // Regestering custom table cell
        var nib = UINib(nibName: "eventTableCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "eventTableCellId")
    }
    
    // Get Cell Count
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    // Populate table items
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
//        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
//        cell.textLabel?.text = self.events[indexPath.row]["name"] as? String

        
        
        var cell:eventTableCellClass = self.tableView.dequeueReusableCellWithIdentifier("eventTableCellId") as! eventTableCellClass
        cell.label.text = self.events[indexPath.row]["name"] as? String
        return cell
    }
    
    // Cell Click
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Console.log("tableCellClicked \(indexPath)")
        //println("tableCellClicked \(indexPath)")
        //CODE TO BE RUN ON CELL TOUCH
        let eventViewController = self.storyboard?.instantiateViewControllerWithIdentifier("eventView") as! EventViewController
        
        var event: AnyObject = self.events[indexPath.row] as AnyObject
        
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
        
        var location: AnyObject? = event["location"]
        
        var lat:Double = location?["lat"] as! Double
        var lng:Double = location?["lng"] as! Double
        
        eventViewController.lat = lat
        eventViewController.lng = lng
        
        if(event["users"]! != nil) {
            eventViewController.users = event["users"] as! NSMutableArray
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
    
    func updateList(notification: NSNotification) {
        for e in notification.userInfo!{
            self.events.addObject(e.1)
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
        
        var localNotification:UILocalNotification = UILocalNotification()
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
            var users:NSMutableArray = e.1["users"] as! NSMutableArray
            if (users.count < 5) {
                self.rouletteEvents.addObject(e.1)
            }
        }
        addUserToEvent()
    }
    
    func addUserToEvent() {
        var index = randomInt(0, max: self.rouletteEvents.count)
        var event:NSDictionary = self.rouletteEvents[index] as! NSDictionary
        eventsCollection.addUserToEvent(event["id"] as! String)
    }
    
    func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    override func viewWillAppear(animated: Bool) {
        println("MainViewCtrlr")
        self.navigationController?.navigationBarHidden = false
    }
    
    
    override func viewDidAppear(animated: Bool) {
        println("MainViewCtrlrDid")
        Singleton.sharedInstance.eventLocation  = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

