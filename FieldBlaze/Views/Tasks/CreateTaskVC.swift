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
        
        taskTitle?.label.text = "Add Task Title"
        taskTitle?.setOutlineColor(UIColor(red: 78.0 / 255.0, green: 78.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), for: .normal)
        taskTitle?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        taskTitle?.setNormalLabelColor(UIColor.gray, for: .normal)
        taskTitle?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        
        taskDescription.label.text = "Write the task's description"
        //        taskDescription.placeholder = "Enter Your Remarks"
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
        
        var config = SwiftLoader.Config()
        config.size = 100
        config.spinnerColor = .blue
        config.foregroundColor = .black
        config.foregroundAlpha = 0
        SwiftLoader.setConfig(config: config)
        SwiftLoader.show(title: "Adding...", animated: true)
        
        self.obj.createNewTask(taskTitle.text!, priorityLabel.text!, taskDescription.textView.text!) { status in
            DispatchQueue.main.async {
                SwiftLoader.hide()
                if status {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    let alert = UIAlertController(title: "Error", message: "Task creation failed.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
        
    }
}
