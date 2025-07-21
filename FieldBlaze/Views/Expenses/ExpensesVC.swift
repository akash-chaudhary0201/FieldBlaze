//
//  ExpensesVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 21/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import SwiftLoader

class ExpensesVC: UIViewController {
    
    @IBOutlet weak var allExpenseTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allExpenseTable.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpUi()
    }
    
    func setUpUi(){
        SwiftLoaderHelper.setLoader()
        Task{
            await ExpenseService.getAllExpenses(Defaults.userId!) { status in
                DispatchQueue.main.async {
                    if status{
                        self.allExpenseTable.reloadData()
                        SwiftLoader.hide()
                    }else{
                        AlertFunction.showAlertAndPop("Error in loading data please try again!!", self)
                    }
                }
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ExpensesVC:UITableViewDelegate, UITableViewDataSource, ExpenseTableProtocol{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalData.allExpenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allExpenseTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AllExpenseCell
        
        let singleExpense = GlobalData.allExpenses[indexPath.row]
        
        cell.expenseName.text = singleExpense.expenseName
        cell.status.text = singleExpense.status
        cell.date.text = "\(singleExpense.startDate ?? "") \(singleExpense.endDate ?? "")"
        cell.createdBy.text = singleExpense.createdBy
        
        cell.expenseId = singleExpense.expenseId
        
        if singleExpense.status == "Draft"{
            cell.approvalButton.isHidden = false
        }else{
            cell.approvalButton.isHidden = true
        }
        
        cell.delegate = self
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func sendApprovalButtonTapped(_ expenseId: String) {
        let requestBody: [String: Any] = [
            "requests": [
                [
                    "actionType": "Submit",
                    "contextId": expenseId,
                    "comments":"NA",
                    "contextActorId": Defaults.userId,
                    "processDefinitionNameOrId": "Expenses_Approval_Process",
                    "skipEntryCriteria": "true"
                ]
            ]
        ]
        SwiftLoaderHelper.setLoader()
        
        GlobalPostRequest.commonPostFunction("v63.0/process/approvals", requestBody) { success, response in
            if success{
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                    print(response ?? "1")
                    self.setUpUi()
                }
            }else{
                print(response ?? "1")
                print("Errorrrrrrrrrrrrrrrrrrrrrrrrrrr")
            }
        }
    }
}

protocol ExpenseTableProtocol:AnyObject{
    func sendApprovalButtonTapped(_ expenseId:String)
}

class AllExpenseCell:UITableViewCell{
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var createdBy: UILabel!
    @IBOutlet weak var expenseName: UILabel!
    @IBOutlet weak var approvalButton: UIButton!
    
    var expenseId:String?
    
    var delegate:ExpenseTableProtocol?
    
    @IBAction func reqApprovalButtonAction(_ sender: Any) {
        delegate?.sendApprovalButtonTapped(expenseId!)
    }
}
