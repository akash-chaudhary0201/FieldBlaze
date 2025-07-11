//
//  ViewBeatVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 22/05/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class ViewBeatVC: UIViewController {
    
    @IBOutlet weak var distributerName: UILabel!
    @IBOutlet weak var beatType: UILabel!
    @IBOutlet weak var beatName: UILabel!
    var beatId:String?
    
    var singleBeatArray:BeatModel?
    
    var beatObj = BeatService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            if let beat = await beatObj.getSingleBeat(beatId!) {
                self.singleBeatArray = beat
                beatName.text = beat.beatName
                beatType.text = beat.beatType
                distributerName.text = beat.distributerName
            } else {
                print("No beat data found")
            }
        }
        
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
