//
//  AllVisitsVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 03/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import SwiftLoader

class AllVisitsVC: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var allVisitsTable: UITableView!
    var filteredVisits:[VisitsModel] = []
    @IBOutlet weak var visitSearchBar: UISearchBar!
    
    var obj = VisitsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Defaults.userId!)
        
        SwiftLoaderHelper.setLoader()
        allVisitsTable.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpUI()
    }
    
    //Function setup:
    func setUpUI(){
        Task{
            await obj.getAllVisits()
            self.filteredVisits = GlobalData.allVisits
            DispatchQueue.main.async {
                SwiftLoader.hide()
                self.allVisitsTable.reloadData()
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToCreateNewVisit(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Visits", bundle: nil)
        if let nextController = storyboard.instantiateViewController(withIdentifier: "CreateNewVisitVC") as? CreateNewVisitVC{
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
    
    //Search Functionality
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredVisits = GlobalData.allVisits
        } else {
            filteredVisits = GlobalData.allVisits.filter {
                $0.accountName.lowercased().contains(searchText.lowercased())
            }
        }
        DispatchQueue.main.async {
            self.allVisitsTable.reloadData()
        }
    }

}

extension AllVisitsVC:UITableViewDelegate, UITableViewDataSource, reqApprovalBtnTapped{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredVisits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allVisitsTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VisitsTableCell
        let singleVisit = filteredVisits[indexPath.row]
        
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
        let singleVisit = filteredVisits[indexPath.row]
        let storyboard = UIStoryboard(name: "Visits", bundle: nil)
        if let nextController = storyboard.instantiateViewController(withIdentifier: "SingleVisitVC") as? SingleVisitVC{
            nextController.visitId = singleVisit.visitId
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
    
    func tableView(_ tableView:UITableView, commit editingStyle:UITableViewCell.EditingStyle, forRowAt indexPath:IndexPath){
        if editingStyle == .delete{
            filteredVisits.remove(at: indexPath.row)
            allVisitsTable.deleteRows(at: [indexPath], with: .fade)
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


protocol reqApprovalBtnTapped:AnyObject{
    func btnTapped(_ visitId:String?)
}

class VisitsTableCell:UITableViewCell{
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var visitName: UILabel!
    @IBOutlet weak var visitDate: UILabel!
    @IBOutlet weak var visitApprovalStatis: UILabel!
    @IBOutlet weak var reqApprovalView: UIView!
    
    var visitId:String?
    
    var delegate:reqApprovalBtnTapped?
    
    @IBAction func btnTappedAction(_ sender: Any) {
        delegate?.btnTapped(visitId)
    }
}
