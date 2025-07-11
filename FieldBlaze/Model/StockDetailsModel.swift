//
//  StockDetailsModel.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 30/05/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import Foundation

struct StockDetailsModel {
    var id:String
    var stockName:String
    var stockDate:String
    var customerName:String
}

struct StockLineItemsModel{
    var itemName:String
    var itemId:String
    var productName:String
    var itemQuantity:Int
}
