//
//  AddContactVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 10/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import DropDown
import SwiftLoader

class AddContactVC: UIViewController {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstNameTextField: MDCOutlinedTextField!
    @IBOutlet weak var lastNameTextField: MDCOutlinedTextField!
    @IBOutlet weak var roleTextField: MDCOutlinedTextField!
    @IBOutlet weak var phoneTextField: MDCOutlinedTextField!
    @IBOutlet weak var emailTextField: MDCOutlinedTextField!
    
    var isComingFromCustomers:Bool = false
    
    var titleArray:[String] = ["Mr.", "Mrs.", "Ms.", "Dr.", "Prof.", "Mx."]
    
    var titleDropDown = DropDown()
    
    var accountId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DropDownFunction.setupDropDown(dropDown: titleDropDown, anchor: titleView, dataSource: titleArray, labelToUpdate: titleLabel)
        
        setUpUI()
    }
    
    //Function to setup UI:
    func setUpUI(){
        SetTextFields.setTextField(firstNameTextField!, "First Name")
        SetTextFields.setTextField(lastNameTextField!, "Last Name")
        SetTextFields.setTextField(roleTextField!, "Role")
        SetTextFields.setTextField(phoneTextField!, "Phone Number")
        SetTextFields.setTextField(emailTextField!, "Email")
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func openTitleDropDown(_ sender: Any) {
        titleDropDown.show()
    }
    
    
    @IBAction func addContactAction(_ sender: Any) {
        
        SwiftLoaderHelper.setLoader()
        
        if titleLabel.text == "Tile" || firstNameTextField.text == "" || lastNameTextField.text == "" || phoneTextField.text == "" || emailTextField.text == "" || roleTextField.text == ""{
            
            DispatchQueue.main.async {
                AlertFunction.showErrorAlert("Please enter all values", self)
                SwiftLoader.hide()
            }
        }
        
        if isComingFromCustomers{
            let requestBody:[String:Any] = [
                "Salutation": titleLabel.text ?? "",
                "FirstName": firstNameTextField.text ?? "",
                "LastName": lastNameTextField.text!,
                "Phone": phoneTextField.text ?? "",
                "Email": emailTextField.text ?? "",
                "Department": roleTextField.text ?? "",
                "AccountId": accountId!,
                "OwnerId": Defaults.userId!
            ]
            
            GlobalPostRequestEx.commonPostFunctionEx("v63.0/sobjects/Contact", requestBody) { success, statusCode, response in
                DispatchQueue.main.async {
                    if success{
                        AlertFunction.showAlertAndPop("Contact Added Successfully", self)
                        SwiftLoader.hide()
                    }else {
                        if let errorArray = response as? [[String: Any]],
                           let message = errorArray.first?["message"] as? String {
                            AlertFunction.showErrorAlert("\(message)", self)
                            SwiftLoader.hide()
                        } else {
                            print("API Failed with unknown error")
                            SwiftLoader.hide()
                        }
                    }
                }
            }
            
        }else{
            AlertFunction.showErrorAlert("Use Database", self)
        }
    }
    
}
