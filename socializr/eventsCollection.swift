//
//  eventsCollection.swift
//  socializr
//
//  Created by Bob Dowling on 2/26/15.
//  Copyright (c) 2015 Max Saienko. All rights reserved.
//

import Foundation

var firebase = Firebase(url: "http://socializr.firebaseio.com/events")

class EventsCollection {
    
    init() {
        firebase.observeEventType(.Value, withBlock: {
            snapshot in
            println(snapshot.value)
            var events = snapshot.value as NSDictionary
            NSNotificationCenter.defaultCenter().postNotificationName("EventsUpdated", object: self, userInfo: events)
        })
    }
}
