//
//  ExpenseService.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 21/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import Foundation

class ExpenseService{
    public static func getAllExpenses(_ userId:String, completion:@escaping (Bool) -> Void) async{
        let soqlQuery = """
            Select Id, Name, CreatedBy.Name, Start_Date__c, End_Date__c, OwnerId, Approval_Status__c from Expenses__c where OwnerId = '\(userId)'  ORDER BY CreatedDate DESC NULLS LAST
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
        GlobalData.allExpenses.removeAll()
        do{
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let returnRecords = jsonData["records"] as? [[String:Any]]{
                
                for singleRecord in returnRecords{
                    GlobalData.allExpenses.append(ExpenseModel(dict: singleRecord))
                }
                completion(true)
            }
            
        }catch{
            print("Error")
            completion(false)
        }
    }
}
