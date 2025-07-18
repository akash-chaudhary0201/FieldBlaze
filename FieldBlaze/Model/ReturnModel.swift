//
//  ReturnModel.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 16/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

struct ReturnModel{
    var returnId:String?
    var returnName:String?
    var returnDate:String?
    var customerName:String?
    
    init(dict:[String:Any]){
        self.returnId = dict["Id"] as? String
        self.returnName = dict["Name"] as? String
        self.returnDate = dict["Date__c"] as? String
        self.customerName = (dict["Account__r"] as? [String: Any])?["Name"] as? String
    }
}

struct ReturnLineItemModel{
    var itemId:String?
    var itemName:String?
    var itemQuantity:Double?
    
    init(dict:[String:Any]){
        self.itemId = dict["Id"] as? String
        self.itemName = dict["Name"] as? String
        self.itemQuantity = dict["Quantity__c"] as? Double
    }
}
