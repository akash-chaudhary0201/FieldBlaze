//
//  CreateLeaveVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 18/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import DropDown
import SwiftLoader

class CreateLeaveVC: UIViewController {
    
    @IBOutlet weak var leaveTypeView: UIView!
    @IBOutlet weak var leaveTypeLabel: UILabel!
    var leaveTypeDropDown = DropDown()
    var leaveTypeArray:[String] = ["Paid", "Sick", "Casual", "Short Leave", "EL"]
    
    @IBOutlet weak var startDateView: UIView!
    @IBOutlet weak var startDateLabel: UILabel!
    
    @IBOutlet weak var EndDateView: UIView!
    @IBOutlet weak var endDateLabel: UILabel!
    
    @IBOutlet weak var fullHalfView: UIView!
    @IBOutlet weak var fullHalfLabel: UILabel!
    var fullHalfDropDown = DropDown()
    var halfFullArray:[String] = ["Half Day", "Full Day"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DropDownFunction.setupDropDown(dropDown: leaveTypeDropDown, anchor: leaveTypeView, dataSource: leaveTypeArray, labelToUpdate: leaveTypeLabel)
        
        DropDownFunction.setupDropDown(dropDown: fullHalfDropDown, anchor: fullHalfView, dataSource: halfFullArray, labelToUpdate: fullHalfLabel)
    }
    
    @IBAction func openLeaveTypeDropDown(_ sender: Any) {
        leaveTypeDropDown.show()
    }
    
    @IBAction func openHalfFullDropDown(_ sender: Any) {
        fullHalfDropDown.show()
    }
    
    @IBAction func selectStartDate(_ sender: Any) {
        DatePickerHelper.showInlineDatePicker(centerIn: self.view, targetLabel: startDateLabel, "yyyy-MM-dd")
    }
    
    
    @IBAction func selectEndDate(_ sender: Any) {
        DatePickerHelper.showInlineDatePicker(centerIn: self.view, targetLabel: endDateLabel, "yyyy-MM-dd")
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitLeaveApplication(_ sender: Any) {
        
        SwiftLoaderHelper.setLoader()
        
        if leaveTypeLabel.text == "Leave Type" || startDateLabel.text == "Start Date" || endDateLabel.text == "End Date" || fullHalfLabel.text == "Full Day / Half Day"{
            AlertFunction.showErrorAlert("Please Fill all the details", self)
            SwiftLoader.hide()
        }else{
            let bodyRequest:[String:Any] = [
                "PI_LeaveType__c":leaveTypeLabel.text!,
                "DA_StartDate__c":startDateLabel.text!,
                "DA_End_Date__c":endDateLabel.text!,
                "PI_Full_Day_Half_Day__c":fullHalfLabel.text!
            ]
            
            GlobalPostRequest.commonPostFunction("v63.0/sobjects/Leave__c", bodyRequest) { success, response in
                DispatchQueue.main.async {
                    if success{
                        SwiftLoader.hide()
                        AlertFunction.showAlertAndPop("Leave Submitted Successfully", self)
                    }else{
                        SwiftLoader.hide()
                        AlertFunction.showErrorAlert("\(response ?? "A")", self)
                    }
                }
            }
        }
    }
    
}
