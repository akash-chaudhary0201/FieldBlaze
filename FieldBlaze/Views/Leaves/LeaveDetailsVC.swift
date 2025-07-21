//
//  LeaveDetailsVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 18/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class LeaveDetailsVC: UIViewController {
    
    //varibale to store data from parent page:
    var employeeName:String?
    var startDate:String?
    var endDate:String?
    var leaveSatus:String?
    var leaveType:String?
    var halfFull:String?
    
    //Outlets:
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var fullHalfLabel: UILabel!
    @IBOutlet weak var leaveTypeLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var leaveStatusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = employeeName
        startDateLabel.text = startDate
        endDateLabel.text = endDate
        leaveStatusLabel.text = leaveSatus
        leaveTypeLabel.text = leaveType
        fullHalfLabel.text = halfFull
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
