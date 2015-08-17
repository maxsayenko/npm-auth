//
//  NewEventViewController.swift
//  socializr
//
//  Created by Max Saienko on 2/26/15.
//  Copyright (c) 2015 Max Saienko. All rights reserved.
//

import UIKit
import MapKit

class NewEventViewController: UIViewController, UITextFieldDelegate {

    var startDatePickerView: UIDatePicker = UIDatePicker()
    var endDatePickerView: UIDatePicker = UIDatePicker()
    var startDate: NSDate = NSDate()
    var endDate: NSDate = NSDate()
    

    @IBOutlet var viewControl: UIControl!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var endDateTxt: UITextField!
    @IBOutlet var startDateTxt: UITextField!
    @IBOutlet var noteTxtBox: UITextView!
    @IBOutlet var titleTxt: UITextField!

    @IBAction func addButtonClick(sender: UIBarButtonItem) {
        ////var dateFormatter = NSDateFormatter()
        ////date Formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        //var sDate = dateFormatter.dateFromString(startDateTxt.text)
        //var date = dateFormatter.stringFromDate(startDate)
        ////println(startDateTxt.text)
        //println(sDate)
        ////var startDate = startDateTxt.text
        
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var startDateText = dateFormatter.stringFromDate(startDate)
        var endDateText = dateFormatter.stringFromDate(endDate)
        var name = titleTxt.text
        var lnt = Singleton.sharedInstance.eventLocation.latitude
        var lng = Singleton.sharedInstance.eventLocation.longitude
        
        // save to firebase
        var eventId = NSUUID().UUIDString
        var firebaseRef = Firebase(url: "http://socializr.firebaseio.com/events")
        
        var data = ["id": eventId, "name": name, "startTime": startDateText, "endTime": endDateText, "notes": noteTxtBox.text]
        var eventRef = firebaseRef.childByAppendingPath(eventId)

        eventRef.setValue(data)
        eventRef.childByAppendingPath("location").setValue(["lat":lnt, "lng": lng])
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func backgroundTouched(sender: UIControl) {
        viewControl.endEditing(true)
    }

    override func viewDidAppear(animated: Bool) {
        if(Singleton.sharedInstance.eventLocation != nil) {
            locationLabel.text = "Set"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startDateTxt.delegate = self
        endDateTxt.delegate = self
        
        startDatePickerView = UIDatePicker()
        startDatePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        startDateTxt.inputView = startDatePickerView
        startDatePickerView.addTarget( self, action: Selector("handelStartDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
        endDatePickerView = UIDatePicker()
        endDatePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        endDateTxt.inputView = endDatePickerView
        endDatePickerView.addTarget( self, action: Selector("handelEndDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)

    }
    
    func handelStartDatePicker(datePicker:UIDatePicker) {
        var dateFormatter = NSDateFormatter()

        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        var strDate = dateFormatter.stringFromDate(datePicker.date)
        startDateTxt.text =  strDate
        startDate = datePicker.date
    }
    
    func handelEndDatePicker(datePicker:UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        var strDate = dateFormatter.stringFromDate(datePicker.date)
        endDateTxt.text =  strDate
        endDate = datePicker.date
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }

}
