//
//  CreateReturnVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 22/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import DropDown

class CreateReturnVC: UIViewController {
    
    
    @IBOutlet weak var selectReturnItemTable: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    //Customer View:
    @IBOutlet weak var customerView: UIView!
    @IBOutlet weak var customerLabel: UILabel!
    var selectedCustomerId:String = ""
    var customerDropDown = DropDown()
    var allCustomerName:[String] = []
    
    
    //DateView
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectReturnItemTable.separatorStyle = .none
        selectReturnItemTable.isScrollEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableHeight.constant = CGFloat(GlobalData.selectedReturnItem.count * 105)
        selectReturnItemTable.reloadData()
        print(GlobalData.selectedReturnItem)
        
        Task{
            await CustomerService.getAllCustomers(Defaults.userId!)
            self.allCustomerName = GlobalData.allCustomers.map{$0.name ?? ""}
            
            DropDownFunction.setupDropDown(dropDown: customerDropDown, anchor: customerView, dataSource: allCustomerName, labelToUpdate: customerLabel)
            
            customerDropDown.selectionAction = {index, item in
                self.selectedCustomerId = GlobalData.allCustomers[index].id ?? "a"
                self.customerLabel.text = item
                self.customerLabel.textColor = .black
                print("----customer id: \(self.selectedCustomerId)")
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        GlobalData.selectedReturnItem.removeAll()
    }
    
    @IBAction func goToAddReturnProducts(_ sender: Any) {
        if selectedCustomerId == ""{
            AlertFunction.showErrorAlert("Please Select a Customer First", self)
        }else{
            let storyboard = UIStoryboard(name:"Returns", bundle:nil)
            if let nextController = storyboard.instantiateViewController(withIdentifier: "AddReturnProductVC") as? AddReturnProductVC{
                self.navigationController?.pushViewController(nextController, animated: true)
            }
        }
        
    }
    
    @IBAction func openCustomerDropDown(_ sender: Any) {
        customerDropDown.show()
    }
    
    @IBAction func openDateSelector(_ sender: Any) {
        DatePickerHelper.showInlineDatePicker(centerIn: self.view, targetLabel: dateLabel, "yyyy-MM-dd")
    }
    
    //Function to create request body:
    func createReturnPayload(accountId: String, returnDate: String) -> [String: Any] {
        var compositeRequest: [[String: Any]] = []
        
        let returnRequest: [String: Any] = [
            "method": "POST",
            "url": "/services/data/v59.0/sobjects/Return__c",
            "referenceId": "Re1",
            "body": [
                "Account__c": accountId,
                "Date__c": returnDate
            ]
        ]
        
        compositeRequest.append(returnRequest)
        
        for (index, item) in GlobalData.selectedReturnItem.enumerated() {
            let lineRequest: [String: Any] = [
                "method": "POST",
                "url": "/services/data/v59.0/sobjects/Return_Item__c",
                "referenceId": "ReturnLine\(index + 1)",
                "body": [
                    "Name": item.itemName ?? "Return Item \(index + 1)",
                    "Product__c": item.itemId ?? "",
                    "Quantity__c": Int(item.itemQuantity ?? "0") ?? 0,
                    "Return__c": "@{Re1.id}",
                    "Return_Type__c": item.returnType ?? ""
                ]
            ]
            compositeRequest.append(lineRequest)
        }
        
        let payload: [String: Any] = [
            "compositeRequest": compositeRequest,
            "allOrNone": false
        ]
        return payload
    }
    
    
    //Function to create return request:
    @IBAction func createReturnAction(_ sender: Any) {
        if selectedCustomerId == ""{
            AlertFunction.showErrorAlert("Please select a customer and add return product", self)
        }else if dateLabel.text == "Select Date"{
            AlertFunction.showErrorAlert("Please select a date", self)
        }else if GlobalData.selectedReturnItem.count == 0{
            AlertFunction.showErrorAlert("Please add return product", self)
        }
        
        let requestBody = createReturnPayload(accountId: selectedCustomerId, returnDate: dateLabel.text ?? "")
        GlobalPostRequest.commonPostFunction("v59.0/composite", requestBody) { success, response in
            DispatchQueue.main.async {
                if success{
                    print(response)
                    AlertFunction.showErrorAlert("\(response ?? "")", self)
                }else{
                    print(response)
                    AlertFunction.showErrorAlert("\(response ?? "")", self)
                }
            }
        }
    }
    
}

extension CreateReturnVC:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalData.selectedReturnItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = selectReturnItemTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelectedReturnProductCell
        
        let single = GlobalData.selectedReturnItem[indexPath.row]
        
        cell.name.text = single.itemName
        cell.quantity.text = single.itemQuantity
        cell.type.text = single.returnType
        
        cell.selectionStyle = .none
        
        return cell
    }
}


class SelectedReturnProductCell:UITableViewCell{
    
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var name: UILabel!
}
