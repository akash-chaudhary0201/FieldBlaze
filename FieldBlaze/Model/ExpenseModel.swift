//
//  ExpenseModel.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 21/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

struct ExpenseModel{
    var expenseId:String?
    var expenseName:String?
    var createdBy:String?
    var startDate:String?
    var endDate:String?
    var status:String?
    
    init(dict:[String:Any]){
        self.expenseId = dict["Id"] as? String
        self.expenseName = dict["Name"] as? String
        self.startDate = dict["Start_Date__c"] as? String
        self.endDate = dict["End_Date__c"] as? String
        self.status = dict["Approval_Status__c"] as? String
        
        if let accountDict = dict["CreatedBy"] as? [String:Any]{
            self.createdBy = accountDict["Name"] as? String
        }
    }
}
