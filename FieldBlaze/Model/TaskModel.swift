//
//  TaskModel.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 03/06/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import Foundation

struct TaskModel{
    var subject:String?
    var description:String?
    var id:String?
    var date:String?
    var priority:String?
    var status:String?
    
    init(dict:[String:Any]){
        self.id = dict["Id"] as? String
        self.status = dict["Status"] as? String
        self.priority = dict["Priority"] as? String
        self.description = dict["Description"] as? String
        self.subject = dict["Subject"] as? String
        self.date = dict["CreatedDate"] as? String
    }
}
