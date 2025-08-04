//
//  StockTrackingService.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 30/05/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//
import Foundation

class StockTrackingService{
    let webRequest = BaseWebService()
    let endPoint = EndPoints()
    
    var allStocks:[StockDetailsModel] = []
    var singleStock:StockDetailsModel?
    
    var stockLineItems:[StockLineItemsModel] = []
    
    //Function to get all stocks listed:
    public static func getAllStocks(_ userId:String) async {
        let soqlQuery = """
            SELECT Id, Account__r.Name, Account__r.Id, Date__c,Name,OwnerId FROM Inventory_Tracking__c WHERE OwnerId = '\(userId)' ORDER BY CreatedDate DESC NULLS LAST
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
            request.addValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            let(data, _) = try await URLSession.shared.data(for: request)
            
            GlobalData.allStocks.removeAll()
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let stockRecords = jsonData["records"] as? [[String:Any]]{
                
                for singleRecord in stockRecords{
                    GlobalData.allStocks.append(StockDetailsModel(dict: singleRecord))
                }
            }
        }catch{
            print("Error in fetching details", error)
        }
    }
    
    //Function to fetch single stock based on stock id:
    public static func getSingleStock(_ stockId:String) async {
        let soqlQuery = """
            SELECT Id, Name, Account__r.Name, Date__c from Inventory_Tracking__c where Id = '\(stockId)'
            """
        
        guard let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let instanceUrl = Defaults.instanceUrl else {
            return
        }
        
        let fullUrl = "\(instanceUrl)/services/data/v59.0/query/?q=\(encodedQuery)"
        
        print(fullUrl)
        
        guard let url = URL(string: fullUrl) else {
            return
        }
        
        do{
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            let(data, _) = try await URLSession.shared.data(for: request)
            
            GlobalData.allStocks.removeAll()
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let stockRecord = jsonData["records"] as? [[String:Any ]],
               let firstStock = stockRecord.first {
                GlobalData.allStocks.append(StockDetailsModel(dict: firstStock))
            }
            
        }catch{
            print("Error in fetching details", error)
        }
    }
    
    
    //Function to get all stock line items based on stock Id:s
    func getStockLineItems(_ stockId:String) async{
        let soqlQuery = """
            SELECT Id, Name,Product__c, Product__r.Name, Quantity__c FROM Available_Stock__c WHERE Inventory_Tracking__c = '\(stockId)'
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
            var request =  URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            stockLineItems.removeAll()
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let jsonData = try  JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let stockItemRecord = jsonData["records"] as? [[String:Any]]{
                print("Records---------------\(stockItemRecord)")
                for record in stockItemRecord{
                    if let itemId = record["Id"] as? String,
                       let itemName = record["Name"] as? String,
                       let productName = (record["Product__r"] as? [String: Any])?["Name"] as? String,
                       let itemQuantity = record["Quantity__c"] as? Int{
                        
                        let item = StockLineItemsModel(itemName: itemName, itemId: itemId, productName: productName, itemQuantity: itemQuantity)
                        stockLineItems.append(item)
                    }
                }
            }
            
        }catch{
            print("Error in fetching stock line items: \(error.localizedDescription)")
        }
    }
    
    //Function to get all stocks for a specific account:
    public static func getStockForAccount(_ accountId:String) async {
        let soqlQuery = """
            SELECT Id, Account__r.Name, Account__r.Id, Date__c,Name,OwnerId FROM Inventory_Tracking__c WHERE Account__r.Id = '\(accountId)' ORDER BY CreatedDate DESC NULLS LAST
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
            request.addValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            let(data, _) = try await URLSession.shared.data(for: request)
            
            GlobalData.customerStocks.removeAll()
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let stockRecords = jsonData["records"] as? [[String:Any]]{
                
                for singleRecord in stockRecords{
                    GlobalData.customerStocks.append(StockDetailsModel(dict: singleRecord))
                }
            }
        }catch{
            print("Error in fetching details", error)
        }
    }
    
}
