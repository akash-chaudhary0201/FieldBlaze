//
//  CustomerContactVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 30/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class CustomerContactVC: UIViewController {
    
    @IBOutlet weak var noDataImage: UIImageView!
    @IBOutlet weak var allContactsTable: UITableView!
    
    var accountId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noDataImage.isHidden = true
        allContactsTable.isHidden = true
        allContactsTable.separatorStyle = .none

        setUpUI()
    }
    
    //Function to setup:
    func setUpUI(){
        Task{
            await ContactsServices.getContactsBasedOnAccoundId(accountId!)
            DispatchQueue.main.async {
                if GlobalData.allContacts.isEmpty{
                    self.noDataImage.isHidden = false
                    self.allContactsTable.isHidden = true
                }else{
                    self.noDataImage.isHidden = true
                    self.allContactsTable.isHidden = false
                    self.allContactsTable.reloadData()
                }
                
            }
        }
    }
}

extension CustomerContactVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalData.allContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allContactsTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomerContactCell
        let singleContact = GlobalData.allContacts[indexPath.row]
        
        cell.contactName.text = singleContact.contactName
        cell.contactRole.text = singleContact.department
        cell.contactEmail.text = singleContact.contactEmail
        cell.contactPhone.text = singleContact.contactPhone
        
        cell.selectionStyle = .none
        
        return cell
    }
}

class CustomerContactCell:UITableViewCell{
    @IBOutlet weak var contactEmail: UILabel!
    @IBOutlet weak var contactPhone: UILabel!
    @IBOutlet weak var contactDescription: UILabel!
    @IBOutlet weak var contactRole: UILabel!
    @IBOutlet weak var contactName: UILabel!
}
