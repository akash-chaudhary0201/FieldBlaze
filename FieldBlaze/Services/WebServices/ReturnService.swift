//
//  ReturnService.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 16/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import Foundation

class ReturnService{
    public static func getAllReturns(_ userId:String, completion:@escaping (Bool) -> Void) async {
        let soqlQuery = """
            SELECT Id, Date__c,Name,Account__r.Name, Account__r.Id,CreatedDate FROM Return__c WHERE OwnerId = '\(userId)' ORDER BY CreatedDate DESC NULLS LAST
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
        
        
        GlobalData.allReturns.removeAll()
        
        do{
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let returnRecords = jsonData["records"] as? [[String:Any]]{
                
                for singleRecord in returnRecords{
                    GlobalData.allReturns.append(ReturnModel(dict: singleRecord))
                }
                completion(true)
            }
            
        }catch{
            print("Error")
            completion(false)
        }
    }
    
    //Function to get return line items:
    public static func getReturnLineItems(_ returnId:String, completion:@escaping (Bool) -> Void) async{
        let soqlQuery = """
            select Id, Name, Quantity__c from Return_Item__c  where Return__r.Id = '\(returnId)' ORDER BY CreatedDate DESC NULLS LAST
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
        GlobalData.returnLineItems.removeAll()
        
        do{
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let returnRecords = jsonData["records"] as? [[String:Any]]{
                
                for singleRecord in returnRecords{
                    GlobalData.returnLineItems.append(ReturnLineItemModel(dict: singleRecord))
                }
                completion(true)
            }
            
        }catch{
            print("Error")
            completion(false)
        }
    }
    
    public static func getReturnForAccoun(_ accountId:String) async {
        let soqlQuery = """
            SELECT Id, Date__c,Name,Account__r.Name, Account__r.Id,CreatedDate FROM Return__c WHERE Account__r.Id = '\(accountId)' ORDER BY CreatedDate DESC NULLS LAST
            """
        
        guard let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let instanceUrl = Defaults.instanceUrl else {
            
            return
        }
        
        let fullUrl = "\(instanceUrl)/services/data/v59.0/query/?q=\(encodedQuery)"
        
        guard let url = URL(string: fullUrl) else {
            
            return
        }
        
        
        GlobalData.customerReturn.removeAll()
        
        do{
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let returnRecords = jsonData["records"] as? [[String:Any]]{
                
                for singleRecord in returnRecords{
                    GlobalData.customerReturn.append(ReturnModel(dict: singleRecord))
                }
                
            }
            
        }catch{
            print("Error")
            
        }
    }
}
