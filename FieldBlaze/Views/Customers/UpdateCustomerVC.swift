//
//  UpdateCustomerVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 05/08/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import MaterialComponents
import DropDown
import SwiftLoader

class UpdateCustomerVC: UIViewController {
    
    var accountId:String?
    
    //All outlets:
    @IBOutlet weak var accountName: MDCOutlinedTextField!
    @IBOutlet weak var parentAccountId: UIView!
    @IBOutlet weak var mobile: MDCOutlinedTextField!
    @IBOutlet weak var firstName: MDCOutlinedTextField!
    @IBOutlet weak var zone: UIView!
    @IBOutlet weak var lastName: MDCOutlinedTextField!
    @IBOutlet weak var accountType: UIView!
    @IBOutlet weak var paymentTerms: UIView!
    @IBOutlet weak var creditLimit: MDCOutlinedTextField!
    @IBOutlet weak var numberOfEmployees: MDCOutlinedTextField!
    @IBOutlet weak var pan: MDCOutlinedTextField!
    @IBOutlet weak var gst: MDCOutlinedTextField!
    @IBOutlet weak var billingStreet: MDCOutlinedTextField!
    @IBOutlet weak var billingCity: MDCOutlinedTextField!
    @IBOutlet weak var billingZip: MDCOutlinedTextField!
    @IBOutlet weak var billingState: MDCOutlinedTextField!
    @IBOutlet weak var billingCountry: MDCOutlinedTextField!
    @IBOutlet weak var shippingStreet: MDCOutlinedTextField!
    @IBOutlet weak var shippingCity: MDCOutlinedTextField!
    @IBOutlet weak var shippinhZip: MDCOutlinedTextField!
    @IBOutlet weak var shippingState: MDCOutlinedTextField!
    @IBOutlet weak var shippingCountry: MDCOutlinedTextField!
    @IBOutlet weak var shippingStateCode: MDCOutlinedTextField!
    @IBOutlet weak var billingStateCode: MDCOutlinedTextField!
    @IBOutlet weak var shippingGst: MDCOutlinedTextField!
    @IBOutlet weak var billingGst: MDCOutlinedTextField!
    @IBOutlet weak var descriptionTextField: MDCOutlinedTextField!
    
    @IBOutlet weak var sameAsBillingButton: UIButton!
    
    var isSameAsBilling:Bool = true
    
    var parentAccountDropDown = DropDown()
    var selectedParentId:String?
    
    var zoneDropDown = DropDown()
    var selectedZoneId:String?
    var zoneName:[String] = []
    @IBOutlet weak var zoneView: UIView!
    @IBOutlet weak var zoneLabel: UILabel!
    
    var accountTypeDropDown = DropDown()
    var selectedAccountTypeId:String?
    var accountTypeNames:[String] = []
    @IBOutlet weak var accountTypeLabel: UILabel!
    @IBOutlet weak var accountTypeView: UIView!
    
    var paymentTermsDropDown = DropDown()
    var selectedPaymentTermsId:String?
    var paymentTermsNames:[String] = []
    @IBOutlet weak var paymentTermsView: UIView!
    @IBOutlet weak var paymentTermsLabel: UILabel!
    
    var currentCustomer:Customer?

    override func viewDidLoad() {
        super.viewDidLoad()

        let textFields: [MDCOutlinedTextField?] = [
            accountName,
            mobile,
            firstName,
            lastName,
            creditLimit,
            numberOfEmployees,
            pan,
            gst,
            billingStreet,
            billingCity,
            billingZip,
            billingState,
            billingCountry,
            shippingStreet,
            shippingCity,
            shippinhZip,
            shippingState,
            shippingCountry,
            shippingStateCode,
            billingStateCode,
            shippingGst,
            billingGst,
            descriptionTextField
        ]
        
        let textLabels = [
            "Account Name", "Mobile", "First Name", "Last Name", "Credit Limit", "Number of Employees",
            "PAN", "GST", "Billing Street", "Billing City", "Billing Zip", "Billing State", "Billing Country",
            "Shipping Street", "Shipping City", "Shipping Zip", "Shipping State", "Shipping Country",
            "Shipping State Code", "Billing State Code", "Shipping GST", "Billing GST", "Description"
        ]
        
        for (index, field) in textFields.enumerated() {
            SetTextFields.setTextField(field, textLabels[index])
        }
        
        setUpParenDropDown()
        setUpZoneDropDown()
        setUpAccountTypeDropDown()
        setUpPaymentTermsDropDown()
        
        Task{
            await setUpUI()
        }
    }
    
