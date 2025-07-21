//
//  CreateNotesVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 18/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import SwiftLoader

class CreateNotesVC: UIViewController {
    
    @IBOutlet weak var titleTextField: MDCOutlinedTextField!
    @IBOutlet weak var descriptionTextArea: MDCOutlinedTextArea!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SetTextFields.setTextField(titleTextField, "Add Title")
        SetTextFields.setTextAreas(descriptionTextArea, "Write you note here...")
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createNoteAction(_ sender: Any) {
        
        if titleTextField.text == "" || descriptionTextArea.textView.text == ""{
            AlertFunction.showErrorAlert("Please enter Title and Descrition both", self)
        }
        
        SwiftLoaderHelper.setLoader()
        
        let base64Content = descriptionTextArea.textView.text.data(using: .utf8)?.base64EncodedString()
        
        let requestBody:[String:Any] = [
            "Content":base64Content!,
            "Title":titleTextField.text!
        ]
        
        GlobalPostRequest.commonPostFunction("v63.0/sobjects/ContentNote", requestBody) { success, response in
            DispatchQueue.main.async {
                if success{
                    SwiftLoader.hide()
                    AlertFunction.showAlertAndPop("Note created successfully", self)
                }else{
                    SwiftLoader.hide()
                    AlertFunction.showErrorAlert("Error in creating a note", self)
                }
            }
        }

    }
    
}
