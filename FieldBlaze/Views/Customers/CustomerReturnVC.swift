//
//  CustomerReturnVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 30/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class CustomerReturnVC: UIViewController {
    
    @IBOutlet weak var noDateImage: UIImageView!
    
    @IBOutlet weak var allReturnTable: UITableView!
    
    var accountId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noDateImage.isHidden = true
        allReturnTable.isHidden = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Task{
            await ReturnService.getReturnForAccoun(accountId!)
            print(GlobalData.customerReturn)
            DispatchQueue.main.async {
                if GlobalData.customerReturn.isEmpty{
                    self.noDateImage.isHidden = false
                    self.allReturnTable.isHidden = true
                }else{
                    self.noDateImage.isHidden = true
                    self.allReturnTable.isHidden = false
                    self.allReturnTable.reloadData()
                }
                
            }
        }
    }
    
    @IBAction func goToCreateReturn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Returns", bundle: nil)
        if let nextController = storyboard.instantiateViewController(withIdentifier: "CreateReturnVC") as? CreateReturnVC{
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
    
}

extension CustomerReturnVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalData.customerReturn.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allReturnTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AllReturnTableCell
        
        let singleRetun = GlobalData.customerReturn[indexPath.row]
        
        cell.customerName.text = singleRetun.customerName
        cell.returnDate.text = singleRetun.returnDate
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleRetun = GlobalData.customerReturn[indexPath.row]
        let storyboard = UIStoryboard(name:"Returns", bundle:nil)
        if let nextController = storyboard.instantiateViewController(withIdentifier: "ReturnDetailsVC") as? ReturnDetailsVC{
            nextController.returnId = singleRetun.returnId
            nextController.returnName = singleRetun.returnName
            nextController.customerName = singleRetun.customerName
            nextController.returnDate = singleRetun.returnDate
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
}


