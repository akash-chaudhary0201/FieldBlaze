//
//  NotesVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 18/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import SwiftLoader

class NotesVC: UIViewController {
    
    @IBOutlet weak var allNotesTable: UITableView!
    var filteredNotes:[NotesModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allNotesTable.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SwiftLoaderHelper.setLoader()
        Task{
            await NoteService.getAllNotes(Defaults.userId!) { status in
                DispatchQueue.main.async {
                    if status{
                        self.filteredNotes = GlobalData.allNotes
                        SwiftLoader.hide()
                        self.allNotesTable.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func goToAddNewNote(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Notes", bundle: nil)
        if let nextController = storyboard.instantiateViewController(withIdentifier: "CreateNotesVC") as? CreateNotesVC{
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
    
}

extension NotesVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allNotesTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AllNotesCell
        
        let singleNote = filteredNotes[indexPath.row]
        
        cell.noteTitle.text = singleNote.noteTitle
        cell.noteDescription.text = singleNote.noteDescription
        cell.noteDate.text = "\(singleNote.noteDate?.prefix(10) ?? "a")"
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleNote = filteredNotes[indexPath.row]
        let storyboard = UIStoryboard(name: "Notes", bundle: nil)
        if let nextController = storyboard.instantiateViewController(withIdentifier: "NotesDetailsVC") as? NotesDetailsVC{
            nextController.noteDate = singleNote.noteDate
            nextController.noteTitle = singleNote.noteTitle
            nextController.noteDescription = singleNote.noteDescription
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }

}


class AllNotesCell:UITableViewCell{
    @IBOutlet weak var noteTitle: UILabel!
    @IBOutlet weak var noteDescription: UILabel!
    @IBOutlet weak var noteDate: UILabel!
}
