//
//  CustomersVC.swift
//  FieldBlaze
//
//  Created by Sakshi on 10/04/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class CustomersVC: UIViewController {
    @IBOutlet var tableView: UITableView?
    @IBOutlet var searchVw: UISearchBar?
    @IBOutlet var floatingButton: UIButton?
    @IBOutlet var noDataFoundVw: UIView?
    @IBOutlet var backBtn: UIButton?
    var isFromHomeScreen: Bool = false
    var customer: [Customer] = []
    
    let obj = CustomerService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task{
            await setupUI()
        }
    }
    
    func  setupUI()  async{
        
        await obj.getAllCustomers()
        
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
        
        floatingButton?.layer.cornerRadius = 25
        if isFromHomeScreen {
            backBtn?.isHidden = false
        } else {
            backBtn?.isHidden = true
        }
        
        await  PriceBookService.getPriceBookNames()
        //        print("------------------------Books names array: \(obj.priceBookNames)")
        await obj.getZoneNames()
        await obj.getPaymentTermsNames()
        print("---------------------------------Payment Terms array:-----------\(obj.paymentTerms)")
    }
    
    func addTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addIconaAction() {
        let storyboardBundle = Bundle.main
        let storyboard = UIStoryboard(name: "Customers", bundle: storyboardBundle)
        let createCustomerVC = storyboard.instantiateViewController(withIdentifier: "CreateCustomerVC") as! CreateCustomerVC
        self.navigationController?.pushViewController(createCustomerVC, animated: true)
    }
    
}

extension CustomersVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalData.allCustomers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomersCell = tableView.dequeueReusableCell(withIdentifier: "CustomersCell", for: indexPath) as! CustomersCell
        let customerDict = GlobalData.allCustomers[indexPath.row]
        cell.customerId = customerDict.id
        cell.nameLabl?.text = customerDict.name
        cell.accountOwnerLabl?.text = "System Admin"
        cell.typeLabl?.text = (customerDict.type?.isEmpty == false) ? customerDict.type : "N/A"
        cell.addOrderBtn?.layer.masksToBounds = false
        cell.addOrderBtn?.layer.cornerRadius = 7
        //        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 168
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customerDict = GlobalData.allCustomers[indexPath.row]
        let storyboardBundle = Bundle.main
        let storyboard = UIStoryboard(name: "Customers", bundle: storyboardBundle)
        if let nextController = storyboard.instantiateViewController(withIdentifier: "CustomerInformationVC") as? CustomerInformationVC {
            nextController.customerName = customerDict.name!
            nextController.customerId = customerDict.id!
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
}



class CustomersCell: UITableViewCell {
    @IBOutlet var vw: UIView?
    @IBOutlet var nameLabl: UILabel?
    @IBOutlet var accountOwnerLabl: UILabel?
    @IBOutlet var typeLabl: UILabel?
    @IBOutlet var addOrderBtn: UIButton?
    @IBOutlet var callBtn: UIButton?
    @IBOutlet var locationBtn: UIButton?
    @IBOutlet var whatsappBtn: UIButton?
    
    weak var delegate:CustomCellDelegate?
    
    var customerId:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vw?.layer.cornerRadius = 12
        vw?.layer.borderWidth = 0.5
        vw?.layer.borderColor = UIColor(hex: "#E3E3E3")?.cgColor
        vw?.layer.masksToBounds = false
        vw?.dropShadowTableView()
    }
}
