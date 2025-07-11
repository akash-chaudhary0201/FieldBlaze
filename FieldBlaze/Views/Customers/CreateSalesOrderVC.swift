//
//  CreateSalesOrderVC.swift
//  FieldBlaze
//
//  Created by Sakshi on 15/04/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class CreateSalesOrderVC: UIViewController {
    
    @IBOutlet var searchCustomerTxtFld: MDCOutlinedTextField?
    @IBOutlet var orderDateTxtFld: MDCOutlinedTextField?
    @IBOutlet var deliveryDateTxtFld: MDCOutlinedTextField?
    @IBOutlet var priceBookTxtFld: MDCOutlinedTextField?
    
    @IBOutlet var addBtn: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI() {
        addBtn?.layer.cornerRadius = 24.0
        addBtn?.layer.masksToBounds = true
        
        searchCustomerTxtFld?.label.text = "Search Customer *"
        searchCustomerTxtFld?.setOutlineColor(UIColor(red: 78.0 / 255.0, green: 78.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), for: .normal)
        searchCustomerTxtFld?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        searchCustomerTxtFld?.setNormalLabelColor(UIColor.gray, for: .normal)
        searchCustomerTxtFld?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        searchCustomerTxtFld?.setLeadingAssistiveLabelColor(UIColor.systemGray, for: .normal)
        
        orderDateTxtFld?.label.text = "Order Date *"
        orderDateTxtFld?.setOutlineColor(UIColor(red: 78.0 / 255.0, green: 78.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), for: .normal)
        orderDateTxtFld?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        orderDateTxtFld?.setNormalLabelColor(UIColor.gray, for: .normal)
        orderDateTxtFld?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        orderDateTxtFld?.setLeadingAssistiveLabelColor(UIColor.systemGray, for: .normal)
        
        deliveryDateTxtFld?.label.text = "Delivery Date *"
        deliveryDateTxtFld?.setOutlineColor(UIColor(red: 78.0 / 255.0, green: 78.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), for: .normal)
        deliveryDateTxtFld?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        deliveryDateTxtFld?.setNormalLabelColor(UIColor.gray, for: .normal)
        deliveryDateTxtFld?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        deliveryDateTxtFld?.setLeadingAssistiveLabelColor(UIColor.systemGray, for: .normal)
        
        priceBookTxtFld?.label.text = "Pricebook *"
        priceBookTxtFld?.setOutlineColor(UIColor(red: 78.0 / 255.0, green: 78.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), for: .normal)
        priceBookTxtFld?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        priceBookTxtFld?.setNormalLabelColor(UIColor.gray, for: .normal)
        priceBookTxtFld?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        priceBookTxtFld?.setLeadingAssistiveLabelColor(UIColor.systemGray, for: .normal)
        
    }

}
