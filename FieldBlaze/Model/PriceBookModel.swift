//
//  PriceBookModel.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 12/06/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

struct PriceBookModel{
    var id:String?
    var priceBookName:String?

    
    init(dict:[String:Any]){
        self.id = dict["Id"] as? String
        self.priceBookName = dict["Name"] as? String
    }
}
