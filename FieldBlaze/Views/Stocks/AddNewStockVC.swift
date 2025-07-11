//
//  AddNewStockVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 30/05/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import DropDown

class AddNewStockVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var noStockItemLabel: UILabel!
    @IBOutlet weak var addStockButton: UIButton!
    var objForAddStockItemClass = AddStockItemSubView()
    
    @IBOutlet weak var tabHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var stockItemTable: UITableView!
    
    //Sample data for stock items array:
    var sampleProducts: [ProductModelToSendAsStock] = []
    
    //Object for stock services:
    var objForStock = StockTrackingService()
    
    //Variable to store request body:
    var requestBody:[String:Any] = [:]
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var customerTextField: UITextField!
    @IBOutlet weak var dropDownAnchorView: UIView!
    var accounts: [Customer] = []
    let obj = CustomerService()
    
    var accountId:String?
    
    //object for global array to send:
    let globalObj = GlobalClass.shared
    
    var customerNames:[String] = []
    
    var customerNameDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customerTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        setUpDatePicker()
        
        stockItemTable.separatorStyle = .none
        noStockItemLabel.isHidden = false
        stockItemTable.isHidden = true
        
        Task{
            await setUpUI()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.sampleProducts = globalObj.globlaStockItemArray
        tabHeightConstant.constant = CGFloat(sampleProducts.count * 70)
        
        if sampleProducts.count != 0{
            noStockItemLabel.isHidden = true
            stockItemTable.isHidden = false
            addStockButton.setTitle("Add more stock items", for: .normal)
        }
        
        DispatchQueue.main.async {
            self.stockItemTable.reloadData()
        }
        //
        //        requestBody = getRequestBody(sampleProducts, self.accountId ?? "Ak", "2025-06-11")
    }
    
    func getRequestBody(_ products:[ProductModelToSendAsStock], _ accountId:String, _ date:String) -> [String:Any]{
        var stockLineItems:[[String:Any]] = []
        
        for(index, product) in products.enumerated(){
            let stockLineItem:[String:Any] = [
                "attributes": [
                    "type": "Available_Stock__c",
                    "referenceId": "SR\(10000 + index)"
                ],
                "Product__c": product.id,
                "Quantity__c": product.quantity
            ]
            stockLineItems.append(stockLineItem)
        }
        let fullRecord:[String:Any] = [
            "attributes": [
                "type": "Inventory_Tracking__c",
                "referenceId": "Inventory_T_1"
            ],
            "Account__c": accountId,
            "Date__c": date,
            "Available_Stocks__r": [
                "records": stockLineItems
            ]
        ]
        return ["records":[fullRecord]]
    }
    
    func setUpUI() async{
        await obj.getAllCustomers()
        
        self.accounts = GlobalData.allCustomers
        customerNames = self.accounts.compactMap { $0.name }
        
        setupDropDown(
            dropDown: customerNameDropDown,
            anchor: dropDownAnchorView,
            dataSource: customerNames,
            textFieldToUpdate: customerTextField
        )
    }
    
    //Function to setup date picker:
    func setUpDatePicker(){
        datePicker.locale = .current
        datePicker.date = Date()
        datePicker.preferredDatePickerStyle = .inline
        datePicker.isHidden = true
        datePicker.backgroundColor = UIColor.systemGray6
        datePicker.addTarget(self, action: #selector(dateSelected), for: .valueChanged)
    }
    
    @objc func dateSelected(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "yyyy-mm-dd"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        dateLabel.text = selectedDate
        datePicker.isHidden = true
    }
    
    //Function for setup dropdown:
    func setupDropDown(dropDown: DropDown, anchor: UIView, dataSource: [String], textFieldToUpdate: UITextField) {
        dropDown.anchorView = anchor
        dropDown.dataSource = dataSource
        dropDown.direction = .any
        
        dropDown.selectionAction = { (index: Int, item: String) in
            textFieldToUpdate.text = item
            textFieldToUpdate.textColor = .black
            
            if let selectedCustomer = self.accounts.first(where: { $0.name == item }) {
                self.accountId = selectedCustomer.id
                self.requestBody = self.getRequestBody(self.sampleProducts, self.accountId ?? "Ak", "2025-06-12")
                
            }
        }
        
        dropDown.backgroundColor = .white
        dropDown.setupCornerRadius(10)
        dropDown.textColor = .black
    }
    
    //Customer filtering function:
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let query = textField.text?.lowercased() else { return }
        
        let filtered = customerNames.filter { $0.lowercased().contains(query) }
        
        customerNameDropDown.dataSource = filtered
        customerNameDropDown.show()
    }
    
    @IBAction func openDatePicker(_ sender: Any) {
        dateLabel.textColor = .black
        datePicker.isHidden = false
    }
    
    
    //Go back action:
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        globalObj.globlaStockItemArray.removeAll()
    }
    
    @IBAction func openAddStockItems(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Stocks", bundle: nil)
        if let checkInVc = storyboard.instantiateViewController(withIdentifier: "AddStockItemSubView") as? AddStockItemSubView {
            self.navigationController?.pushViewController(checkInVc, animated: true)
        }
    }
    
    @IBAction func createStockAction(_ sender: Any) {
        objForStock.createStock(requestBody)
    }
    
}

extension AddNewStockVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = stockItemTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StockItemCell
        let singleItem = sampleProducts[indexPath.row]
        
        cell.itemName.text = singleItem.name
        cell.itemQuantity.text = "\(singleItem.quantity)"
        return cell
    }
}

class StockItemCell:UITableViewCell{
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemQuantity: UILabel!
}
