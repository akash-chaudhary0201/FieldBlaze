//
//  SchemeModel.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary on 22/05/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import Foundation

struct SchemeModel {
    var schemeId: String?
    var schemeName: String?
    var schemeType: String?
    var minimumOrder: Double?
    var discountType: String?
    var startDate: String?
    var endDate: String?
    var discountValue: Double?
    var schemeCode: String?
    var schemeStatus: Bool?
    
    init(dict: [String: Any]) {
        self.schemeId = dict["Id"] as? String
        self.schemeName = dict["Name"] as? String
        self.schemeType = dict["Type__c"] as? String
        self.minimumOrder = dict["Minimum_Order_Value__c"] as? Double
        self.discountType = dict["Discount_Type__c"] as? String
        self.startDate = dict["Start_Date__c"] as? String
        self.endDate = dict["End_Date__c"] as? String
        self.discountValue = dict["Discount_Value__c"] as? Double
        self.schemeCode = dict["Scheme_Code__c"] as? String
        self.schemeStatus = dict["Status__c"] as? Bool
    }
}
