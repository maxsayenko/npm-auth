//
//  NewEventViewController.swift
//  socializr
//
//  Created by Max Saienko on 2/26/15.
//  Copyright (c) 2015 Max Saienko. All rights reserved.
//

import UIKit
import MapKit

class NewEventViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
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
    
    @IBAction func addButtonClick(sender: UIBarButtonItem) -> Void {
        if(titleTxt.text.isEmpty) {
            let alertController = UIAlertController(title: "Missing title", message: "Name of the event is missing", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "Ok", style:UIAlertActionStyle.Default,
                handler: {
                    (alertCtrl: UIAlertAction) -> Void in
            })
            
            alertController.addAction(okAction)
            
            self.presentViewController(alertController, animated: true, completion: {
                () -> Void in
            })

            return
        }

        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var startDateText = dateFormatter.stringFromDate(startDate)
        var endDateText = dateFormatter.stringFromDate(endDate)
        var name = titleTxt.text
        var location: AnyObject = []
        
        if let eventLocation = Singleton.sharedInstance.eventLocation {
            location = ["lat":eventLocation.latitude, "lng": eventLocation.longitude]
        }
        
        // add the event
        var eventData = ["name": name, "startTime": startDateText, "endTime": endDateText, "notes": noteTxtBox.text, "location": location]
        EventsCollection.addNewEvent(eventData)
        
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
        noteTxtBox.delegate = self
        
        startDatePickerView = UIDatePicker()
        startDatePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        startDateTxt.inputView = startDatePickerView
        startDatePickerView.addTarget( self, action: Selector("handelStartDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
        endDatePickerView = UIDatePicker()
        endDatePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        endDateTxt.inputView = endDatePickerView
        endDatePickerView.addTarget( self, action: Selector("handelEndDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
        
        // Placeholder for TextView
        noteTxtBox.text = "Notes"
        noteTxtBox.textColor = UIColor.lightGrayColor()
        
    }
    
    func handelStartDatePicker(datePicker:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let strDate = dateFormatter.stringFromDate(datePicker.date)
        startDateTxt.text =  strDate
        startDate = datePicker.date
    }
    
    func handelEndDatePicker(datePicker:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let strDate = dateFormatter.stringFromDate(datePicker.date)
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
    
    
    // Placeholder for TextView
    func textViewDidBeginEditing(textView: UITextView) {
        if (textView.textColor == UIColor.lightGrayColor()) {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if (textView.text.isEmpty) {
            textView.text = "Notes"
            textView.textColor = UIColor.lightGrayColor()
        }
    }
}
