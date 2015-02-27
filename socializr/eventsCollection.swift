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
    var events:NSMutableDictionary = [:]
    
    init() {
        firebase.observeEventType(.Value, withBlock: {
            snapshot in
            
            self.events = snapshot.value as NSMutableDictionary
            for e in self.events {
                println(e)
            }
        })
    }
}
