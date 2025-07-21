//
//  LeaveService.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 18/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import Foundation

class LeaveService{
    public static func getAllleaves(_ userId:String, completion:@escaping (Bool) -> Void) async{
        let soqlQuery = """
            SELECT Id, Name, RE_Employee__r.Name, PI_Full_Day_Half_Day__c ,OwnerId,PI_Leave_Status__c, PI_LeaveType__c, DA_StartDate__c, DA_End_Date__c, CreatedById FROM Leave__c WHERE OwnerId = '\(userId)' ORDER BY CreatedDate DESC NULLS LAST
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
        GlobalData.allLeaves.removeAll()
        do{
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let returnRecords = jsonData["records"] as? [[String:Any]]{
                
                for singleRecord in returnRecords{
                    GlobalData.allLeaves.append(LeaveModel(dict: singleRecord))
                }
                completion(true)
            }
            
        }catch{
            print("Error")
            completion(false)
        }
    }
}
