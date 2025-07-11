//
//  ContactsModel.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 09/06/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import Foundation

struct ContactsModel{
    var contactId:String?
    var contactName:String?
    var contactEmail:String?
    var contactPhone:String?
    var department:String?
    var accountId:String?
    
    init(dict:[String:Any]){
        self.contactId =  dict["Id"] as? String
        self.contactName = dict["Name"] as? String
        self.contactEmail = dict["Email"] as? String
        self.contactPhone = dict["Phone"] as? String
        self.department = dict["Department"] as? String
        self.accountId = dict["AccountId"] as? String
    }
}
