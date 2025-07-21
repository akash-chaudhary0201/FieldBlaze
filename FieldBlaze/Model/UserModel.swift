//
//  UserModel.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 18/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

struct UserModel{
    var userId:String?
    var userRoleId:String?
    var userRole:String?
    
    init(dict:[String:Any]){
        self.userId = dict["Id"] as? String
        self.userRoleId = dict["UserRoleId"] as? String
        self.userRole = (dict["UserRole"] as? [String:Any])?["Name"] as? String
    }
}
