//
//  CreateNewVisitVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 04/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//
import UIKit
import Foundation
import DropDown
import SwiftLoader

class CreateNewVisitVC: UIViewController {
    
    //Visit type button outlets:
    @IBOutlet weak var selectBeatLabel: UILabel!
    @IBOutlet weak var selectBeatImage: UIImageView!
    @IBOutlet weak var selectIndividualImage: UIImageView!
    @IBOutlet weak var selectIndividualLabel: UILabel!
    
    var selectedVisitType:String?
    
    //------------Beat - Wise outlets:----------------
    //Outlets of beat dropdown:
    @IBOutlet weak var beatWiseFullView: UIView!
    @IBOutlet weak var beatWiseViewHieght: NSLayoutConstraint!
    @IBOutlet weak var beatWiseTopSpacing: NSLayoutConstraint!
    @IBOutlet weak var beatDropDownView: UIView!
    let beatDropDown = DropDown()
    var allBeatArray:[BeatModel] = []
    var allBeatsName:[String] = []
    @IBOutlet weak var beatLabel: UILabel!
    var selectBeatId:String?
    
    //-------------------------------------------------
    
    //Outlets for date view:
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateButton: UIButton!
    
    //--------------Individual outlets:-------------------
    @IBOutlet weak var individualFullView: UIView!
    @IBOutlet weak var individualFullViewHeight: NSLayoutConstraint!
    @IBOutlet weak var individualFullViewTopSpacing: NSLayoutConstraint!
    
    //Zone dropdown:
    @IBOutlet weak var zoneDropDownview: UIView!
    @IBOutlet weak var zoneLabel: UILabel!
    var zoneDropDown = DropDown()
    var allZonesArray:[ZoneModel] = []
    var allZoneNames:[String] = []
    var selectedZoneId:String?
    
    //Customer DropDown:
    @IBOutlet weak var customerDropDownView: UIView!
    @IBOutlet weak var customerLabel: UILabel!
    var customerDropDown = DropDown()
    var allCustomerName:[String] = []
    var selectedCustomerId:String?
    
    //Object for beats service:
    var obj = BeatService()
    
    //Object to get all zone names and all customer names::
    var obj2 = CustomerService()
    
    //Object for visit service:
    var visitObj = VisitsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        individualFullView.isHidden = true
        individualFullViewHeight.constant = 0
        individualFullViewTopSpacing.constant = 0
        
