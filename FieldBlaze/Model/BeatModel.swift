//
//  BeatModel.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 22/05/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import Foundation

struct BeatModel{
    var id:String?
    var beatName:String?
    var beatType:String?
    var distributerName:String?
    var zoneName:String?
    
    init(dict:[String:Any]){
        self.id = dict["Id"] as? String
        self.beatName = dict["Name"] as? String
        self.beatType = dict["Beat_Type_PI__c"] as? String
        self.distributerName = (dict["Distributor_RE__r"] as? [String:Any])? ["Name"] as? String
        self.zoneName = (dict["Zone_RE__r"] as? [String:Any])? ["Name"] as? String
    }
}


//Model for assigned customers to a beat:
struct AssignedAccountModel{
    var accountName:String?
    var accounId:String?
    var zoneId:String?
    
    init(dict:[String:Any]){
        if let name = dict["Account_RE__r"] as? [String:Any]{
            self.accountName = name["Name"] as? String
            self.accounId = name["Id"] as? String
        }
        if let zone = dict["Beat_Plan_RE__r"] as? [String:Any]{
            self.zoneId = zone["Zone_RE__c"] as? String
        }
    }
}
