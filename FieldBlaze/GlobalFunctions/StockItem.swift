//
//  StockItem.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 03/06/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

class GlobalClass {
    static let shared = GlobalClass()
    
    private init() {}
    var globlaStockItemArray: [ProductModelToSendAsStock] = []
}
