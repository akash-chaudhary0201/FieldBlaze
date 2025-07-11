//
//  CreateCustomerVC.swift
//  FieldBlaze
//
//  Created by Sakshi on 14/04/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class CreateCustomerVC: UIViewController {
    @IBOutlet var accountnameTxtFld: MDCOutlinedTextField?
    @IBOutlet var parentAccountIdTxtFld: MDCOutlinedTextField?
    @IBOutlet var mobileNoTxtFld: MDCOutlinedTextField?
    @IBOutlet var accountTypeTxtFld: MDCOutlinedTextField?
    @IBOutlet var whatsappNumberTxtFld: MDCOutlinedTextField?
    @IBOutlet var firstNameTxtFld: MDCOutlinedTextField?
    @IBOutlet var LastNameTxtFld: MDCOutlinedTextField?
    @IBOutlet var PANTxtFld: MDCOutlinedTextField?
    @IBOutlet var GSTTxtFld: MDCOutlinedTextField?
    @IBOutlet var paymentTermsTxtFld: MDCOutlinedTextField?
    @IBOutlet var priceBookTxtFld: MDCOutlinedTextField?
    @IBOutlet var zoneTxtFld: MDCOutlinedTextField?
    @IBOutlet var billingStreetTxtFld: MDCOutlinedTextField?
    @IBOutlet var billingCityTxtFld: MDCOutlinedTextField?
    @IBOutlet var billingZipCodeTxtFld: MDCOutlinedTextField?
    @IBOutlet var billingStateTxtFld: MDCOutlinedTextField?
    @IBOutlet var billingCountryTxtFld: MDCOutlinedTextField?
    @IBOutlet var shippingStreetTxtFld: MDCOutlinedTextField?
    @IBOutlet var shippingcityTxtFld: MDCOutlinedTextField?
    @IBOutlet var shippingZipCodeTxtFld: MDCOutlinedTextField?
    @IBOutlet var shippingStateTxtFld: MDCOutlinedTextField?
    @IBOutlet var shippingCountryTxtFld: MDCOutlinedTextField?
    @IBOutlet var descriptionTxtFld: MDCOutlinedTextField?
    @IBOutlet var isActiveBtn: UIButton?
    @IBOutlet var isPrimaryBtn: UIButton?
    @IBOutlet var isSameAsBillingBtn: UIButton?
    @IBOutlet var submitBtn: UIButton?
    
    var isActiveYes: Bool = false
    var isPrimaryYes: Bool = false
    var isSameAsBillingYes: Bool = false
    
    var isActive: Bool = false {
        didSet {
            if isActive {
                isActiveYes = true
                isActiveBtn?.setImage(UIImage(named: "addcheck"), for: UIControl.State.normal)
            } else {
                isActiveYes = false
                isActiveBtn?.setImage(UIImage(named: "uncheck"), for: UIControl.State.normal)
            }
        }
    }
    
    var isPrimary: Bool = false {
        didSet {
            if isPrimary {
                isPrimaryYes = true
                isPrimaryBtn?.setImage(UIImage(named: "addcheck"), for: UIControl.State.normal)
            } else {
                isPrimaryYes = false
                isPrimaryBtn?.setImage(UIImage(named: "uncheck"), for: UIControl.State.normal)
            }
        }
    }
    
    var isSameAsBilling: Bool = false {
        didSet {
            if isSameAsBilling {
                isSameAsBillingYes = true
                isSameAsBillingBtn?.setImage(UIImage(named: "addcheck"), for: UIControl.State.normal)
            } else {
                isSameAsBillingYes = false
                isSameAsBillingBtn?.setImage(UIImage(named: "uncheck"), for: UIControl.State.normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureToDismissKeyboard()
        setupUI()
    }
    
    func setupUI() {
        submitBtn?.layer.cornerRadius = 25.0
        submitBtn?.layer.masksToBounds = true
        
        accountnameTxtFld?.label.text = "Account Name"
        accountnameTxtFld?.setOutlineColor(UIColor(red: 78.0 / 255.0, green: 78.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), for: .normal)
        accountnameTxtFld?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        accountnameTxtFld?.setNormalLabelColor(UIColor.gray, for: .normal)
        accountnameTxtFld?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        accountnameTxtFld?.setLeadingAssistiveLabelColor(UIColor.systemGray, for: .normal)
        
        parentAccountIdTxtFld?.label.text = "Parent Account ID"
        parentAccountIdTxtFld?.setOutlineColor(UIColor(red: 78.0 / 255.0, green: 78.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), for: .normal)
        parentAccountIdTxtFld?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        parentAccountIdTxtFld?.setNormalLabelColor(UIColor.gray, for: .normal)
        parentAccountIdTxtFld?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        parentAccountIdTxtFld?.setLeadingAssistiveLabelColor(UIColor.systemGray, for: .normal)
        
        mobileNoTxtFld?.label.text = "Mobile"
        mobileNoTxtFld?.setOutlineColor(UIColor(red: 78.0 / 255.0, green: 78.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), for: .normal)
        mobileNoTxtFld?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        mobileNoTxtFld?.setNormalLabelColor(UIColor.gray, for: .normal)
        mobileNoTxtFld?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        mobileNoTxtFld?.setLeadingAssistiveLabelColor(UIColor.systemGray, for: .normal)
        
        accountTypeTxtFld?.label.text = "Account Type"
        accountTypeTxtFld?.setOutlineColor(UIColor(red: 78.0 / 255.0, green: 78.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), for: .normal)
        accountTypeTxtFld?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        accountTypeTxtFld?.setNormalLabelColor(UIColor.gray, for: .normal)
        accountTypeTxtFld?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        accountTypeTxtFld?.setLeadingAssistiveLabelColor(UIColor.systemGray, for: .normal)
        
        whatsappNumberTxtFld?.label.text = "WhatsApp Number"
        whatsappNumberTxtFld?.setOutlineColor(UIColor(red: 78.0 / 255.0, green: 78.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), for: .normal)
        whatsappNumberTxtFld?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        whatsappNumberTxtFld?.setNormalLabelColor(UIColor.gray, for: .normal)
        whatsappNumberTxtFld?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        whatsappNumberTxtFld?.setLeadingAssistiveLabelColor(UIColor.systemGray, for: .normal)
        
        firstNameTxtFld?.label.text = "First Name"
        firstNameTxtFld?.setOutlineColor(UIColor(red: 78.0 / 255.0, green: 78.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), for: .normal)
        firstNameTxtFld?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        firstNameTxtFld?.setNormalLabelColor(UIColor.gray, for: .normal)
        firstNameTxtFld?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        firstNameTxtFld?.setLeadingAssistiveLabelColor(UIColor.systemGray, for: .normal)
        
        LastNameTxtFld?.label.text = "Last Name"
        LastNameTxtFld?.setOutlineColor(UIColor(red: 78.0 / 255.0, green: 78.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), for: .normal)
        LastNameTxtFld?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        LastNameTxtFld?.setNormalLabelColor(UIColor.gray, for: .normal)
        LastNameTxtFld?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        LastNameTxtFld?.setLeadingAssistiveLabelColor(UIColor.systemGray, for: .normal)
        
        PANTxtFld?.label.text = "PAN(ABCDE1234F)"
        PANTxtFld?.setOutlineColor(UIColor(red: 78.0 / 255.0, green: 78.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), for: .normal)
        PANTxtFld?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        PANTxtFld?.setNormalLabelColor(UIColor.gray, for: .normal)
        PANTxtFld?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        PANTxtFld?.setLeadingAssistiveLabelColor(UIColor.systemGray, for: .normal)
        
        GSTTxtFld?.label.text = "GST(07ABCDE1234F1Z1)"
        GSTTxtFld?.setOutlineColor(UIColor(red: 78.0 / 255.0, green: 78.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), for: .normal)
        GSTTxtFld?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        GSTTxtFld?.setNormalLabelColor(UIColor.gray, for: .normal)
        GSTTxtFld?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        GSTTxtFld?.setLeadingAssistiveLabelColor(UIColor.systemGray, for: .normal)
        
        paymentTermsTxtFld?.label.text = "Payment Terms"
        paymentTermsTxtFld?.setOutlineColor(UIColor(red: 78.0 / 255.0, green: 78.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), for: .normal)
        paymentTermsTxtFld?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        paymentTermsTxtFld?.setNormalLabelColor(UIColor.gray, for: .normal)
        paymentTermsTxtFld?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        
        priceBookTxtFld?.label.text = "Price Book"
        priceBookTxtFld?.setOutlineColor(UIColor(red: 78.0 / 255.0, green: 78.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), for: .normal)
        priceBookTxtFld?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        priceBookTxtFld?.setNormalLabelColor(UIColor.gray, for: .normal)
        priceBookTxtFld?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        
        zoneTxtFld?.label.text = "Zone"
        zoneTxtFld?.setOutlineColor(UIColor(red: 78.0 / 255.0, green: 78.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), for: .normal)
        zoneTxtFld?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        zoneTxtFld?.setNormalLabelColor(UIColor.gray, for: .normal)
        zoneTxtFld?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        
        billingStreetTxtFld?.label.text = "Billing Street"
        billingStreetTxtFld?.setOutlineColor(UIColor(red: 78.0 / 255.0, green: 78.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), for: .normal)
        billingStreetTxtFld?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        billingStreetTxtFld?.setNormalLabelColor(UIColor.gray, for: .normal)
        billingStreetTxtFld?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        
        billingCityTxtFld?.label.text = "Billing City"
        billingCityTxtFld?.setOutlineColor(UIColor(red: 78.0 / 255.0, green: 78.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), for: .normal)
        billingCityTxtFld?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        billingCityTxtFld?.setNormalLabelColor(UIColor.gray, for: .normal)
        billingCityTxtFld?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        
        billingZipCodeTxtFld?.label.text = "Billing Zip/Postal Code"
        billingZipCodeTxtFld?.setOutlineColor(UIColor(red: 78.0 / 255.0, green: 78.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), for: .normal)
        billingZipCodeTxtFld?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        billingZipCodeTxtFld?.setNormalLabelColor(UIColor.gray, for: .normal)
        billingZipCodeTxtFld?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        
        billingStateTxtFld?.label.text = "Billing State/Province"
        billingStateTxtFld?.setOutlineColor(UIColor(red: 78.0 / 255.0, green: 78.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), for: .normal)
        billingStateTxtFld?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        billingStateTxtFld?.setNormalLabelColor(UIColor.gray, for: .normal)
        billingStateTxtFld?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        
        billingCountryTxtFld?.label.text = "Billing Country"
        billingCountryTxtFld?.setOutlineColor(UIColor(red: 78.0 / 255.0, green: 78.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), for: .normal)
        billingCountryTxtFld?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        billingCountryTxtFld?.setNormalLabelColor(UIColor.gray, for: .normal)
        billingCountryTxtFld?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        
        shippingStreetTxtFld?.label.text = "Shipping Street"
        shippingStreetTxtFld?.setOutlineColor(UIColor(red: 78.0 / 255.0, green: 78.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), for: .normal)
        shippingStreetTxtFld?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        shippingStreetTxtFld?.setNormalLabelColor(UIColor.gray, for: .normal)
        shippingStreetTxtFld?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        
        shippingcityTxtFld?.label.text = "Shipping City"
        shippingcityTxtFld?.setOutlineColor(UIColor(red: 78.0 / 255.0, green: 78.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), for: .normal)
        shippingcityTxtFld?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        shippingcityTxtFld?.setNormalLabelColor(UIColor.gray, for: .normal)
        shippingcityTxtFld?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        
        shippingZipCodeTxtFld?.label.text = "Shipping Zip/Postal Code"
        shippingZipCodeTxtFld?.setOutlineColor(UIColor(red: 78.0 / 255.0, green: 78.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), for: .normal)
        shippingZipCodeTxtFld?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        shippingZipCodeTxtFld?.setNormalLabelColor(UIColor.gray, for: .normal)
        shippingZipCodeTxtFld?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        
        shippingStateTxtFld?.label.text = "Shipping State/Province"
        shippingStateTxtFld?.setOutlineColor(UIColor(red: 78.0 / 255.0, green: 78.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), for: .normal)
        shippingStateTxtFld?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        shippingStateTxtFld?.setNormalLabelColor(UIColor.gray, for: .normal)
        shippingStateTxtFld?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        
        shippingCountryTxtFld?.label.text = "Shipping Country"
        shippingCountryTxtFld?.setOutlineColor(UIColor(red: 78.0 / 255.0, green: 78.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), for: .normal)
        shippingCountryTxtFld?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        shippingCountryTxtFld?.setNormalLabelColor(UIColor.gray, for: .normal)
        shippingCountryTxtFld?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        
        descriptionTxtFld?.label.text = "Account Description"
        descriptionTxtFld?.setOutlineColor(UIColor(red: 78.0 / 255.0, green: 78.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), for: .normal)
        descriptionTxtFld?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        descriptionTxtFld?.setNormalLabelColor(UIColor.gray, for: .normal)
        descriptionTxtFld?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
    }
    
    func addTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func activeAction(_ sender: UIButton) {
        isActive = !isActive
    }
    
    @IBAction func primaryAction(_ sender: UIButton) {
        isPrimary = !isPrimary
    }
    
    @IBAction func sameAsBilingAction(_ sender: UIButton) {
        isSameAsBilling = !isSameAsBilling
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitAction() {
    }

}
