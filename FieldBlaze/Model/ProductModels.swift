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
    var productPrice:Int?
    
    
    init(dict:[String:Any]){
        self.id = ""
        self.name = ""
        if let productDict = dict["Product__r"] as? [String: Any] {
            self.id = productDict["Id"] as? String ?? ""
            self.name = productDict["Name"] as? String ?? ""
        }
        self.productPrice = dict["CU_List_Price__c"] as? Int
    }
}

struct ProductModelToSendAsStock{
    var id:String
    var name:String
    var quantity:Int
}


