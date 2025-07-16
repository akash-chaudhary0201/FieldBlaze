//
//  StockDetailsModel.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 30/05/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import Foundation

struct StockDetailsModel {
    var id:String?
    var stockName:String?
    var stockDate:String?
    var customerName:String?
    
    init(dict:[String:Any]){
        self.id = dict["Id"] as? String
        self.stockName = dict["Name"] as? String
        self.stockDate = dict["Date__c"] as? String
        self.customerName = (dict["Account__r"] as? [String: Any])?["Name"] as? String
    }
}

struct StockLineItemsModel{
    var itemName:String
    var itemId:String
    var productName:String
    var itemQuantity:Int
}
