//
//  CustomersContactVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 04/06/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class CustomersContactVC: UIViewController {
    
    @IBOutlet weak var contactsTable: UITableView!
    var accountId:String?
    
    //Object for Contact Services class:
    var obj = ContactsServices()
    
    //Array to store all the contacts:
    var allContacts:[ContactsModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsTable.separatorStyle = .none

        Task{
            await setUpUI()
        }
    }
    
    func setUpUI() async{
        await obj.getContactsBasedOnAccoundId(accountId!)
        print("All Contacts: \(allContacts)")
        
        DispatchQueue.main.async {
            self.contactsTable.reloadData()
        }
    }
}

extension CustomersContactVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalData.allContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contactsTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactsTableCell
        let singleContact = allContacts[indexPath.row]
        
        cell.name.text = singleContact.contactName
        cell.email.text = singleContact.contactEmail
        cell.department.text = singleContact.department
        
        cell.selectionStyle = .none
        
        return cell
    }
}

class ContactsTableCell:UITableViewCell{
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var department: UILabel!
    @IBOutlet weak var email: UILabel!
    
}
