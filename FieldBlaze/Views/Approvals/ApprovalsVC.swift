//
//  ApprovalsVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 08/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class ApprovalsVC: UIViewController {
    
    @IBOutlet weak var allApprovalsTable: UITableView!
    var filteredApprovalArray:[Approvals] = []
    
    //Stack buttons:
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var leavesButton: UIButton!
    @IBOutlet weak var expenseButton: UIButton!
    @IBOutlet weak var visitButton: UIButton!
    
    var selectedButton:String?
    
    var obj = ApprovalService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SwiftLoaderHelper.setLoader()
        allApprovalsTable.separatorStyle = .none
        
        highlightButton(allButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpui()
    }
    
    //Function to setup UI:
    func setUpui(){
        Task{
            await obj.getAlApprovalRequest(){ status in
                if status{
                    DispatchQueue.main.async {
                        SwiftLoader.hide()
                        self.allApprovalsTable.reloadData()
                        self.filteredApprovalArray = GlobalData.allApprovalRequest
                    }
                }else{
                    print("hellllllllll no")
                }
            }
            
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func approvalTypesAction(_ sender: UIButton){
        
        switch sender.tag{
        case 0:
            filteredApprovalArray = GlobalData.allApprovalRequest
            allApprovalsTable.reloadData()
            highlightButton(allButton)
            removeHighLight([leavesButton, expenseButton, visitButton])
        case 1:
            filterApprovals("Leave__c")
            allApprovalsTable.reloadData()
            highlightButton(leavesButton)
            removeHighLight([allButton, expenseButton, visitButton])
        case 2:
            filterApprovals("Expenses__c")
            allApprovalsTable.reloadData()
            highlightButton(expenseButton)
            removeHighLight([leavesButton, allButton, visitButton])
        case 3:
            filterApprovals("Visit__c")
            allApprovalsTable.reloadData()
            highlightButton(visitButton)
            removeHighLight([leavesButton, expenseButton, allButton])
        default:
            break
        }
    
    }
    
    //Function to filter approvals based on types:
    func filterApprovals(_ approvalType: String) {
        filteredApprovalArray = GlobalData.allApprovalRequest.filter { approval in
            approval.approvalType == approvalType
            
        }
    }
    
    //Function to give bg to selected buttons:
    func highlightButton(_ button: UIButton) {
        let highlightColor = UIColor(red: 62/255, green: 197/255, blue: 154/255, alpha: 1.0)
            button.backgroundColor = highlightColor
            button.setTitleColor(.white, for: .normal)
    }
    
    func removeHighLight(_ buttons: [UIButton]) {
        let highlightColor = UIColor(red: 62/255, green: 197/255, blue: 154/255, alpha: 1.0)
        for button in buttons {
            button.layer.cornerRadius = 5
            button.backgroundColor = .clear
            button.titleLabel?.textColor = highlightColor
            button.layer.borderWidth = 1
            button.layer.borderColor = highlightColor.cgColor
        }
    }
    
}

extension ApprovalsVC:UITableViewDelegate, UITableViewDataSource, isRejectButtonTapped, isApprovalButtonTapped{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredApprovalArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allApprovalsTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ApprovalTableCell
        
        let singleApprovalRequest = filteredApprovalArray[indexPath.row]
        
        cell.selectionStyle = .none
        
        cell.submittedBy.text = singleApprovalRequest.createdBy
        cell.approvalName.text = singleApprovalRequest.approvalName
        cell.approvalType.text = singleApprovalRequest.approvalType
        cell.submittedDate.text = singleApprovalRequest.createdDate
        cell.approvalStatus.text = singleApprovalRequest.approvalStatus
        
        cell.approvalId = singleApprovalRequest.approvalId
        
        cell.rejectDelegate = self
        cell.approavalDelegate = self
        
        return cell
    }
    
    func rejectedButtonTapped(_ approvalId: String) {
        //        print("-------------REJECTED---------------")
        //        print("Approval Id: \(approvalId)")
        selectedButton = "Reject"
        let storyboard = UIStoryboard(name: "Approvals", bundle: nil)
        if let nextController = storyboard.instantiateViewController(withIdentifier: "ApprovalCommentVC") as? ApprovalCommentVC{
            nextController.approvalResult = selectedButton
            nextController.completionHandler = { refreshTableview in
                self.setUpui()
            }
            nextController.approvalId = approvalId
            nextController.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3966007864)
            self.addChild(nextController)
            nextController.view.frame = self.view.bounds
            self.view.addSubview(nextController.view)
            nextController.didMove(toParent: self)
        }
    }
    
    func approvalButtonTapped(_ approvalId: String) {
        //        print("-------------APPROVED---------------")
        selectedButton = "Approve"
        let storyboard = UIStoryboard(name: "Approvals", bundle: nil)
        if let nextController = storyboard.instantiateViewController(withIdentifier: "ApprovalCommentVC") as? ApprovalCommentVC{
            nextController.approvalResult = selectedButton
            nextController.completionHandler = { refreshTableview in
                self.setUpui()
            }
            nextController.approvalId = approvalId
            nextController.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3966007864)
            self.addChild(nextController)
            nextController.view.frame = self.view.bounds
            self.view.addSubview(nextController.view)
            nextController.didMove(toParent: self)
            
        }
        print("Approval Id: \(approvalId)")
    }
}

protocol isRejectButtonTapped:AnyObject{
    func rejectedButtonTapped(_ approvalId:String)
}

protocol isApprovalButtonTapped:AnyObject{
    func approvalButtonTapped(_ approvalId:String)
}

class ApprovalTableCell:UITableViewCell{
    @IBOutlet weak var submittedBy: UILabel!
    @IBOutlet weak var approvalName: UILabel!
    @IBOutlet weak var approvalType: UILabel!
    @IBOutlet weak var submittedDate: UILabel!
    @IBOutlet weak var approvalStatus: UILabel!
    @IBOutlet weak var mainVie: UIView!
    
    var approvalId:String?
    
    var rejectDelegate:isRejectButtonTapped?
    var approavalDelegate:isApprovalButtonTapped?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyFullShadow()
    }
    
    private func applyFullShadow() {
        mainVie.layer.cornerRadius = 10
        mainVie.layer.shadowColor = UIColor.black.cgColor
        mainVie.layer.shadowOpacity = 0.1
        mainVie.layer.shadowOffset = CGSize(width: 2, height: 2)
        mainVie.layer.shadowRadius = 4
        mainVie.layer.masksToBounds = false
        mainVie.backgroundColor = .white
    }
    
    @IBAction func rejectButtonAction(_ sender: Any) {
        rejectDelegate?.rejectedButtonTapped(approvalId ?? "Ak")
    }
    
    @IBAction func approvalButtonAction(_ sender: Any) {
        approavalDelegate?.approvalButtonTapped(approvalId ?? "Ak")
    }
    
}
