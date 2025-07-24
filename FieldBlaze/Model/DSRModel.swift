//
//  DSRModel.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 23/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

struct DSRModel{
    var userName:String?
    var downloadUrl:String?
    
    init(dict:[String:Any]){
        self.userName = dict["USER_NAME"] as? String
        self.downloadUrl = dict["DownloadURL"] as? String
    }
    
}
