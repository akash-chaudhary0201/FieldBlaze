////
////  CreateSalesOrderController.swift
////  FieldBlaze
////
////  Created by Sakshi on 15/04/25.
////  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
////
//
import UIKit
import DropDown

class CreateSalesOrderController: UIViewController {
    
    //Customer view:
    @IBOutlet weak var customerView: UIView!
    @IBOutlet weak var customerLabel: UILabel!
    
    //Order view:
    @IBOutlet weak var orderDateView: UIView!
    @IBOutlet weak var orderDateLabel: UILabel!
    
    //Delivery view:
    @IBOutlet weak var deliveryDateView: UIView!
    @IBOutlet weak var deliveryDateLabel: UILabel!
    
    //Pricebook view:
    @IBOutlet weak var pricebookView: UIView!
    @IBOutlet weak var pricebookLabel: UILabel!
    var pricebookDropDown = DropDown()
    var obj = CustomerService()
    var allPricebookNames:[String] = []
    var selectedPriceBookId:String = ""
    
    override func viewDidLoad() {
        
        updateUI()
    }
    
    //Function to update ui
    func updateUI(){
        Task{
            await PriceBookService.getPriceBookNames()
            self.allPricebookNames = GlobalData.allPriceBooks.map{$0.priceBookName!}
            
            DropDownFunction.setupDropDown(dropDown: pricebookDropDown, anchor: pricebookView, dataSource: allPricebookNames, labelToUpdate: pricebookLabel)
            
            pricebookDropDown.selectionAction = { index, item in
                self.selectedPriceBookId = GlobalData.allPriceBooks[index].id ?? ""
                self.pricebookLabel.text = item
                self.pricebookLabel.textColor = .black
                print("Selected Pricebook label Id: \(self.selectedPriceBookId)")
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //All buttons action:------------------------------------------------
    @IBAction func selectCustomerAction(_ sender: Any) {
    }
    
    @IBAction func orderDateAction(_ sender: Any) {
        DatePickerHelper.showInlineDatePicker(centerIn: self.view, targetLabel: orderDateLabel)
    }
    
    @IBAction func deliveryDateAction(_ sender: Any) {
        DatePickerHelper.showInlineDatePicker(centerIn: self.view, targetLabel: deliveryDateLabel)
    }
    
    @IBAction func pricebookAction(_ sender: Any) {
        pricebookDropDown.show()
    }
    
    //Function to go to all Products page:
    @IBAction func gotToAllProducts(_ sender: Any) {
        
        if selectedPriceBookId == ""{
            AlertFunction.showErrorAlert("Please Select a Pricebook", self)
        }else{
            let storyboard = UIStoryboard(name: "Orders", bundle: nil)
            if let nextController = storyboard.instantiateViewController(withIdentifier: "AllProductsVC") as? AllProductsVC{
                nextController.priceBookId = self.selectedPriceBookId
                self.navigationController?.pushViewController(nextController, animated: true)
            }
        }
    }
}
