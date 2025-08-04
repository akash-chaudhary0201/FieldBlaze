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
    
    //Function to get all orders:
    public static func getAllOrders(_ userId:String, completion:@escaping(Bool) -> Void) async {
        let soqlQuery = """
        SELECT Id, Name, RE_Account__r.Name, DA_Order_Date__c, DA_Order_Delivery_Date__c, Total_Amount__c, Sales_Person__r.Name 
        FROM Sales_Order__c   where CreatedById = '\(userId)'
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
        
        GlobalData.allOrder.removeAll()
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let jsonDict = jsonData["records"] as? [[String: Any]] {
                
                for record in jsonDict {
                    completion(true)
                    GlobalData.allOrder.append(Orders(dict: record))
                }
            }
        } catch {
            completion(false)
            print("Error: \(error)")
        }
    }
    
    //Function to get single order based on the order id:
    public static func getOrderBasedOnOrderId(_ orderId: String, completion: @escaping (Bool) -> Void) async {
        let soqlQuery = """
            SELECT Id, Name, RE_Account__r.Name, DA_Order_Date__c, DA_Order_Delivery_Date__c, Billing_Address__c, Billing_Address_Country__c, Billing_Address_Postal_Code__c, Billing_Address_State__c, Shipping_Address_City__c, Shipping_Address_Country__c, Shipping_Address_Postal_Code__c, Shipping_Address_State__c, Shipping_Address_Street__c, Billing_Address_Street__c, RE_Account__r.Id, Total_Amount__c, Sales_Person__r.Name, RE_Price_Book__r.Name, (SELECT Id, Name, CU_List_Price__c, CU_Sales_Price__c, NU_Quantity__c, CU_Amount__c, Scheme_Code__c,CU_Amount_After_Discount__c, CU_Amount_with_GST__c, CU_Discount_Amount__c, PI_Discount__c, CU_Total_Price__c, RE_Product__r.Id, RE_Product__r.Name FROM Sales_Order_Line_Items__r) FROM Sales_Order__c where Id = '\(orderId)'
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
        
        GlobalData.allOrder.removeAll()
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                
                GlobalData.salesOrderLineItem.removeAll()
                
                if let records = jsonData["records"] as? [[String: Any]] {
                    for record in records {
                        
                        GlobalData.allOrder.append(Orders(dict: record))
                        
                        if let salesOrderLineItemsWrapper = record["Sales_Order_Line_Items__r"] as? [String: Any],
                           let salesOrderLineItems = salesOrderLineItemsWrapper["records"] as? [[String: Any]] {
                            for singleSalesOrderItem in salesOrderLineItems {
                                GlobalData.salesOrderLineItem.append(SalesOrderLineItemsModel(dict: singleSalesOrderItem))
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
    public static func getOrderForCustomer(_ customerId:String) async{
        let soqlQuery = """
                   SELECT Id, Name, RE_Account__r.Name, DA_Order_Date__c, DA_Order_Delivery_Date__c, Total_Amount__c, Sales_Person__r.Name 
                   FROM Sales_Order__c where RE_Account__r.Id = '\(customerId)'
            """
        
        guard let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let instanceUrl = Defaults.instanceUrl else {
            
            return
        }
        
        let fullUrl = "\(instanceUrl)/services/data/v59.0/query/?q=\(encodedQuery)"
        
        guard let url = URL(string: fullUrl) else {
            return
        }
        
        do{
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            GlobalData.customerOrders.removeAll()
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let jsonDict = jsonData["records"] as? [[String: Any]] {
                for record in jsonDict {
                    GlobalData.customerOrders.append(Orders(dict: record))
                }
            }
        }catch{
            print("Error: \(error)")
        }
        
    }
    
    
}
