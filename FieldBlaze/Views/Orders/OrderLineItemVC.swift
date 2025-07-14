//
//  OrderLineItemVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 14/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import DropDown

class OrderLineItemVC: UIViewController {
    
    var productId:String?
    
    @IBOutlet weak var discountView: UIView!
    var discountDropDown = DropDown()
    let dropDownOptions:[String] = ["Flat", "%"]
    @IBOutlet weak var dropDownLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DropDownFunction.setupDropDown(dropDown: discountDropDown, anchor: discountView, dataSource: dropDownOptions, labelToUpdate: dropDownLabel)
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func openDiscountDropDown(_ sender: Any) {
        discountDropDown.show()
    }
}
