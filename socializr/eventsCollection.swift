//
//  eventsCollection.swift
//  socializr
//
//  Created by Bob Dowling on 2/26/15.
//  Copyright (c) 2015 Max Saienko. All rights reserved.
//

import Foundation

var firebase = Firebase(url: "http://socializr.firebaseio.com/events")
//var firebase = Firebase(url: "https://docs-examples.firebaseio.com/web/saving-data/fireblog/posts")

class EventsCollection {
    
    init() {
        Console.log("Initing... ")
        firebase.observeEventType(.Value, withBlock: { snapshot in
            var events = snapshot.value as! NSDictionary
            Console.log("EventsUpdated")
            NSNotificationCenter.defaultCenter().postNotificationName("EventsUpdated", object: self, userInfo: events as [NSObject : AnyObject])
        })
        
        // Get the data on a post that has changed
        firebase.observeEventType(.ChildChanged, withBlock: { snapshot in
            var events = snapshot.value as! NSDictionary
            Console.log("EventChanged")
            NSNotificationCenter.defaultCenter().postNotificationName("EventChanged", object: self, userInfo: events as [NSObject : AnyObject])
        })
    }
    
    func fetchLunchRouletteEvents() {
        firebase.queryOrderedByChild("type").queryStartingAtValue("lunchRoulette")
            .observeEventType(.Value, withBlock: {
                snapshot in
                var events = snapshot.value as! NSDictionary
                NSNotificationCenter.defaultCenter().postNotificationName("GetRouletteEvents", object: self, userInfo: events as [NSObject : AnyObject])
            })
    }
    
    static func flagEvent(eventId: String) {
        let eventFlagsRef = firebase.childByAppendingPath(eventId + "/flags")
        let newFlagRef = eventFlagsRef.childByAutoId()
        let userCreatingFlag = ["fbId": PFUser.currentUser()!["fbId"] as! String, "name": PFUser.currentUser()!.username! as String]
        
        newFlagRef.setValue(userCreatingFlag)
    }
    
    func addUserToEvent(eventId: String) {
        Console.log(eventId)
    }
}
