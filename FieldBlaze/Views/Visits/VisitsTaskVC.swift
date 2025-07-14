//
//  VisitsTaskVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 14/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import MaterialComponents

class VisitsTaskVC: UIViewController {
    
    
    @IBOutlet weak var taskDescription: MDCOutlinedTextField!
    @IBOutlet weak var taskTitle: MDCOutlinedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SetTextFields.setTextField(taskTitle, "Task Title")
        SetTextFields.setTextField(taskDescription, "Description")
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
