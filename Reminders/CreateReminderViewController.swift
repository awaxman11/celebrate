//
//  CreateReminderViewController.swift
//  Reminders
//
//  Created by Adam Waxman on 2/6/16.
//  Copyright © 2016 Waxman. All rights reserved.
//

import UIKit
import CoreData

class CreateReminderViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    // Mark: - Properties
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtReminderDate: UITextField!
    
    @IBOutlet weak var txtReminderType: UITextField!
    
    var reminderTypeOptions = ["Birthday", "Anniversary"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        txtReminderType.inputView = pickerView
        txtReminderType.text = "Birthday"

        self.title = "Add Reminder"
        
        let saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "createReminder")
        navigationItem.rightBarButtonItem = saveBarButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dateReminderEditing(sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("dateReminderValueChanged:"), forControlEvents: .ValueChanged)
    }
    
    func dateReminderValueChanged(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        txtReminderDate.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reminderTypeOptions.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return reminderTypeOptions[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtReminderType.text = reminderTypeOptions[row]
    }
    
    // MARK: - Custom Function 
    
    func createReminder() {
        let reminder = NSEntityDescription.insertNewObjectForEntityForName("Reminder", inManagedObjectContext: self.context) as! Reminder
        
        reminder.name = txtName.text
        reminder.reminderType = txtReminderType.text
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M/d/yy"
        if let reminderDate = txtReminderDate.text {
            reminder.reminderDate = dateFormatter.dateFromString(reminderDate)
        }
        
        do {
            try self.context.save()
            navigationController?.popViewControllerAnimated(true)
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
