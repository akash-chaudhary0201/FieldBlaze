//
//  NotesDetailsVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 18/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class NotesDetailsVC: UIViewController {
    
    //Variable to store data:
    var noteDate:String?
    var noteTitle:String?
    var noteDescription:String?
    
    //Outlets:
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        dateLabel.text = "\(noteDate?.prefix(10) ?? "a")"
        titleLabel.text = noteTitle
        descriptionLabel.text = noteDescription
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
