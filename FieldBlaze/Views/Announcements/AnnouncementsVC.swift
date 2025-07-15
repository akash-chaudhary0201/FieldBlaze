//
//  AnnouncementsVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 15/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import SwiftLoader

class AnnouncementsVC: UIViewController {
    
    @IBOutlet weak var allAnnouncementsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allAnnouncementsTable.separatorStyle = .none
        
        SwiftLoaderHelper.setLoader()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Task{
            await AnnouncementService.getAllnnouncements { status in
                if status{
                    print(GlobalData.allAnnouncements)
                    DispatchQueue.main.async {
                        SwiftLoader.hide()
                        self.allAnnouncementsTable.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension AnnouncementsVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalData.allAnnouncements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allAnnouncementsTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AnnouncementCell
        let singleAnn = GlobalData.allAnnouncements[indexPath.row]
        
        cell.name.text = singleAnn.annName
        cell.type.text = singleAnn.annType
        cell.dateLabel.text = singleAnn.annStartDate
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleAnn = GlobalData.allAnnouncements[indexPath.row]
        let storyboard = UIStoryboard(name: "Announcements", bundle: nil)
        if let nextController = storyboard.instantiateViewController(withIdentifier: "AnnouncementDetailsVC") as? AnnouncementDetailsVC{
            nextController.annId = singleAnn.annId
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
}

class AnnouncementCell:UITableViewCell{
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var name: UILabel!
}
