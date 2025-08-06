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
    var totalOrderAmount:Double?
    var salesPersonName:String?
    var orderName:String?
    var priceBookName:String?
    var orderDeliveryDate:String?
    var billingStreet:String?
    var billingCity:String?
    var billingZip:Double?
    var billingState:String?
    var billingCountry:String?
    var shippingStreet:String?
    var shippingCity:String?
    var shippingZip:Double?
    var shippingState:String?
    var shippingCountry:String?
    
    init(dict: [String: Any]) {
            self.id = dict["Id"] as? String
            self.customerName = (dict["RE_Account__r"] as? [String: Any])?["Name"] as? String
            self.orderDate = dict["DA_Order_Date__c"] as? String
            self.totalOrderAmount = dict["Total_Amount__c"] as? Double
            self.salesPersonName = (dict["Sales_Person__r"] as? [String: Any])?["Name"] as? String
            self.orderName = dict["Name"] as? String
            self.priceBookName = (dict["RE_Price_Book__r"] as? [String: Any])?["Name"] as? String
            self.orderDeliveryDate = dict["DA_Order_Delivery_Date__c"] as? String
            self.billingStreet = dict["Billing_Address_Street__c"] as? String
            self.billingCity = dict["Billing_Address__c"] as? String
            self.billingZip = dict["Billing_Address_Postal_Code__c"] as? Double
            self.billingState = dict["Billing_Address_State__c"] as? String
            self.billingCountry = dict["Billing_Address_Country__c"] as? String
            self.shippingStreet = dict["Shipping_Address_Street__c"] as? String
            self.shippingCity = dict["Shipping_Address_City__c"] as? String
            self.shippingZip = dict["Shipping_Address_Postal_Code__c"] as? Double
            self.shippingState = dict["Shipping_Address_State__c"] as? String
            self.shippingCountry = dict["Shipping_Address_Country__c"] as? String
        }
    
}

struct SalesOrderLineItemsModel {
    var id: String?
    var productName: String?
    var cuListPrice: Double?
    var cuSalesPrice: Double?
    var nuQuantity: Double?
    var cuAmount: Double?
    var schemeCode: String?
    var cuAmountAfterDiscount: Double?
    var cuAmountWithGST: Double?
    var cuDiscountAmount: Double?
    var piDiscount: String?
    var cuTotalPrice: Double?
    
    init(dict: [String: Any]) {
        self.id = dict["Id"] as? String
        self.productName = (dict["RE_Product__r"] as? [String: Any])?["Name"] as? String
        self.cuListPrice = dict["CU_List_Price__c"] as? Double
        self.cuSalesPrice = dict["CU_Sales_Price__c"] as? Double
        self.nuQuantity = dict["NU_Quantity__c"] as? Double
        self.cuAmount = dict["CU_Amount__c"] as? Double
        self.schemeCode = dict["Scheme_Code__c"] as? String
        self.cuAmountAfterDiscount = dict["CU_Amount_After_Discount__c"] as? Double
        self.cuAmountWithGST = dict["CU_Amount_with_GST__c"] as? Double
        self.cuDiscountAmount = dict["CU_Discount_Amount__c"] as? Double
        self.piDiscount = dict["PI_Discount__c"] as? String
        self.cuTotalPrice = dict["CU_Total_Price__c"] as? Double
    }
}

struct SalesCartModel{
    var productId:String
    var productListPrice:String
    var discountType:String
    var discountAmount:String
    var totalAmout:String
    var amountAfterDiscount:String
}
