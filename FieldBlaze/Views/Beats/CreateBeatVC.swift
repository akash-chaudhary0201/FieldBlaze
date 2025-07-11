//
//  CreateBeatVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 02/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import DropDown
import SwiftLoader

class CreateBeatVC: UIViewController {
    
    @IBOutlet weak var beatNameTextField: UITextField!
    
    //Arrays for zone:
    @IBOutlet weak var selectZoneImage: UIImageView!
    @IBOutlet weak var selectZoneLabel: UILabel!
    var allZones:[ZoneModel] = []
    var obj = CustomerService()
    var obj2 = BeatService()
    var zoneNames:[String] = []
    let zoneDropDown = DropDown()
    @IBOutlet weak var zoneDropDownView: UIView!
    @IBOutlet weak var zoneLabel: UILabel!
    @IBOutlet weak var zoneViewHeight: NSLayoutConstraint!
    var selectedZoneId:String?
    
    //Arrays for distrubuter:
    @IBOutlet weak var selectDistributerLabel: UILabel!
    @IBOutlet weak var selectDistributerImage: UIImageView!
    let distributerDropDown = DropDown()
    var allDistributers:[DistributerModel] = []
    var distributersNames:[String] = []
    @IBOutlet weak var distributerDropDownView: UIView!
    @IBOutlet weak var distributerLabel: UILabel!
    @IBOutlet weak var distributerViewHeight: NSLayoutConstraint!
    var selectedDistributerId:String?
    
    //Account outlets:s
    @IBOutlet weak var accountsTable: UITableView!
    @IBOutlet weak var accountTableHieght: NSLayoutConstraint!
    var isAccountSelected:Bool = false
    var selectedAccountId:[String] = []
    
    //Variable to store selected beat type:
    var selectedBeatType:String = "Zone"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountsTable.separatorStyle = .none
        
        distributerDropDownView.isHidden = true
        distributerViewHeight.constant = 0
        
        //Hiding accounts table by default:
        accountsTable.isHidden = true
        accountTableHieght.constant = 0
        
