//
//  LeavesVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 18/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import SwiftLoader

class LeavesVC: UIViewController {
    
    @IBOutlet weak var leavesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leavesTable.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpUI()
    }
    
    //Function to setup ui
    func setUpUI(){
        SwiftLoaderHelper.setLoader()
        Task{
            await LeaveService.getAllleaves(Defaults.userId!) { status in
                DispatchQueue.main.async {
//                    print(GlobalData.allLeaves)
                    SwiftLoader.hide()
                    self.leavesTable.reloadData()
                }
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToApplyLeave(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Leaves", bundle: nil)
        if let nextController = storyboard.instantiateViewController(withIdentifier: "CreateLeaveVC") as? CreateLeaveVC{
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
}

extension LeavesVC:UITableViewDelegate, UITableViewDataSource, LeaveApprovalProtocol{

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalData.allLeaves.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = leavesTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AllLeavesCell
        
        let singleLeave = GlobalData.allLeaves[indexPath.row]
        
        cell.leaveName.text = singleLeave.leaveName
        cell.leaveType.text = singleLeave.leaveType
        cell.leaveDate.text = "\(singleLeave.leaveStartDate ?? "a") \(singleLeave.leaveEndDate ?? "a")"
        cell.leaveStatus.text = singleLeave.leaveStatus
        cell.leaveId = singleLeave.leaveId
        
        if singleLeave.leaveStatus == nil{
            cell.approvalButton.isHidden = false
        }else{
            cell.approvalButton.isHidden = true
        }
        
        cell.selectionStyle = .none
        
        cell.delegate = self

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleLeave = GlobalData.allLeaves[indexPath.row]
        let storyboard = UIStoryboard(name: "Leaves", bundle: nil)
        if let nextController = storyboard.instantiateViewController(withIdentifier: "LeaveDetailsVC") as? LeaveDetailsVC{
            nextController.employeeName = singleLeave.employeeName
            nextController.startDate = singleLeave.leaveStartDate
            nextController.endDate = singleLeave.leaveEndDate
            nextController.leaveType = singleLeave.leaveType
            nextController.halfFull = singleLeave.halfFull
            nextController.leaveSatus = singleLeave.leaveStatus
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
    
    func approvalButtonTapped(_ leaveId: String) {
        let requestBody: [String: Any] = [
            "requests": [
                [
                    "actionType": "Submit",
                    "contextId": leaveId,
                    "comments":"NA",
                    "contextActorId": Defaults.userId,
                    "processDefinitionNameOrId": "Leave_Approval_Process",
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
                    self.setUpUI()
                }
            }else{
                print(response ?? "1")
                print("Errorrrrrrrrrrrrrrrrrrrrrrrrrrr")
            }
        }
    }
}

protocol LeaveApprovalProtocol:AnyObject{
    func approvalButtonTapped(_ leaveId:String)
}


class AllLeavesCell:UITableViewCell{
    
    @IBOutlet weak var leaveStatus: UILabel!
    @IBOutlet weak var leaveDate: UILabel!
    @IBOutlet weak var leaveType: UILabel!
    @IBOutlet weak var leaveName: UILabel!
    @IBOutlet weak var approvalButton: UIButton!
    
    
    var leaveId:String?
    
    var delegate:LeaveApprovalProtocol?
    
    
    @IBAction func approvalButtonAction(_ sender: Any) {
        delegate?.approvalButtonTapped(leaveId!)
    }
    
}
