//
//  ProductModels.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 02/06/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import Foundation

struct FetchedProductsModel{
    var id:String?
    var name:String?
    
    
    init(dict:[String:Any]){
        self.id = dict["Id"] as? String
        self.name = dict["Name"] as? String
    }
}

struct FetchedProductPriceBook{
    var id:String?
    var name:String?
    var listPrice:Double?
    
    init(dict: [String: Any]) {
        self.id = dict["Id"] as? String ?? ""
        self.name = dict["Name"] as? String ?? ""
        self.listPrice = dict["CU_List_Price__c"] as? Double
    }
}

struct ProductModelToSendAsStock{
    var id:String
    var name:String
    var quantity:Int
}