        setUpZoneDropDown()
        setUpDistributerDropDown()
    }
    
    //Function to setup zone dropdown:
    func setUpZoneDropDown(){
        Task{
            await obj.getZoneNames()
            self.allZones = obj.zoneNames
            zoneNames = allZones.map { $0.zoneName }
            
            //Zone dropdown setup:
            DropDownFunction.setupDropDown(dropDown: zoneDropDown, anchor: zoneDropDownView, dataSource: zoneNames, labelToUpdate: zoneLabel)
            
            zoneDropDown.selectionAction = { index, item in
                self.selectedZoneId = self.allZones[index].zoneId
                self.zoneLabel.text = item
                self.zoneLabel.textColor = .black
                print("Selected Zone Id: \(self.selectedZoneId!)")
                self.selectedAccountId.removeAll()
                Task{
                    await  self.obj.geAccountBasedOnZone(self.selectedZoneId!)
                    DispatchQueue.main.async{
                        self.accountsTable.isHidden = false
                        self.accountTableHieght.constant = 500
                        self.accountsTable.reloadData()
                    }
                }
            }
        }
    }
    
    //Function to setup distributer dropdown:
    func setUpDistributerDropDown(){
        Task{
            await obj.getDistributers()
            self.allDistributers = obj.distributerNames
            self.distributersNames = allDistributers.map{$0.distributerName}
            
            //DropDown:
            DropDownFunction.setupDropDown(dropDown: distributerDropDown, anchor: distributerDropDownView, dataSource: distributersNames, labelToUpdate: distributerLabel)
            
            distributerDropDown.selectionAction = { index, item in
                self.selectedDistributerId = self.allDistributers[index].distributerId
                self.distributerLabel.text = item
                self.distributerLabel.textColor = .black
                Task{
                    await self.obj.geAccountBasedOnDistributer(self.selectedDistributerId!)
                    DispatchQueue.main.async {
                        self.accountsTable.isHidden = false
                        self.accountTableHieght.constant = 500
                        self.accountsTable.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func openZoneDropDown(_ sender: Any) {
        zoneDropDown.show()
    }
    @IBAction func openDistributerDropDown(_ sender: Any) {
        distributerDropDown.show()
    }
    
    @IBAction func beatTypeButtonTapped(_ sender:UIButton){
        switch sender.tag{
        case 99:
            selectedBeatType = "Zone"
            selectZoneImage.image = UIImage(systemName: "circle.inset.filled")
            selectZoneImage.tintColor = UIColor(red: 62/255, green: 197/255, blue: 154/255, alpha: 1.0)
            selectZoneLabel.textColor = UIColor(red: 62/255, green: 197/255, blue: 154/255, alpha: 1.0)
            selectDistributerImage.image = UIImage(systemName: "circle")
            selectDistributerLabel.textColor = .black
            selectDistributerImage.tintColor = .black
            
            accountsTable.isHidden = true
            accountTableHieght.constant = 0
            
            zoneDropDownView.isHidden = false
            zoneViewHeight.constant = 50
            
            distributerDropDownView.isHidden = true
            distributerViewHeight.constant = 0
        case 100:
            selectedBeatType = "Distributor"
            selectDistributerImage.image = UIImage(systemName: "circle.inset.filled")
            selectDistributerImage.tintColor = UIColor(red: 62/255, green: 197/255, blue: 154/255, alpha: 1.0)
            selectDistributerLabel.textColor = UIColor(red: 62/255, green: 197/255, blue: 154/255, alpha: 1.0)
            selectZoneImage.image = UIImage(systemName: "circle")
            selectZoneLabel.textColor = .black
            selectZoneImage.tintColor = .black
            
            accountsTable.isHidden = true
            accountTableHieght.constant = 0
            
            zoneDropDownView.isHidden = true
            zoneViewHeight.constant = 0
            
            distributerDropDownView.isHidden = false
            distributerViewHeight.constant = 50
        default:
            break
        }
    }
    
    //Function to create full to send in body of create beat api:
    func createApiBodyFunc() -> [String:Any]{
        let assignedCustomers: [[String: Any]] = selectedAccountId.enumerated().map { (index, accountId) in
            [
                "attributes": [
                    "type": "Assigned_Customer__c",
                    "referenceId": "ref1-\(index + 1)"
                ],
                "Account_RE__c": accountId
            ]
        }
        
//        Zone_RE__c
        // Create the main body
        let body: [String: Any] = [
            "records": [
                [
                    "attributes": [
                        "type": "Beat_Plan__c",
                        "referenceId": "ref1"
                    ],
                    "Name": beatNameTextField.text!,
                    "Beat_Type_PI__c": selectedBeatType,
                    selectedBeatType == "Zone" ? "Zone_RE__c"  : "Distributor_RE__c" : selectedBeatType == "Zone" ? selectedZoneId! : selectedDistributerId!,
                    "Assigned_Customers__r": [
                        "records": assignedCustomers
                    ]
                ]
            ]
        ]
        return body
    }
    
    //Action for create button:
    @IBAction func createBeatAction(_ sender: Any) {
        guard let beatName = beatNameTextField.text, !beatName.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Please enter a beat name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        if selectedBeatType == "Zone"{
            guard selectedZoneId != nil else {
                let alert = UIAlertController(title: "Error", message: "Please select a zone", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                return
            }
            SwiftLoaderHelper.setLoader()
            let requestBody = createApiBodyFunc()
            obj2.createBeatPlan(requestBody) { st in
                if st{
                    DispatchQueue.main.async {
                        SwiftLoader.hide()
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            print("-----------------\(selectedBeatType)")
        }else{
            
            SwiftLoaderHelper.setLoader()
            let requestBody = createApiBodyFunc()
            obj2.createBeatPlan(requestBody) { st in
                if st{
                    DispatchQueue.main.async {
                        SwiftLoader.hide()
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            print("-----------------\(selectedBeatType)")
        }
        
    }
    
}

extension CreateBeatVC:UITableViewDelegate, UITableViewDataSource, AccountTablDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        GlobalData.allCustomers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = accountsTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AccountTableCell
        let customerDict = GlobalData.allCustomers[indexPath.row]
        
        cell.phoneLabel.text = customerDict.phone
        cell.ownerLabel.text = customerDict.ownerName
        cell.typeLabel.text = customerDict.type
        cell.addressLabel.text = customerDict.billingCity
        cell.nameLabel.text = customerDict.name
        cell.accountId = customerDict.id
        
        cell.selectionStyle = .none
        
        cell.delegate = self
        
        return cell
    }
    
    func didTapBUtton(btn: UIButton, accountId: String) {
        if selectedAccountId.contains(accountId) {
            selectedAccountId.removeAll { $0 == accountId }
            btn.setImage(UIImage(named: "uncheck"), for: .normal)
        } else {
            selectedAccountId.append(accountId)
            btn.setImage(UIImage(named: "addcheck"), for: .normal)
        }
    }
    
}

protocol AccountTablDelegate:AnyObject{
    func didTapBUtton(btn:UIButton, accountId:String)
}

class AccountTableCell:UITableViewCell{
    
    weak var delegate: AccountTablDelegate?
    
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectionBtn: UIButton!
    
    var accountId:String?
    
    @IBAction func accountSelectionAction(_ sender: UIButton) {
        delegate?.didTapBUtton(btn:selectionBtn, accountId: accountId!)
    }
}

