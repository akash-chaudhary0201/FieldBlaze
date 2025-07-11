//
//  VisitsModel.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 03/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

struct VisitsModel{
    var visitId:String
    var visitName:String
    var accountName:String
    var accountId:String
    var visitDate:String
    var visitLocation:String
    var visitStatus:String
    var visitCheckInLocation:String
    var visitCheckInLatitude:String
    var visitCheckInLongitude:String
    var visitCheckOutLocation:String
    var visitCheckOutLatitude:String
    var visitCheckOutLongitude:String
    var visitZoneName:String
    
    init(dict:[String:Any]){
        self.visitId = dict["Id"] as? String ?? ""
        self.visitName = dict["Name"] as? String ?? ""
        
        self.visitCheckInLatitude = dict["Check_In_Geolocation_GE__Latitude__s"] as? String ?? ""
        self.visitCheckInLongitude = dict["Check_In_Geolocation_GE__Longitude__s"] as? String ?? ""
        self.visitCheckInLocation = dict["Check_In_Geolocation_GE__c"] as? String ?? ""
        
        self.accountName = ""
        self.accountId = ""
        if let accountDict = dict["Account_RE__r"] as? [String: Any] {
            self.accountName = accountDict["Name"] as? String ?? ""
            self.accountId = accountDict["Id"] as? String ?? ""
            
        }
        
        self.visitLocation = ""
        self.visitZoneName = ""
        if let zoneDict = dict["Zone_RE__r"] as? [String: Any] {
            self.visitZoneName = zoneDict["Name"] as? String ?? ""
            self.visitLocation = zoneDict["Name"] as? String ?? ""
        }
        
        self.visitCheckOutLatitude = dict["Check_Out_Geolocation__Latitude__s"] as? String ?? ""
        self.visitCheckOutLongitude = dict["Check_Out_Geolocation__Longitude__s"] as? String ?? ""
        self.visitCheckOutLocation = dict["Check_Out_Geolocation__c"] as? String ?? ""
        
        self.visitStatus = dict["Visit_Approval_Status__c"] as? String ?? ""
        
        let createdDate = dict["CreatedDate"] as? String ?? ""
        self.visitDate = String(createdDate.prefix(10))
        
    }
}
