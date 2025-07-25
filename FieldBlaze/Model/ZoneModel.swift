//
//  ZoneModel.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 12/06/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

struct ZoneModel{
    var zoneName:String?
    var zoneId:String?
    
    init(dict:[String:Any]){
        self.zoneId = dict["Id"] as? String
        self.zoneName = dict["Name"] as? String
    }
}
