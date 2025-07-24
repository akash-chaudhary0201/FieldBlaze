//
//  ProductsService.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 14/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import Foundation

class ProductsService{
    //Function to get all the products based on price book id:
    public static func getAllProductsPriceBook(_ priceBookId:String) async {
        let soqlQuery = """
            SELECT Id, Name, Product_Code__c, Product__r.Id,Product__r.Name,Product__r.Product_SKU__c, Product__r.Display_URL__c, Price_Book__r.Id,Price_Book__r.Name, CU_List_Price__c FROM Price_Book_Entry__c WHERE Price_Book__c = '\(priceBookId)' AND IsActive__c=true ORDER BY Name ASC NULLS LAST
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
            
            GlobalData.productAccordingToPB.removeAll()
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let stockRecords = jsonData["records"] as? [[String:Any]]{
                
                for singleRecord in stockRecords{
                    GlobalData.productAccordingToPB.append(FetchedProductPriceBook(dict: singleRecord))
                }
            }
        }catch{
            print("Error in fetching details", error)
        }
    }
    
    //Function to get all the products:
    public static func getAllProduct() async {
        let soqlQuery = """
             Select Id, Name from Product__c 
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
                    GlobalData.allProducts.append(FetchedProductsModel(dict: singleRecord))
                }
            }
        }catch{
            print("Error in fetching details", error)
        }
    }
}
