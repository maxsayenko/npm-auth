//
//  eventsCollection.swift
//  socializr
//
//  Created by Bob Dowling on 2/26/15.
//  Copyright (c) 2015 Max Saienko. All rights reserved.
//

import Foundation

var firebaseUrl = "http://socializr.firebaseio.com/events"
var firebase = Firebase(url: firebaseUrl)
//var firebase = Firebase(url: "https://docs-examples.firebaseio.com/web/saving-data/fireblog/posts")

class EventsCollection {
    
    init() {
        firebase.observeEventType(.Value, withBlock: { snapshot in
            var events = snapshot.value as NSDictionary
            NSNotificationCenter.defaultCenter().postNotificationName("EventsUpdated", object: self, userInfo: events)
        })
        
        firebase.observeEventType(.ChildAdded, withBlock: { snapshot in
            var events = snapshot.value as NSDictionary
            NSNotificationCenter.defaultCenter().postNotificationName("EventAdded", object: self, userInfo: events)
        })
        
        // Get the data on a post that has changed
        firebase.observeEventType(.ChildChanged, withBlock: { snapshot in
            var events = snapshot.value as NSDictionary
            NSNotificationCenter.defaultCenter().postNotificationName("EventChanged", object: self, userInfo: events)
        })
    }
    
    func fetchLunchRouletteEvents() {
        firebase.queryOrderedByChild("type").queryStartingAtValue("lunchRoulette")
            .observeEventType(.Value, withBlock: {
                snapshot in
                var events = snapshot.value as NSDictionary
                NSNotificationCenter.defaultCenter().postNotificationName("GetRouletteEvents", object: self, userInfo: events)
            })
    }
    
    func addUserToEvent(event: NSDictionary) {
//        var users:NSMutableArray = event["users"] as NSMutableArray
//        var eventId = event["id"] as NSString;
//        var eventRef = Firebase(url: firebaseUrl + "/" + eventId + "/users")
//        
//        println(event["users"])
//        eventRef.setValue(users)
    }
    
}
