//
//  CreateTaskVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 03/06/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import DropDown
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import SwiftLoader

class CreateTaskVC: UIViewController {
    
    var obj = TaskServices()
    
    @IBOutlet weak var taskTitle: MDCOutlinedTextField!
    @IBOutlet weak var taskDescription: MDCOutlinedTextArea!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var priorityView: UIView!
    @IBOutlet weak var priorityLabel: UILabel!
    
    var priorties:[String] = ["High","Normal","Low"]
    
    var priorityDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetTextFields.setTextField(taskTitle, "Add Task Title")
        
        taskDescription.label.text = "Write the task's description"
        taskDescription?.setOutlineColor(UIColor(red: 78.0 / 255.0, green: 78.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), for: .normal)
        taskDescription?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        taskDescription?.setNormalLabel(UIColor.gray, for: .normal)
        taskDescription?.setFloatingLabel(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        taskDescription.translatesAutoresizingMaskIntoConstraints = false
        
        //Calling dropdown function:
        DropDownFunction.setupDropDown(dropDown: priorityDropDown, anchor: priorityView, dataSource: priorties, labelToUpdate: priorityLabel)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func openPriorityDropDown(_ sender: Any) {
        priorityDropDown.show()
    }
    
    //Button's function to add new task:
    @IBAction func addNewTaskAction(_ sender: Any) {
        
        if taskTitle.text == "" || priorityLabel.text == "" || taskDescription.textView.text == ""{
            AlertFunction.showErrorAlert("Please fill all the details", self)
        }
        
        SwiftLoaderHelper.setLoader()
        
        let requestBody: [String: Any] = [
            "Subject": taskTitle.text!,
            "Priority": priorityLabel.text!,
            "Description":taskDescription.textView.text!
        ]
        
        GlobalPostRequest.commonPostFunction("v63.0/sobjects/Task", requestBody) { success, response in
            DispatchQueue.main.async {
                SwiftLoader.hide()
                if success {
                    AlertFunction.showAlertAndPop("Task Addedd Successfully", self)
                } else {
                    AlertFunction.showErrorAlert("Error in Adding Task", self)
                }
            }
        }
        
    }
}
