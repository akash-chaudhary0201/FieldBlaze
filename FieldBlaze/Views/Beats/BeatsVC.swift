//
//  BeatsVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 22/05/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import SwiftLoader

class BeatsVC: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var beatsTable: UITableView!
    @IBOutlet weak var beatSearchBar: UISearchBar!
    
    var beatObject = BeatService()
    var filteredBeats:[BeatModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beatsTable.separatorStyle = .none
        SwiftLoaderHelper.setLoader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Task{
            await BeatService.getAllBeats()
            self.filteredBeats = GlobalData.allBeats
            
            DispatchQueue.main.async {
                SwiftLoader.hide()
                self.beatsTable.reloadData()
            }
        }
    }
    
    //Search Bar functionality:
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredBeats = GlobalData.allBeats
        } else {
            filteredBeats = GlobalData.allBeats.filter {
                $0.beatName?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
        DispatchQueue.main.async {
            self.beatsTable.reloadData()
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
        return filteredBeats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = beatsTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BestTabCell
        let singleBeat = filteredBeats[indexPath.row]
        
        cell.beatName.text = singleBeat.beatName
        cell.beatType.text = singleBeat.beatType
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleBeat = filteredBeats[indexPath.row]
        let storyboard = UIStoryboard(name: "Beats", bundle:  nil)
        if let nextController = storyboard.instantiateViewController(identifier: "ViewBeatVC") as? ViewBeatVC {
            nextController.beatId = singleBeat.id
            nextController.zoneName = singleBeat.zoneName
            nextController.distributerName = singleBeat.distributerName
            nextController.beatName = singleBeat.beatName
            nextController.beatType = singleBeat.beatType
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
}


class BestTabCell:UITableViewCell{
    @IBOutlet weak var beatName: UILabel!
    
    @IBOutlet weak var beatType: UILabel!
}
