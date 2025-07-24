//
//  AddReturnProductVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 22/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import MaterialComponents
import DropDown

class AddReturnProductVC: UIViewController {
    
    //product
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var productLabel: UILabel!
    var allProductNames:[String] = []
    var allProductDropDown = DropDown()
    var selectedProductedId:String = ""
    
    //quantity
    @IBOutlet weak var quantityTextField: MDCOutlinedTextField!
    
    //return type
    @IBOutlet weak var returnTypeView: UIView!
    @IBOutlet weak var returnTypeLabel: UILabel!
    var returnTypeArray = ["Expire", "Defective", "Others"]
    var returnDropDown = DropDown()
    
    //reason
    @IBOutlet weak var reasonTextArea: MDCOutlinedTextArea!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetTextFields.setTextField(quantityTextField, "Enter Quantity")
        SetTextFields.setTextAreas(reasonTextArea, "Enter Reason")
        
        //setup return type dropdown:
        DropDownFunction.setupDropDown(dropDown: returnDropDown, anchor: returnTypeView, dataSource: returnTypeArray, labelToUpdate: returnTypeLabel)
        
        //Product Dropdown:
        Task{
            await ProductsService.getAllProduct()
            self.allProductNames = GlobalData.allProducts.map{$0.name ?? "a"}
            
            DropDownFunction.setupDropDown(dropDown: allProductDropDown, anchor: productView, dataSource: allProductNames, labelToUpdate: productLabel)
            
            allProductDropDown.selectionAction = {index, item in
                self.selectedProductedId = GlobalData.allProducts[index].id ?? "a"
                self.productLabel.text = item
                self.productLabel.textColor = .black
                print("----product id: \(self.selectedProductedId)")
            }
        }
    }
    
    
    @IBAction func baclAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func openProductDropDown(_ sender: Any) {
        allProductDropDown.show()
    }
    
    @IBAction func openReturnTypeDropDown(_ sender: Any) {
        returnDropDown.show()
    }
    
    @IBAction func addItemAction(_ sender: Any) {
        
        if productLabel.text == "" || quantityTextField.text == "" || returnTypeLabel.text == ""{
            AlertFunction.showErrorAlert("Please fill all details", self)
        }else{
            let singleReturnProduct = ItmeToReturnModel(itemId: selectedProductedId, itemName:productLabel.text, itemQuantity: quantityTextField.text, returnType: returnTypeLabel.text)
            GlobalData.selectedReturnItem.append(singleReturnProduct)
            AlertFunction.showAlertAndPop("Item addedd successfully", self)
        }
    }
}
