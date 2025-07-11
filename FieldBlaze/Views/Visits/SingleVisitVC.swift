//
//  SingleVisitVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 04/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import SwiftLoader

class SingleVisitVC: UIViewController {
    
    var obj = VisitsService()
    var singleVisit:VisitsModel?
    
    var visitId:String?
    
    
    @IBOutlet weak var visitName: UILabel!
    @IBOutlet weak var zoneLabel: UILabel!
    @IBOutlet weak var accountName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            self.singleVisit = await obj.getSingleVisitOnId(visitId!)
            
            if let visit = self.singleVisit {
                print("Visit Name: \(visit.visitName)")
                print("Account Name: \(visit.accountName)")
                print("Zone: \(visit.visitLocation)")
            } else {
                print("Visit not found or data error")
            }
            
            self.updateUi()
        }
    }
    
    
    func updateUi() {
        visitName.text = singleVisit?.visitName ?? "N/A"
        zoneLabel.text = singleVisit?.visitLocation ?? "N/A"
        accountName.text = singleVisit?.accountName ?? "N/A"
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

