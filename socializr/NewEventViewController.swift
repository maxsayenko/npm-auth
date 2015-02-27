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

    var startDatePickerView : UIDatePicker = UIDatePicker()
    var endDatePickerView : UIDatePicker = UIDatePicker()

    @IBOutlet var viewControl: UIControl!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var endDateTxt: UITextField!
    @IBOutlet var startDateTxt: UITextField!

    @IBAction func addButtonClick(sender: UIBarButtonItem) {
        
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
    }
    
    func handelEndDatePicker(datePicker:UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        var strDate = dateFormatter.stringFromDate(datePicker.date)
        endDateTxt.text =  strDate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true;
    }

}
