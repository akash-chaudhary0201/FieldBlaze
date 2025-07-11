//
//  BeatsVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 22/05/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import SwiftLoader

class BeatsVC: UIViewController {
    
    @IBOutlet weak var beatsTable: UITableView!
    
    var beatObject = BeatService()
    
    var allBeatsArray:[BeatModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beatsTable.separatorStyle = .none
        SwiftLoaderHelper.setLoader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Task{
            await beatObject.getAllBeats()
            self.allBeatsArray = beatObject.allBeatsArray
            
            DispatchQueue.main.async {
                SwiftLoader.hide()
                self.beatsTable.reloadData()
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Function to go to create beat vc:
    @IBAction func goToCreateBeat(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Beats", bundle:  nil)
        if let nextController = storyboard.instantiateViewController(identifier: "CreateBeatVC") as? CreateBeatVC {
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
    
}

extension BeatsVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allBeatsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = beatsTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BestTabCell
        let singleBeat = allBeatsArray[indexPath.row]
        
        cell.beatName.text = singleBeat.beatName
        cell.beatType.text = singleBeat.beatType
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleBeat = allBeatsArray[indexPath.row]
        let storyboard = UIStoryboard(name: "Beats", bundle:  nil)
        if let nextController = storyboard.instantiateViewController(identifier: "ViewBeatVC") as? ViewBeatVC {
            nextController.beatId = singleBeat.id
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
}


class BestTabCell:UITableViewCell{
    @IBOutlet weak var beatName: UILabel!
    
    @IBOutlet weak var beatType: UILabel!
}
