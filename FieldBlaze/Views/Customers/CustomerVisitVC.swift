//
//  CustomerVisitVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 30/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class CustomerVisitVC: UIViewController {
    
    @IBOutlet weak var noDataImage: UIImageView!
    @IBOutlet weak var allVisitsTable: UITableView!
    
    var accountId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noDataImage.isHidden = true
        allVisitsTable.isHidden = false
        
        allVisitsTable.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpUI()
    }
    
    //Function setup:
    func setUpUI(){
        Task{
            await VisitsService.getVisitByAccount(accountId!)
            DispatchQueue.main.async {
                if GlobalData.customerVisits.isEmpty{
                    self.noDataImage.isHidden = false
                    self.allVisitsTable.isHidden = true
                }else{
                    self.noDataImage.isHidden = true
                    self.allVisitsTable.isHidden = false
                    self.allVisitsTable.reloadData()
                }
            }
        }
    }
    
    @IBAction func goToCreateNewVisit(_ sender: Any) {
                let storyboard = UIStoryboard(name: "Visits", bundle: nil)
                if let nextController = storyboard.instantiateViewController(withIdentifier: "CreateNewVisitVC") as? CreateNewVisitVC{
                    self.navigationController?.pushViewController(nextController, animated: true)
                }
    }
    
}

extension CustomerVisitVC:UITableViewDelegate, UITableViewDataSource, reqApprovalBtnTapped{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalData.customerVisits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allVisitsTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VisitsTableCell
        let singleVisit = GlobalData.customerVisits[indexPath.row]
        
        cell.accountName.text = singleVisit.accountName
        cell.visitName.text = singleVisit.visitName
        cell.visitDate.text = singleVisit.visitDate
        cell.visitApprovalStatis.text = singleVisit.visitStatus
        
        if singleVisit.visitStatus == "Approved"{
            cell.reqApprovalView.isHidden = true
        }else if singleVisit.visitStatus == "Pending"{
            cell.reqApprovalView.isHidden = true
            cell.visitApprovalStatis.text = "Pending"
        }else{
            cell.reqApprovalView.isHidden = false
            cell.visitApprovalStatis.text = "Draft"
        }
        
        cell.visitId = singleVisit.visitId
        
        cell.delegate = self
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleVisit = GlobalData.customerVisits[indexPath.row]
        let storyboard = UIStoryboard(name: "Visits", bundle: nil)
        if let nextController = storyboard.instantiateViewController(withIdentifier: "SingleVisitVC") as? SingleVisitVC{
            nextController.visitId = singleVisit.visitId
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
    
    
    func btnTapped(_ visitId: String?) {
        print("Selected row visit id: \(visitId!)")
        
        let requestBody: [String: Any] = [
            "requests": [
                [
                    "actionType": "Submit",
                    "contextId": visitId,
                    "comments":"NA",
                    "contextActorId": Defaults.userId,
                    "processDefinitionNameOrId": "Visit_Approval_Process",
                    "skipEntryCriteria": "true"
                ]
            ]
        ]
        
        SwiftLoaderHelper.setLoader()
        
        GlobalPostRequest.commonPostFunction("v63.0/process/approvals", requestBody) { success, response in
            if success{
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                    self.setUpUI()
                }
            }else{
                print("Errorrrrrrrrrrrrrrrrrrrrrrrrrrr")
            }
        }
        
    }
}


