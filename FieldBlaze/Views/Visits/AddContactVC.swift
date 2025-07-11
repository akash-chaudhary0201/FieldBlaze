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

//9058984009

class AddContactVC: UIViewController {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstNameTextField: MDCOutlinedTextField!
    @IBOutlet weak var lastNameTextField: MDCOutlinedTextField!
    @IBOutlet weak var roleTextField: MDCOutlinedTextField!
    @IBOutlet weak var phoneTextField: MDCOutlinedTextField!
    @IBOutlet weak var emailTextField: MDCOutlinedTextField!
    
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
        
        var fullName = "\(firstNameTextField.text!) \(lastNameTextField.text!)"
        
        let contactDict: [String: Any] = [
            "Id": "",
            "Name": fullName,
            "Email": emailTextField.text ?? "",
            "Phone": phoneTextField.text ?? "",
            "Department": roleTextField.text ?? "",
            "AccountId": accountId!
        ]
        
        let newContact = ContactsModel(dict: contactDict)
        GlobalData.allContacts.append(newContact)
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
