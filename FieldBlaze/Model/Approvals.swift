//
//  Approvals.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 08/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import Foundation

struct Approvals{
    var approvalId:String?
    var createdDate:String?
    var createdBy:String?
    var approvalStatus:String?
    var approvalName:String?
    var approvalType:String?
    
    init(dict: [String: Any]) {
        self.approvalId = dict["Id"] as? String
        self.createdDate = dict["CreatedDate"] as? String
        
        if let createdByDict = dict["CreatedBy"] as? [String:Any]{
            self.createdBy = createdByDict["Name"] as? String
        }
        
        if let approvalStatusDict = dict["ProcessInstance"] as? [String:Any]{
            self.approvalStatus = approvalStatusDict["Status"] as? String
            
            if let approvalTypeDict = approvalStatusDict["TargetObject"] as? [String:Any]{
                self.approvalName = approvalTypeDict["Name"] as? String
                self.approvalType = approvalTypeDict["Type"] as? String
            }
        }
    }
}
