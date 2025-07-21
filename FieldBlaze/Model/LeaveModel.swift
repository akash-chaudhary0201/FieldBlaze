//
//  LeaveModel.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 18/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import Foundation

struct LeaveModel{
    var leaveId:String?
    var leaveName:String?
    var leaveStartDate:String?
    var leaveEndDate:String?
    var leaveType:String?
    var leaveCreatedById:String?
    var leaveStatus:String?
    var employeeName:String?
    var halfFull:String?
    
    init(dict:[String:Any]){
        self.leaveId = dict["Id"] as? String
        self.leaveName = dict["Name"] as? String
        self.leaveType = dict["PI_LeaveType__c"] as? String
        self.leaveStatus = dict["PI_Leave_Status__c"] as? String
        self.leaveStartDate = dict["DA_StartDate__c"] as? String
        self.leaveEndDate = dict["DA_End_Date__c"] as? String
        self.leaveCreatedById = dict["CreatedById"] as? String
        self.employeeName = (dict["RE_Employee__r"] as? [String: Any])?["Name"] as? String
        self.halfFull = dict["PI_Full_Day_Half_Day__c"] as? String
     }
}
