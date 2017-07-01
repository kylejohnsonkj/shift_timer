//
//  InputShiftViewController.swift
//  Shift Timer
//
//  Created by Kyle Johnson on 6/30/16.
//  Copyright © 2016 Kyle Johnson. All rights reserved.
//

import UIKit

var startTimeDate: Date!
var endTimeDate: Date!
var startTimeText: String!
var endTimeText: String!

class InputShiftViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var activeTextFieldTag = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTimeTextField.delegate = self
        endTimeTextField.delegate = self
        
        errorLabel.isHidden = true
        
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        
        resetDates()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideDatePicker()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let datePicker = UIDatePicker()
        activeTextFieldTag = textField.tag
        
        if startTimeDate != nil && activeTextFieldTag == 1 {
            datePicker.setDate(startTimeDate, animated: true)
        } else if endTimeDate != nil && activeTextFieldTag == 2 {
            datePicker.setDate(endTimeDate, animated: true)
        }
        
        textField.inputView = datePicker
        datePicker.datePickerMode = .time
        datePicker.addTarget(self, action: #selector(InputShiftViewController.timeSelected(_:)), for: .valueChanged)
    }
    
    @IBAction func setBtnTapped(_ sender: AnyObject) {
        if startTimeDate != nil && endTimeDate != nil && errorLabel.isHidden == true {
            self.performSegue(withIdentifier: "Set", sender: self)
        } else {
            if startTimeDate == nil {
                errorLabel.text = "Error: start time cannot be blank!"
            } else if endTimeDate == nil {
                errorLabel.text = "Error: end time cannot be blank!"
            }
            errorLabel.isHidden = false
        }
    }
    
    @IBAction func resetBtnTapped(_ sender: AnyObject) {
        resetDates()
        hideDatePicker()
    }
    
    func hideDatePicker() {
        self.view.endEditing(true)
    }
    
    func resetDates() {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "h:mm aa"
        
        errorLabel.isHidden = true
        startTimeDate = Date()
        
        let dateWithZeroSeconds: TimeInterval = floor(startTimeDate.timeIntervalSinceReferenceDate / 60.0) * 60.0
        startTimeDate = Date(timeIntervalSinceReferenceDate: dateWithZeroSeconds)
        startTimeTextField.text = dateFormatter.string(from: startTimeDate)
        startTimeText = startTimeTextField.text
        endTimeDate = nil
        endTimeTextField.text = ""
        endTimeText = endTimeTextField.text
    }
    
    func timeSelected(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        
        if let textField = self.view.viewWithTag(activeTextFieldTag) as? UITextField {
            let dateWithZeroSeconds: TimeInterval = floor(sender.date.timeIntervalSinceReferenceDate / 60.0) * 60.0
            let date: Date = Date(timeIntervalSinceReferenceDate: dateWithZeroSeconds)
            
            dateFormatter.dateFormat = "h:mm aa"
            textField.text = dateFormatter.string(from: date)
            
            if activeTextFieldTag == 1 {
                startTimeDate = date
                startTimeTextField.text = dateFormatter.string(from: date)
                startTimeText = startTimeTextField.text
            } else if activeTextFieldTag == 2 {
                endTimeDate = date
                endTimeTextField.text = dateFormatter.string(from: date)
                endTimeText = endTimeTextField.text
            }
            
            if startTimeDate != nil && endTimeDate != nil {
                let difference = endTimeDate.timeIntervalSince(startTimeDate)
                if difference < 0 {
                    errorLabel.text = "Error: end time cannot come before start time!"
                    errorLabel.isHidden = false
                } else if difference == 0 {
                    errorLabel.text = "Error: end time cannot be equal to start time!"
                    errorLabel.isHidden = false
                } else {
                    errorLabel.isHidden = true
                }
            }
        }
    }
}

