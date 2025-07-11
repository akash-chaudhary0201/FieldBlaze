//
//  detailVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 04/06/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var addressTableHeight: NSLayoutConstraint!
    @IBOutlet weak var addressTable: UITableView!
    @IBOutlet weak var detTable: UITableView!
    
    var detArray:[String] = ["Account Name:", "Parent Account Id:", "Mobile:", "Account Type:", "Whatsapp Number:", "First Name:", "Last Name:", "PAN:", "GST:", "is Active:", "is Primary:", "Payment Terms:", "Price Book:", "Zone:"]
    
    var addressArray:[String] = ["Billing Street:", "Billing City:", "Billing Zip:", "Billing State:", "Billing Country:", "Same As Billing:", "Shipping Street:", "Shipping City:", "Shipping Zip:", "Shipping State:", "Shipping Country:"]
    
    var obj = CustomerService()
    var currentCustomer:Customer?
    
    var accountId:String?
    
    var isAddressTableOpen:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detTable.isScrollEnabled = false
        addressTable.isScrollEnabled = false
        
        addressTableHeight.constant = 0
        
        Task{
            await setUpUI()
        }
    }
    
    func setUpUI() async{
        currentCustomer = await obj.getCustomerBasedOnAccountId(accountId!)
//        print("Customer---------------------------\(currentCustomer!)")
        
        DispatchQueue.main.async {
            self.detTable.reloadData()
            self.addressTable.reloadData()
        }
    }
    
    @IBAction func openAddressTable(_ sender: Any) {
        if !isAddressTableOpen {
            addressTableHeight.constant = 440
            isAddressTableOpen = true
        } else {
            addressTableHeight.constant = 0
            isAddressTableOpen = false
        }
    }
    
}


extension DetailVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == detTable{
            return detArray.count
        }else if tableView == addressTable{
            return addressArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == detTable{
            let cell = detTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustDetCell
            
            cell.leftLabel.text = detArray[indexPath.row]
            
            switch indexPath.row{
            case 0:
                cell.rightLabel.text = currentCustomer?.name
            case 1:
                cell.rightLabel.text = currentCustomer?.parentName
            case 2:
                cell.rightLabel.text = currentCustomer?.phone
            case 3:
                cell.rightLabel.text = currentCustomer?.type
            case 4:
                cell.rightLabel.text = currentCustomer?.whatsapp
            case 5:
                cell.rightLabel.text = currentCustomer?.txFirstName
            case 6:
                cell.rightLabel.text = currentCustomer?.txLastName
            case 7:
                cell.rightLabel.text = currentCustomer?.txPAN
            case 8:
                cell.rightLabel.text = currentCustomer?.txGST
            case 9:
                cell.rightLabel.text = currentCustomer?.cbIsActive
            case 10:
                cell.rightLabel.text = currentCustomer?.cbIsPrimary
            case 11:
                cell.rightLabel.text = currentCustomer?.piPaymentTerms
            case 12:
                cell.rightLabel.text = currentCustomer?.rePriceBookName
            case 13:
                cell.rightLabel.text = currentCustomer?.reZoneName
            default:
                cell.rightLabel.text = "Wait for now"
            }
            
            return cell
        }else if tableView == addressTable{
            let cell = addressTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CusAddressCol
            
            cell.leftLabel.text = addressArray[indexPath.row]
            
            switch indexPath.row{
            case 0:
                cell.rightLabel.text = currentCustomer?.billingStreet
            case 1:
                cell.rightLabel.text = currentCustomer?.billingCity
            case 2:
                cell.rightLabel.text = currentCustomer?.billingPostalCode
            case 3:
                cell.rightLabel.text = currentCustomer?.billingState
            case 4:
                cell.rightLabel.text = currentCustomer?.billingCountry
            case 5:
                cell.rightLabel.text = currentCustomer?.cbSameAsBilling
            case 6:
                cell.rightLabel.text = currentCustomer?.shippingStreet
            case 7:
                cell.rightLabel.text = currentCustomer?.shippingCity
            case 8:
                cell.rightLabel.text = currentCustomer?.shippingPostalCode
            case 9:
                cell.rightLabel.text = currentCustomer?.shippingState
            case 10:
                cell.rightLabel.text = currentCustomer?.shippingCountry
            default:
                cell.rightLabel.text = currentCustomer?.shippingCountry
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
}

class CustDetCell:UITableViewCell{
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
}

class CusAddressCol:UITableViewCell{
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
}
