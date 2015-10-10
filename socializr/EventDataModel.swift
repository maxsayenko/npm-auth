//
//  eventDataModel.swift
//  socializr
//
//  Created by Max Saienko on 10/10/15.
//  Copyright © 2015 Max Saienko. All rights reserved.
//

import Foundation

class EventDataModel {
    var id: String = ""
    var name: String = ""
    var startTime: NSDate = NSDate()
    var endTime: NSDate = NSDate()
    var notes: String = ""
    var location: LocationDataModel = LocationDataModel()
    var users: NSMutableArray = []
    
    init() {
        
    }
    
    static func Map(event: AnyObject) -> EventDataModel {
        let eventDataModel = EventDataModel()

        if let eventId: String = event["id"] as? String {
            eventDataModel.id = eventId
        }
        
        if let eventName: String = event["name"] as? String {
            eventDataModel.name = eventName
        }
        
        if let eventStartTime: String = event["startTime"] as? String {
            eventDataModel.startTime = convertStringToDate(eventStartTime)
        }
        
        if let eventEndTime: String = event["endTime"] as? String {
            eventDataModel.endTime = convertStringToDate(eventEndTime)
        }
        
        if let eventLocation: AnyObject = event["location"] {
            eventDataModel.location.lat = eventLocation["lat"] as! Double
            eventDataModel.location.lng = eventLocation["lng"] as! Double
        }
        
        if let users: AnyObject = event["users"] {
            eventDataModel.users = users as! NSMutableArray
        }
        
        if let eventNotes: String = event["notes"] as? String {
            eventDataModel.notes = eventNotes
        }
        
        return eventDataModel
    }
    
    static func convertStringToDate(date: NSString) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        /*find out and place date format from http://userguide.icu-project.org/formatparse/datetime*/
        // println(dateFormatter.dateFromString(date))
        return dateFormatter.dateFromString(date as String)!
    }
}