    func setUpUI() async{
        currentCustomer = await CustomerService.getCustomerBasedOnAccountId(accountId!)
        
        accountName.text = currentCustomer?.name
        mobile.text = currentCustomer?.phone
        firstName.text = currentCustomer?.txFirstName
        lastName.text = currentCustomer?.txLastName
        zoneLabel.text = currentCustomer?.reZoneName ?? "Zone"
        accountTypeLabel.text = currentCustomer?.type ?? "Account Type"
        paymentTermsLabel.text = currentCustomer?.piPaymentTerms ?? "Payment Terms"
        pan.text = currentCustomer?.txPAN
        gst.text = currentCustomer?.txGST
        billingStreet.text = currentCustomer?.billingStreet
        billingCity.text = currentCustomer?.billingCity
        billingZip.text = currentCustomer?.billingPostalCode
        billingState.text = currentCustomer?.billingState
        billingCountry.text = currentCustomer?.billingCountry
        shippingStreet.text = currentCustomer?.shippingStreet
        shippingCity.text = currentCustomer?.shippingCity
        shippinhZip.text = currentCustomer?.shippingPostalCode
        shippingState.text = currentCustomer?.shippingState
        shippingCountry.text = currentCustomer?.shippingCountry
        descriptionTextField.text = currentCustomer?.description
    }
    
    //setup account id dropdown:
    func setUpParenDropDown(){
        
    }
    
    //setup zonedrop down:
    func setUpZoneDropDown(){
        Task{
            await CustomerService.getZoneNames()
            self.zoneName = GlobalData.allZones.map{$0.zoneName!}
            
            DropDownFunction.setupDropDown(dropDown: zoneDropDown, anchor: zoneView, dataSource: zoneName, labelToUpdate: zoneLabel)
            
            zoneDropDown.selectionAction = { index, item in
                self.selectedZoneId = GlobalData.allZones[index].zoneId
                self.zoneLabel.text = item
                self.zoneLabel.textColor = .black
                print("----------------\(self.selectedZoneId!)")
            }
            
        }
    }
    
    //account type dropdown:
    func setUpAccountTypeDropDown(){
        
        self.accountTypeNames = GlobalData.accountType.map{$0.accounType!}
        DropDownFunction.setupDropDown(dropDown: accountTypeDropDown, anchor: accountTypeView, dataSource:accountTypeNames , labelToUpdate: accountTypeLabel)
    }
    
    //payment terms dropdown:
    func setUpPaymentTermsDropDown(){
        self.paymentTermsNames = GlobalData.allPaymentTerms.map{$0.paymentTermName}
        DropDownFunction.setupDropDown(dropDown: paymentTermsDropDown, anchor: paymentTermsView, dataSource: paymentTermsNames, labelToUpdate: paymentTermsLabel)
    }
    
    //DropDown Actions:
    @IBAction func zoneDropAction(_ sender: Any) {
        zoneDropDown.show()
    }
    
    @IBAction func parentIdDropAction(_ sender: Any) {
        parentAccountDropDown.show()
    }
    
    @IBAction func accountTypeDropAction(_ sender: Any) {
        //        print(GlobalData.accountType)
        accountTypeDropDown.show()
    }
    
    @IBAction func paymentTermsDropAction(_ sender: Any) {
        //        print(GlobalData.allPaymentTerms)
        paymentTermsDropDown.show()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sameAsBillingAction(_ sender: Any) {
        if isSameAsBilling {
            
            shippingStreet.text = ""
            shippingCity.text = ""
            shippinhZip.text = ""
            shippingState.text = ""
            shippingCountry.text = ""
            sameAsBillingButton.setImage(UIImage(systemName: "square"), for: .normal)
            sameAsBillingButton.tintColor = .black
        } else {
            shippingStreet.text = billingStreet.text
            shippingCity.text = billingCity.text
            shippinhZip.text = billingZip.text
            shippingState.text = billingState.text
            shippingCountry.text = billingCountry.text
            sameAsBillingButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            sameAsBillingButton.tintColor = UIColor(red: 62/255, green: 197/255, blue: 154/255, alpha: 255/255)
        }
        
        isSameAsBilling.toggle()
    }


}