        setUpBeatDropDown()
        setUpZoneDropdown()
        //        setUpCustomerDropDown()
    }
    
    //Function to setup beat dropdown:
    func setUpBeatDropDown(){
        Task{
            await obj.getAllBeats()
            self.allBeatArray = obj.allBeatsArray
            //            print("-------------\(allBeatArray)")
            
            self.allBeatsName = allBeatArray.map{$0.beatName}
            DropDownFunction.setupDropDown(dropDown: beatDropDown, anchor: beatDropDownView, dataSource: allBeatsName, labelToUpdate: beatLabel)
            
            beatDropDown.selectionAction = { index, item in
                self.selectBeatId = self.allBeatArray[index].id
                self.beatLabel.text = item
                self.beatLabel.textColor = .black
                print("Selected Zone Id: \(self.selectBeatId!)")
            }
        }
    }
    
    //Function to setup zone dropdown:
    func setUpZoneDropdown(){
        Task{
            await obj2.getZoneNames()
            self.allZonesArray = obj2.zoneNames
            
            self.allZoneNames = allZonesArray.map{$0.zoneName}
            DropDownFunction.setupDropDown(dropDown: zoneDropDown, anchor: zoneDropDownview, dataSource: allZoneNames, labelToUpdate: zoneLabel)
            
            zoneDropDown.selectionAction = { index, item in
                self.selectedZoneId = self.allZonesArray[index].zoneId
                self.zoneLabel.text = item
                self.zoneLabel.textColor = .black
                print("----Selected zone id: \(self.selectedZoneId!)")
                self.setUpCustomerDropDown()
            }
        }
    }
    
    //Function to setup customers dropdown:
    func setUpCustomerDropDown(){
        Task{
            await obj2.geAccountBasedOnZone(selectedZoneId ?? "ak")
            self.allCustomerName = GlobalData.allCustomers.map{$0.name ?? "ak"}
            
            DropDownFunction.setupDropDown(dropDown: customerDropDown, anchor: customerDropDownView, dataSource: allCustomerName, labelToUpdate: customerLabel)
            
            customerDropDown.selectionAction = {index, item in
                self.selectedCustomerId = GlobalData.allCustomers[index].id
                self.customerLabel.text = item
                self.customerLabel.textColor = .black
                print("----customer id: \(self.selectedCustomerId!)")
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func openBeatDropDown(_ sender: Any) {
        beatDropDown.show()
    }
    
    @IBAction func openZoneDropDown(_ sender: Any) {
        customerLabel.text = "Select Customer"
        customerLabel.textColor = .lightGray
        zoneDropDown.show()
    }
    
    @IBAction func openCustomerDropDown(_ sender: Any) {
        customerDropDown.show()
    }
    
    @IBAction func didTapVisitTypeButton(_ sender:UIButton){
        switch sender.tag{
        case 99:
            selectBeatImage.image = UIImage(systemName: "circle.inset.filled")
            selectBeatImage.tintColor = UIColor(red: 62/255, green: 197/255, blue: 154/255, alpha: 1.0)
            selectBeatLabel.textColor = UIColor(red: 62/255, green: 197/255, blue: 154/255, alpha: 1.0)
            selectIndividualImage.image = UIImage(systemName: "circle")
            selectIndividualLabel.textColor = .black
            selectIndividualImage.tintColor = .black
            
            beatWiseFullView.isHidden = false
            beatWiseViewHieght.constant = 50
            beatWiseTopSpacing.constant = 20
            
            individualFullView.isHidden = true
            individualFullViewHeight.constant = 0
            individualFullViewTopSpacing.constant = 0
            
            selectedVisitType = "Beat"
        case 100:
            
            selectIndividualImage.image = UIImage(systemName: "circle.inset.filled")
            selectIndividualImage.tintColor = UIColor(red: 62/255, green: 197/255, blue: 154/255, alpha: 1.0)
            selectIndividualLabel.textColor = UIColor(red: 62/255, green: 197/255, blue: 154/255, alpha: 1.0)
            selectBeatImage.image = UIImage(systemName: "circle")
            selectBeatLabel.textColor = .black
            selectBeatImage.tintColor = .black
            
            beatWiseFullView.isHidden = true
            beatWiseViewHieght.constant = 0
            beatWiseTopSpacing.constant = 0
            
            individualFullView.isHidden = false
            individualFullViewHeight.constant = 120
            individualFullViewTopSpacing.constant = 20
            
            selectedVisitType = "Individual"
        default:
            break
        }
    }
    
    @IBAction func openDatePicker(_ sender: Any) {
        DatePickerHelper.showInlineDatePicker(
            centerIn: self.view,
            targetLabel: dateLabel,
            "yyyy-MM-dd"
        )
    }
    
    @IBAction func createVisitAction(_ sender: Any) {
        guard let visitDate = dateLabel.text, visitDate != "Select Date" else {
            let alert = UIAlertController(title: "Error", message: "Please select a date", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        //
        guard let visitZone = zoneLabel.text, visitZone != "Select Zone" else {
            let alert = UIAlertController(title: "Error", message: "Please select a zone", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        //
        guard let customer = customerLabel.text, customer != "Select Customer" else {
            let alert = UIAlertController(title: "Error", message: "Please select a Customer", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        print("Ak")
        //
        SwiftLoaderHelper.setLoader()

        let requestBody: [String: Any] = [
            "Name": selectedVisitType!,
            "Date_DA__c": dateLabel.text!,
            "Account_RE__c": selectedCustomerId!,
            "Zone_RE__c":selectedZoneId!
        ]
        GlobalPostRequest.commonPostFunction("v63.0/sobjects/Visit__c", requestBody) { success, response in
            if success{
                DispatchQueue.main.async{
                    SwiftLoader.hide()
                    print("---------------------------------------------------------\(response!)")
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                print("Errrorrr---------------------------------------\(response!)")
            }
        }
        
    }
}
