//
//  AddStockItemSubView.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 02/06/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import DropDown

class AddStockItemSubView: UIViewController, UITextFieldDelegate {
    
    var obj = StockTrackingService()
    
    @IBOutlet weak var dropDownAnchorView: UIView!
    @IBOutlet weak var quantityLabel: UITextField!
    @IBOutlet weak var enterQuantityView: UIView!
    @IBOutlet weak var searchProductLabel: UITextField!
    @IBOutlet weak var productDropDownView: UIView!
    
    var productNames:[String] = []
    var allProducts:[FetchedProductsModel] = []
    
    let globalObj = GlobalClass.shared

    var productDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchProductLabel.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        Task{
//            await ProductsService.getAllProducts()
            
            self.allProducts = GlobalData.allProducts
            
            productNames = self.allProducts.compactMap { $0.name }
            
            setupDropDown(dropDown: productDropDown, anchor: dropDownAnchorView, dataSource: productNames, textFieldToUpdate: searchProductLabel)
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Function for setup dropdown:
    func setupDropDown(dropDown: DropDown, anchor: UIView, dataSource: [String], textFieldToUpdate: UITextField) {
        dropDown.anchorView = anchor
        dropDown.dataSource = dataSource
        dropDown.direction = .any
        
        dropDown.selectionAction = { (index: Int, item: String) in
            textFieldToUpdate.text = item
            textFieldToUpdate.textColor = .black
        }
        
        dropDown.backgroundColor = .white
        dropDown.setupCornerRadius(10)
        dropDown.textColor = .black
    }
    
    //Customer filtering function:
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let query = textField.text?.lowercased() else { return }
        
        let filtered = productNames.filter { $0.lowercased().contains(query) }
        
        productDropDown.dataSource = filtered
        productDropDown.show()
    }
    
    //Create stock action:
    @IBAction func createStockAction(_ sender: Any) {
        guard let productName = searchProductLabel.text, !productName.isEmpty else {
            print("empty")
            return
        }
        
        guard let matchedProduct = allProducts.first(where: { $0.name == productName }) else {
            print("No product \(productName)")
            return
        }
        
        guard let quantityText = quantityLabel.text, let quantity = Int(quantityText), quantity > 0 else {
            print("No quantity")
            return
        }
        
        let singleProduct = ProductModelToSendAsStock(id: matchedProduct.id!, name: matchedProduct.name!, quantity: quantity)
        globalObj.globlaStockItemArray.append(singleProduct)
        
        searchProductLabel.text = ""
        quantityLabel.text = ""
        
        self.navigationController?.popViewController(animated: true)
        
    }
}
