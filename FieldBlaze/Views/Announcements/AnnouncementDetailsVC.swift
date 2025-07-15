//
//  AnnouncementDetailsVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 15/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class AnnouncementDetailsVC: UIViewController {
    
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
        Task{
            await AnnouncementService.getSingleAnnouncement(annId!)
            
            DispatchQueue.main.async {
                if let announcement = GlobalData.allAnnouncements.first {
                    self.name.text = announcement.annName
                    self.type.text = announcement.annType
                    self.endDate.text = announcement.annEndDate
                    self.startDate.text = announcement.annStartDate
                    self.desLabel.text = announcement.annDescription
                }
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
