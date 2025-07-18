//
//  ReturnsVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 17/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import SwiftLoader

class ReturnsVC: UIViewController {
    
    @IBOutlet weak var allReturnTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allReturnTable.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        SwiftLoaderHelper.setLoader()
        
        Task{
            await ReturnService.getAllReturns(Defaults.userId!) { status in
                DispatchQueue.main.async {
                    if status{
                        SwiftLoader.hide()
                        self.allReturnTable.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ReturnsVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalData.allReturns.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allReturnTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AllReturnTableCell
        
        let singleRetun = GlobalData.allReturns[indexPath.row]
        
        cell.customerName.text = singleRetun.customerName
        cell.returnDate.text = singleRetun.returnDate
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleRetun = GlobalData.allReturns[indexPath.row]
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


class AllReturnTableCell:UITableViewCell{
    
    @IBOutlet weak var returnDate: UILabel!
    @IBOutlet weak var customerName: UILabel!
}
