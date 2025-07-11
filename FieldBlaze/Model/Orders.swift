//
//  Orders.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 16/05/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import Foundation

struct Orders{
    var id:String?
    var customerName:String?
    var orderDate:String?
    var totalOrderAmount:String?
    var salesPersonName:String?
    var orderName:String?
    var priceBookName:String?
    var orderDeliveryDate:String?
    var billingStreet:String?
    var billingCity:String?
    var billingZip:String?
    var billingState:String?
    var billingCountry:String?
    var shippingStreet:String?
    var shippingCity:String?
    var shippingZip:String?
    var shippingState:String?
    var shippingCountry:String?
    
}


struct SalesOrderLineItemsModel{
    var Id:String?
    var RE_Product__r:String?
    var CU_List_Price__c:String?
    var CU_Sales_Price__c:String?
    var NU_Quantity__c:String?
    var CU_Amount__c:String?
    var Scheme_Code__c:String?
    var CU_Amount_After_Discount__c:String?
    var CU_Amount_with_GST__c:String?
    var CU_Discount_Amount__c:String?
    var PI_Discount__c:String?
    var CU_Total_Price__c:String?
}
