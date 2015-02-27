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
        firebase.observeEventType(.Value, withBlock: {
            snapshot in
            var events = snapshot.value as NSDictionary
            NSNotificationCenter.defaultCenter().postNotificationName("EventsUpdated", object: self, userInfo: events)
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
}
