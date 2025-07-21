//
//  AnnouncementDetailsVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 15/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class AnnouncementDetailsVC: UIViewController {
    
    //Varibale to store annoucemcne details:
    var announcementDescription:String?
    var announcementStartDate:String?
    var announcementEndDate:String?
    var announcementName:String?
    var announcementType:String?
    
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var name: UILabel!
    
    var annId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.name.text = announcementName
        self.type.text = announcementType
        self.endDate.text = announcementEndDate
        self.startDate.text = announcementStartDate
        self.desLabel.text = announcementDescription
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
