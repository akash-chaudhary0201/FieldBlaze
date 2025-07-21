//
//  UserService.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 18/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import Foundation

class UserService{
    public static func getLoggedInUser(_ userId:String, completion:@escaping (Bool) -> Void) async{
        let soqlQuery = """
            SELECT Id ,UserRoleId,UserRole.Name, Name from User where Id = '\(userId)'
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
        GlobalData.loggedInUserInfo.removeAll()
        do{
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let returnRecords = jsonData["records"] as? [[String:Any]]{
                
                for singleRecord in returnRecords{
                    GlobalData.loggedInUserInfo.append(UserModel(dict: singleRecord))
                }
                completion(true)
            }
            
        }catch{
            print("Error")
            completion(false)
        }
    }
}
