//
//  OrderLineItemVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 14/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import DropDown

class OrderLineItemVC: UIViewController, UITextFieldDelegate {
    
    var actualPrice:String = ""
    
    //All outlets:
    @IBOutlet weak var actualPriceLabel: UITextField!
    @IBOutlet weak var amountAfterDiscount: UILabel!
    @IBOutlet weak var discountAmountTextField: UITextField!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var quantityTextField: UITextField!
    
    var productId:String?
    
    @IBOutlet weak var discountView: UIView!
    var discountDropDown = DropDown()
    let dropDownOptions:[String] = ["Flat", "%"]
    @IBOutlet weak var discountTypeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actualPriceLabel.text = actualPrice
        totalAmount.text = actualPrice
        amountAfterDiscount.text = actualPrice
        
        discountAmountTextField.delegate = self
        quantityTextField.delegate = self
        
        DropDownFunction.setupDropDown(dropDown: discountDropDown, anchor: discountView, dataSource: dropDownOptions, labelToUpdate: discountTypeLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
        
        //-----------------------------------------------------------------------
        discountAmountTextField.addTarget(self, action: #selector(discountTextFieldDidChange(_:)), for: .editingChanged)
        quantityTextField.addTarget(self, action: #selector(quantityTextFieldDidChange(_:)), for: .editingChanged)
        //-----------------------------------------------------------------------
        
    }
    
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func openDiscountDropDown(_ sender: Any) {
        discountDropDown.show()
    }
    
    //-----------------------------------------------------------------------
    @objc func discountTextFieldDidChange(_ textField: UITextField) {
        guard let actualPriceText = totalAmount.text,
              let discountText = discountAmountTextField.text,
              let actualPrice = Double(actualPriceText),
              let discountPercent = Double(discountText) else {
            amountAfterDiscount.text = "Please enter amount"
            return
        }

        if discountTypeLabel.text == "%" {
            let discountedAmount = actualPrice - (actualPrice * discountPercent / 100)
            amountAfterDiscount.text = String(format: "%.2f", discountedAmount)
        } else {
            let discountedAmount = actualPrice - discountPercent
            amountAfterDiscount.text = String(format: "%.2f", discountedAmount)
        }
    }

    @objc func quantityTextFieldDidChange(_ textField: UITextField) {
        guard let priceText = actualPriceLabel.text,
              let quantityText = quantityTextField.text,
              let price = Double(priceText),
              let quantity = Double(quantityText) else {
            totalAmount.text = "Please enter amount"
            return
        }

        let total = price * quantity
        totalAmount.text = String(format: "%.2f", total)
        amountAfterDiscount.text = totalAmount.text
    }
    //-----------------------------------------------------------------------
    
    @IBAction func addItemToCart(_ sender: Any) {
        let cartItem = SalesCartModel(productId: productId!, productListPrice: actualPrice, discountType: discountTypeLabel.text!, discountAmount: discountAmountTextField.text!, totalAmout: totalAmount.text!, amountAfterDiscount: amountAfterDiscount.text!)
        
        GlobalData.salesOrderCart.append(cartItem)
        self.navigationController?.popViewController(animated: true)
    }
}

