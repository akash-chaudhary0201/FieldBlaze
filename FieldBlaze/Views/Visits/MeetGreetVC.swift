//
//  MeetGreetVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 09/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class MeetGreetVC: UIViewController {

    @IBOutlet weak var allContactsTable: UITableView!
    @IBOutlet weak var contactTableHeight: NSLayoutConstraint!
    
    var accountId:String?
    var visitId:String?
    
    //Object to get all contacts:
    var obj = ContactsServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allContactsTable.separatorStyle = .none
        allContactsTable.isScrollEnabled = false
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.allContactsTable.reloadData()
        print("-------------------------\(GlobalData.allContacts)")
    }
    
    //Function to setup:
    func setUpUI(){
        Task{
            await obj.getContactsBasedOnAccoundId(accountId!)
            DispatchQueue.main.async {
                self.contactTableHeight.constant  = CGFloat(GlobalData.allContacts.count * 60)
                self.allContactsTable.reloadData()
                print("------------------------------------------\(GlobalData.allContacts.count)")
            }
        }
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func proceedAction(_ sender: Any) {
        let storyboard = UIStoryboard(name:"Visits", bundle:nil)
        if let nextController = storyboard.instantiateViewController(withIdentifier: "VisitStockDetailsVC") as? VisitStockDetailsVC{
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
    
    //Go to add contact page:
    @IBAction func goToAddContact(_ sender: Any) {
        let storyboard = UIStoryboard(name:"Visits", bundle:nil)
        if let nextController = storyboard.instantiateViewController(withIdentifier: "AddContactVC") as? AddContactVC{
            nextController.accountId = self.accountId
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
    
}

extension MeetGreetVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalData.allContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allContactsTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactsCell
        let singleContact = GlobalData.allContacts[indexPath.row]
        
        cell.contactName.text = singleContact.contactName
        cell.contactDepartment.text = singleContact.department
        
        cell.selectionStyle = .none
        
        return cell
    }
}

class ContactsCell:UITableViewCell{
    @IBOutlet weak var contactDepartment: UILabel!
    @IBOutlet weak var contactName: UILabel!
}

