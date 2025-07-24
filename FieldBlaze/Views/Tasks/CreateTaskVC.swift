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
        SetTextFields.setTextAreas(taskDescription, "Write the task's description")
        
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
        SwiftLoaderHelper.setLoader()
        
        if taskTitle.text == "" || priorityLabel.text == "" || taskDescription.textView.text == ""{
            SwiftLoader.hide()
            AlertFunction.showErrorAlert("Please fill all the details", self)
        }else{
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
                        print("\(response ?? "a")")
                    } else {
                        AlertFunction.showErrorAlert("Error in Adding Task", self)
                        print("\(response ?? "a")")
                    }
                }
            }
        }
    }
}
