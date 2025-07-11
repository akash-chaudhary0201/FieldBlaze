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
    func getAllStocks() async {
        let soqlQuery = """
            SELECT Id, Name, Account__r.Name, Date__c from Inventory_Tracking__c ORDER BY CreatedDate DESC NULLS LAST
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
            
            allStocks.removeAll()
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let stockRecords = jsonData["records"] as? [[String:Any]]{
                
                //                print(stockRecords)
                
                for singleRecord in stockRecords{
                    if let name = singleRecord["Name"] as? String,
                       let date = singleRecord["Date__c"] as? String,
                       let id = singleRecord["Id"] as? String,
                       let customerName = (singleRecord["Account__r"] as? [String:Any])?["Name"] as? String{
                        
                        let stock = StockDetailsModel(id: id, stockName: name, stockDate: date, customerName: customerName)
                        allStocks.append(stock)
                        
                    }
                }
            }
            
        }catch{
            print("Error in fetching details", error)
        }
    }
    
    //Function to fetch single stock based on stock id:
    func getSingleStock(_ stockId:String) async -> StockDetailsModel? {
        let soqlQuery = """
            SELECT Id, Name, Account__r.Name, Date__c from Inventory_Tracking__c where Id = '\(stockId)'
            """
        
        guard let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let instanceUrl = Defaults.instanceUrl else {
            return nil
        }
        
        let fullUrl = "\(instanceUrl)/services/data/v59.0/query/?q=\(encodedQuery)"
        
        print(fullUrl)
        
        guard let url = URL(string: fullUrl) else {
            return nil
        }
        
        do{
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            let(data, _) = try await URLSession.shared.data(for: request)
            
            allStocks.removeAll()
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let stockRecord = jsonData["records"] as? [[String:Any ]],
               let firstStock = stockRecord.first {
                
                let id = firstStock["Id"] as? String ?? ""
                let name = firstStock["Name"] as? String ?? ""
                let date = firstStock["Date__c"] as? String ?? ""
                let customerName = (firstStock["Account__r"] as? [String: Any])?["Name"] as? String ?? "NA"
                
                return StockDetailsModel(id: id, stockName: name, stockDate: date, customerName: customerName)
            }
            
        }catch{
            print("Error in fetching details", error)
        }
        return nil
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
    
    //Function to get all the products:
    func getAllProducts() async {
        let soqlQuery = """
            SELECT Id, Name from Product__c  
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
            
            GlobalData.allProducts.removeAll()
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let stockRecords = jsonData["records"] as? [[String:Any]]{
                
                for singleRecord in stockRecords{
                    if let name = singleRecord["Name"] as? String,
                       let id = singleRecord["Id"] as? String{
                        
                        let product = FetchedProductsModel(id: id, name: name)
                        GlobalData.allProducts.append(product)
                        
                    }
                }
            }
        }catch{
            print("Error in fetching details", error)
        }
    }
    
    //Function to create a stock:
    func createStock(_ requestBody :[String:Any]){
        guard let url = URL(string: "https://fbcom-dev-ed.develop.my.salesforce.com/services/data/v59.0/composite/tree/Inventory_Tracking__c") else{
            return
        }
        
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body:[String:Any] = requestBody
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        } catch {
            print("Failed to encode request body: \(error)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                if let responseJSON = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                    print("Stock creation successful:")
                    print(responseJSON)
                }
            } catch {
                print("Failed to parse response: \(error)")
            }
        }
        task.resume()
    }
}
