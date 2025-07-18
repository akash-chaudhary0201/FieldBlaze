//
//  DistributerModel.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 03/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

struct DistributerModel{
    var distributerName:String?
    var distributerId:String?
    
    init(dict:[String:Any]){
        self.distributerName = dict["Name"] as? String
        self.distributerId = dict["Id"] as? String
    }
}
