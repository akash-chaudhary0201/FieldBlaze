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

class CreateSalesOrderController: UIViewController, UITextFieldDelegate {
    
    //Customer view:
    @IBOutlet weak var customerView: UIView!
    
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
    var allPricebookNames:[String] = []
    var selectedPriceBookId:String = ""
    
    //Customer view:
    var customerName:[String] = []
    var customerDropDown = DropDown()
    var selectedCustomerId:String = ""
    @IBOutlet weak var selectCustomerTextField: UITextField!
    var filteredCustomers: [Customer] = []

    
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectCustomerTextField.delegate = self
        updatePriceBook()
        updateCustomer()
        
        setupCustomerDropDown()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //Function to update ui
    func updatePriceBook(){
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
    
    func updateCustomer() {
        Task {
            await CustomerService.getAllCustomers(Defaults.userId!)
            self.customerName = GlobalData.allCustomers.compactMap { $0.name }
            self.customerDropDown.dataSource = self.customerName
        }
    }
    
    
    func setupCustomerDropDown() {
        customerDropDown.anchorView = selectCustomerTextField
        customerDropDown.direction = .bottom
        customerDropDown.bottomOffset = CGPoint(x: 0, y: selectCustomerTextField.frame.height)
        
        customerDropDown.selectionAction = {  index, item in
            
            self.selectCustomerTextField.text = item
            self.selectCustomerTextField.textColor = .black

            let selectedCustomer = self.filteredCustomers[index]
            self.selectedCustomerId = selectedCustomer.id ?? ""
            print("Selected Customer ID: \(self.selectedCustomerId)")
        }

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        filterCustomers(with: currentText)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        filterCustomers(with: "")
        return true
    }
    
    private func filterCustomers(with query: String) {
        filteredCustomers = query.isEmpty
            ? GlobalData.allCustomers
            : GlobalData.allCustomers.filter { $0.name?.lowercased().contains(query.lowercased()) == true }

        self.customerName = filteredCustomers.compactMap { $0.name }
        self.customerDropDown.dataSource = self.customerName
        self.customerDropDown.show()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.customerName.removeAll()
    }
    
    //All buttons action:------------------------------------------------
    @IBAction func selectCustomerAction(_ sender: Any) {
    }
    
    @IBAction func orderDateAction(_ sender: Any) {
        DatePickerHelper.showInlineDatePicker(centerIn: self.view, targetLabel: orderDateLabel, "yyyy-MM-dd")
    }
    
    @IBAction func deliveryDateAction(_ sender: Any) {
        DatePickerHelper.showInlineDatePicker(centerIn: self.view, targetLabel: deliveryDateLabel, "yyyy-MM-dd")
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
