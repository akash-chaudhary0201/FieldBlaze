//
//  OrdersService.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 16/05/25
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import Foundation

class OrdersService{
    let webRequest = BaseWebService()
    let endPoint = EndPoints()
    
    var ordersArray:[Orders] = []
    
    var singleOrder:[Orders] = []
    var salesOrderLineItemArray:[SalesOrderLineItemsModel] = []
    
    var orderForSingleCustomer:[Orders] = []
    
    //Function to get all orders:
    func getAllOrders(completion:@escaping(Bool) -> Void) async {
        let soqlQuery = """
        SELECT Id, Name, RE_Account__r.Name, DA_Order_Date__c, DA_Order_Delivery_Date__c, Total_Amount__c, Sales_Person__r.Name 
        FROM Sales_Order__c 
        ORDER BY DA_Order_Date__c DESC
        """
        
        guard let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let instanceUrl = Defaults.instanceUrl else {
            return
            
        }
        
        let fullUrl = "\(instanceUrl)/services/data/v59.0/query/?q=\(encodedQuery)"
        
        guard let url = URL(string: fullUrl) else {
            return
        }
         
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(for: request)
//            print("Full URL for get all customers: \(fullUrl)")
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let jsonDict = jsonData["records"] as? [[String: Any]] {
                
                for record in jsonDict {
                    let id = record["Id"] as? String
                    let customerName = (record["RE_Account__r"] as? [String: Any])?["Name"] as? String
                    let orderDate = record["DA_Order_Date__c"] as? String
                    let orderDeliveryDate = record["DA_Order_Delivery_Date__c"] as? String
                    let totalOrderAmount = String(describing: record["Total_Amount__c"] ?? "")
                    let salesPersonName = (record["Sales_Person__r"] as? [String: Any])?["Name"] as? String
                    let orderName = record["Name"] as? String
                    
                    
                    let order = Orders(
                        id:id,
                        customerName: customerName,
                        orderDate: orderDate,
                        totalOrderAmount: totalOrderAmount,
                        salesPersonName: salesPersonName,
                        orderName: orderName,
                        orderDeliveryDate: orderDeliveryDate,
                        
                    )
                    completion(true)
                    ordersArray.append(order)
                }
            }
        } catch {
            completion(false)
            print("Error: \(error)")
        }
    }
    
    //Function to get single order based on the order id:
    func getOrderBasedOnOrderId(_ orderId: String, completion: @escaping (Bool) -> Void) async {
        let soqlQuery = """
            SELECT Id, Name, RE_Account__r.Name, DA_Order_Date__c, DA_Order_Delivery_Date__c, Billing_Address__c, Billing_Address_Country__c, Billing_Address_Postal_Code__c, Billing_Address_State__c, Shipping_Address_City__c, Shipping_Address_Country__c, Shipping_Address_Postal_Code__c, Shipping_Address_State__c, Shipping_Address_Street__c, Billing_Address_Street__c, RE_Account__r.Id, Total_Amount__c, Sales_Person__r.Name, RE_Price_Book__r.Name, (SELECT Id, Name, CU_List_Price__c, CU_Sales_Price__c, NU_Quantity__c, CU_Amount__c, Scheme_Code__c,CU_Amount_After_Discount__c, CU_Amount_with_GST__c, CU_Discount_Amount__c, PI_Discount__c, CU_Total_Price__c, RE_Product__r.Id, RE_Product__r.Name, Owner.Id, Owner.Name FROM Sales_Order_Line_Items__r) FROM Sales_Order__c where Id = '\(orderId)'
        """
        
        guard let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let instanceUrl = Defaults.instanceUrl else {
            completion(false)
            return
        }
        
        let fullUrl = "\(instanceUrl)/services/data/v59.0/query/?q=\(encodedQuery)"
        
        guard let url = URL(string: fullUrl) else {
            completion(false)
            return
        }
        
        do {

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            //            print("Full URL for get all customers: \(fullUrl)")
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                singleOrder.removeAll()
                salesOrderLineItemArray.removeAll()
                
                if let records = jsonData["records"] as? [[String: Any]] {
                    for record in records {
                        let customerName = (record["RE_Account__r"] as? [String: Any])?["Name"] as? String
                        let orderDate = record["DA_Order_Date__c"] as? String
                        let orderDeliveryDate = record["DA_Order_Delivery_Date__c"] as? String
                        let totalOrderAmount = record["Total_Amount__c"].flatMap { "\($0)" }
                        let salesPersonName = (record["Sales_Person__r"] as? [String: Any])?["Name"] as? String
                        let orderName = record["Name"] as? String
                        let priceBookName = (record["RE_Price_Book__r"] as? [String: Any])?["Name"] as? String
                        
                        let billingStreet = record["Billing_Address_Street__c"] as? String
                        let billingCity = record["Billing_Address__c"] as? String
                        let billingZip = record["Billing_Address_Postal_Code__c"].flatMap { "\($0)" }
                        let billingState = record["Billing_Address_State__c"] as? String
                        let billingCountry = record["Billing_Address_Country__c"] as? String
                        
                        let shippingStreet = record["Shipping_Address_Street__c"] as? String
                        let shippingCity = record["Shipping_Address_City__c"] as? String
                        let shippingZip = record["Shipping_Address_Postal_Code__c"].flatMap { "\($0)" }
                        let shippingState = record["Shipping_Address_State__c"] as? String
                        let shippingCountry = record["Shipping_Address_Country__c"] as? String
                        
                        let order = Orders(
                            customerName: customerName,
                            orderDate: orderDate,
                            totalOrderAmount: totalOrderAmount,
                            salesPersonName: salesPersonName,
                            orderName: orderName,
                            priceBookName: priceBookName,
                            orderDeliveryDate: orderDeliveryDate,
                            billingStreet: billingStreet,
                            billingCity: billingCity,
                            billingZip: billingZip,
                            billingState: billingState,
                            billingCountry: billingCountry,
                            shippingStreet: shippingStreet,
                            shippingCity: shippingCity,
                            shippingZip: shippingZip,
                            shippingState: shippingState,
                            shippingCountry: shippingCountry,
                            
                        )
                        
                        singleOrder.append(order)
                        
                        if let salesOrderLineItemsWrapper = record["Sales_Order_Line_Items__r"] as? [String: Any],
                           let salesOrderLineItems = salesOrderLineItemsWrapper["records"] as? [[String: Any]] {
                            for singleSalesOrderItem in salesOrderLineItems {
                                let item = SalesOrderLineItemsModel(
                                    Id: singleSalesOrderItem["Id"] as? String,
                                    RE_Product__r: (singleSalesOrderItem["RE_Product__r"] as? [String: Any])?["Name"] as? String,
                                    CU_List_Price__c: singleSalesOrderItem["CU_List_Price__c"].flatMap { "\($0)" },
                                    CU_Sales_Price__c: singleSalesOrderItem["CU_Sales_Price__c"].flatMap { "\($0)" },
                                    NU_Quantity__c: singleSalesOrderItem["NU_Quantity__c"].flatMap { "\($0)" },
                                    CU_Amount__c: singleSalesOrderItem["CU_Amount__c"].flatMap { "\($0)" },
                                    Scheme_Code__c: singleSalesOrderItem["Scheme_Code__c"] as? String,
                                    CU_Amount_After_Discount__c: singleSalesOrderItem["CU_Amount_After_Discount__c"].flatMap { "\($0)" },
                                    CU_Amount_with_GST__c: singleSalesOrderItem["CU_Amount_with_GST__c"].flatMap { "\($0)" },
                                    CU_Discount_Amount__c: singleSalesOrderItem["CU_Discount_Amount__c"].flatMap { "\($0)" },
                                    PI_Discount__c: singleSalesOrderItem["PI_Discount__c"] as? String,
                                    CU_Total_Price__c: singleSalesOrderItem["CU_Total_Price__c"].flatMap { "\($0)" }
                                )
                                salesOrderLineItemArray.append(item)
                            }
                        }
                    }
                }
                
                completion(true)
                
            }
            
        } catch {
            print("Error: \(error)")
            completion(false)
        }
    }
    
    //Function to get all orders based on the Customer:
    func getOrderForCustomer(_ customerId:String) async{
        let soqlQuery = """
            SELECT Id, Name, RE_Account__r.Id, RE_Account__r.Name, Sales_Person__r.Name, DA_Order_Date__c from Sales_Order__c where RE_Account__r.Id = '\(customerId)'
            """
        
        guard let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let instanceUrl = Defaults.instanceUrl else {
            
            return
        }
        
        let fullUrl = "\(instanceUrl)/services/data/v59.0/query/?q=\(encodedQuery)"
        
        guard let url = URL(string: fullUrl) else {
//            completion(false)
            return
        }
        
        do{
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let jsonDict = jsonData["records"] as? [[String: Any]] {
                for record in jsonDict {
                    let id = record["Id"] as? String
                    let customerName = (record["RE_Account__r"] as? [String: Any])?["Name"] as? String
                    let orderDate = record["DA_Order_Date__c"] as? String
                    let orderDeliveryDate = record["DA_Order_Delivery_Date__c"] as? String
                    let totalOrderAmount = String(describing: record["Total_Amount__c"] ?? "")
                    let salesPersonName = (record["Sales_Person__r"] as? [String: Any])?["Name"] as? String
                    let orderName = record["Name"] as? String
                    
                    
                    let order = Orders(
                        id:id,
                        customerName: customerName,
                        orderDate: orderDate,
                        totalOrderAmount: totalOrderAmount,
                        salesPersonName: salesPersonName,
                        orderName: orderName,
                        orderDeliveryDate: orderDeliveryDate,
                        
                    )
//                    completion(true)
                    orderForSingleCustomer.append(order)
//                    print("Array: \(orderForSingleCustomer)")
                }
            }
        }catch{
            print("Error: \(error)")
//            completion(false)
        }
        
    }
    
    
}
