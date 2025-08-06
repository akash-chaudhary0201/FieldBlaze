//
//  CustomerInsightVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 09/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class CustomerInsightVC: UIViewController {
    
    var accountId:String?
    var visitId:String?
    
    //Obj for customer service class:
    var obj = CustomerService()
    var currentCustomer:Customer?
    
    //Outlets:
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var accountPhone: UILabel!
    @IBOutlet weak var accountDescription: UILabel!
    @IBOutlet weak var accountFirstName: UILabel!
    @IBOutlet weak var accountLastName: UILabel!
    @IBOutlet weak var accountPriceBook: UILabel!
    @IBOutlet weak var accountPaymentTerms: UILabel!
    @IBOutlet weak var accountType: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    //Function to update ui:
    func updateUI(){
        Task{
            self.currentCustomer = await CustomerService.getCustomerBasedOnAccountId(accountId!)
            DispatchQueue.main.async {
                self.accountName.text = self.currentCustomer?.name
                self.accountPhone.text = self.currentCustomer?.phone
                self.accountDescription.text = self.currentCustomer?.description
                self.accountFirstName.text = self.currentCustomer?.txFirstName
                self.accountLastName.text = self.currentCustomer?.txLastName
                self.accountPriceBook.text = self.currentCustomer?.rePriceBookName
                self.accountPaymentTerms.text = self.currentCustomer?.piPaymentTerms
                self.accountType.text = self.currentCustomer?.type
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func proceedAction(_ sender: Any) {
        let storyboard = UIStoryboard(name:"Visits", bundle:nil)
        if let nextController = storyboard.instantiateViewController(withIdentifier: "MeetGreetVC") as? MeetGreetVC{
            nextController.accountId = self.accountId
            nextController.visitId = self.visitId
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
}
