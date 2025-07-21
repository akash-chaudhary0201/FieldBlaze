//
//  NotesModel.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 18/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

struct NotesModel{
    var noteId:String?
    var noteTitle:String?
    var noteDescription:String?
    var noteDate:String?
    
    init(dict:[String:Any]){
        self.noteId = dict["Id"] as? String
        self.noteDate = dict["CreatedDate"] as? String
        self.noteDescription = dict["TextPreview"] as? String
        self.noteTitle = dict["Title"] as? String
    }
}
