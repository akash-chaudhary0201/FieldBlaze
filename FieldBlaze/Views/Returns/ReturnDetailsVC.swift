//
//  ReturnDetailsVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 17/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class ReturnDetailsVC: UIViewController {
    
    var returnId:String?
    var returnDate:String?
    var customerName:String?
    var returnName:String?
    
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var returnDateLabel: UILabel!
    @IBOutlet weak var returnNameLabel: UILabel!
    
    //Outlets for return item table:
    @IBOutlet weak var returnItemtable: UITableView!
    @IBOutlet weak var returnItemDropDownView: UIView!
    @IBOutlet weak var returnItemTableHeight: NSLayoutConstraint!
    var isReturnItemDropDownOpen:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        returnItemtable.separatorStyle = .none
        returnItemtable.isScrollEnabled = false
        
        returnItemDropDownView.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        customerNameLabel.text = customerName
        returnDateLabel.text = returnDate
        returnNameLabel.text =  returnName
        
        Task{
            await ReturnService.getReturnLineItems(returnId!) { status in
                if status{
                    DispatchQueue.main.async {
                        self.returnItemtable.reloadData()
                        self.returnItemTableHeight.constant =  CGFloat(GlobalData.returnLineItems.count * 70)
                    }
                }
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func openReturnLineItemDropDown(_ sender: Any) {
        if isReturnItemDropDownOpen{
            returnItemDropDownView.isHidden = true
            isReturnItemDropDownOpen = false
        }else if isReturnItemDropDownOpen == false{
            returnItemDropDownView.isHidden = false
            isReturnItemDropDownOpen = true
        }
    }
}

extension ReturnDetailsVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalData.returnLineItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = returnItemtable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ReturnLineItemCell
        let singleItem = GlobalData.returnLineItems[indexPath.row]
        
        cell.itemName.text = singleItem.itemName
        cell.itemQuantity.text = "\(singleItem.itemQuantity ?? 0.0)"
        
        cell.selectionStyle = .none
        
        return cell
    }
}


class ReturnLineItemCell:UITableViewCell{
    @IBOutlet weak var itemQuantity: UILabel!
    @IBOutlet weak var itemName: UILabel!
}
