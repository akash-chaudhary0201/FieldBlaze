//
//  AnnouncementModel.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 15/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

struct AnnouncementModel{
    var annId:String?
    var annName:String?
    var annStartDate:String?
    var annEndDate:String?
    var annDescription:String?
    var annImageUrl:String?
    var annType:String?
    
    init(dict:[String:Any]){
        self.annId = dict["Id"] as? String
        self.annName = dict["Name"] as? String
        self.annStartDate = dict["Start_Date_DA__c"] as? String
        self.annEndDate = dict["End_Date_DA__c"] as? String
        self.annDescription = dict["Description_TX__c"] as? String
        self.annType = dict["Type_PI__c"] as? String
        self.annImageUrl = dict["Announcement_Image__c"] as? String
    }
}
