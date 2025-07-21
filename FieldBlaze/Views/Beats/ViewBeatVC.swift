//
//  ViewBeatVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 22/05/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class ViewBeatVC: UIViewController {
    
    var beatName:String?
    var beatType:String?
    var distributerName:String?
    var zoneName:String?
    
    var beatId:String?
    
    @IBOutlet weak var mainTypeLabe: UILabel!
    @IBOutlet weak var beatLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var disZoneLabel: UILabel!
    
    //Related dropdown outlets:
    @IBOutlet weak var relatedFullView: UIView!
    @IBOutlet weak var relatedTable: UITableView!
    @IBOutlet weak var relatedTableHeight: NSLayoutConstraint!
    var isRelatedViewOpen:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beatLabel.text = beatName
        typeLabel.text = beatType
        if beatType == "Zone"{
            mainTypeLabe.text = "Zone"
            disZoneLabel.text = zoneName
        }else{
            mainTypeLabe.text = "Distributer"
            disZoneLabel.text = distributerName
        }
        
        relatedTable.separatorStyle = .none
        relatedTable.isScrollEnabled = false
        
        relatedFullView.isHidden = true
        relatedTableHeight.constant = 0
        
        Task{
            await setUpUI()
        }
    }
    
    func setUpUI()async{
        await BeatService.getAllAssignedAccounts(beatId!)
        DispatchQueue.main.async {
            self.relatedTable.reloadData()
            self.relatedTableHeight.constant = CGFloat(GlobalData.assignedAccounts.count * 50)
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func relatedButtonAction(_ sender: Any) {
        if isRelatedViewOpen{
            relatedFullView.isHidden = true
            isRelatedViewOpen = false
        }else{
            relatedFullView.isHidden = false
            isRelatedViewOpen = true
        }
    }
    
}

extension ViewBeatVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalData.assignedAccounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = relatedTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AssignedAccounCell
        
        let singleCell = GlobalData.assignedAccounts[indexPath.row]
        
        cell.accountName.text = singleCell.accountName
        cell.selectionStyle = .none
        return cell
    }
    
}


class AssignedAccounCell:UITableViewCell{
    @IBOutlet weak var accountName: UILabel!
    
}
