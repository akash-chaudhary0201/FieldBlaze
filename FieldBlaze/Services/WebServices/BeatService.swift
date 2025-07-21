//
//  BeatService.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 22/05/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import Foundation

class BeatService{
    let webRequest = BaseWebService()
    let endPoint = EndPoints()
    
    //Function to get all beats:
    public static func getAllBeats() async{
        let soqlQuery = """
            select Id, OwnerId,  Name, Beat_Type_PI__c, Distributor_RE__r.Name, Zone_RE__r.Name from Beat_Plan__c where ownerId = '\(Defaults.userId!)' ORDER BY CreatedDate DESC NULLS LAST
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
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            GlobalData.allBeats.removeAll()
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let beatRecords = jsonData["records"] as? [[String:Any]]{
                
                for record in beatRecords {
                    GlobalData.allBeats.append(BeatModel(dict: record))
                }
            }
        }catch{
            print("Error: \(error)")
        }
    }
    
    //Function to create a new beat:
    func createBeatPlan(_ requestBody :[String:Any], completion:@escaping (Bool) -> Void){
        guard let url = URL(string: "https://fbcom-dev-ed.develop.my.salesforce.com/services/data/v52.0/composite/tree/Beat_Plan__c") else{
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
                    completion(true)
                }
            } catch {
                print("Failed to parse response: \(error)")
            }
        }
        task.resume()
    }
    
    //Function to get assigned accounts to a beat:
    public static func getAllAssignedAccounts(_ beatId:String) async{
        let soqlQuery = """
            SELECT Id, Name, Account_RE__r.Name, Beat_Plan_RE__r.Zone_RE__c, Beat_Plan_RE__r.Zone_RE__r.Name 
                FROM Assigned_Customer__c  WHERE Beat_Plan_RE__c = '\(beatId)'
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
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            GlobalData.assignedAccounts.removeAll()
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let beatRecords = jsonData["records"] as? [[String:Any]]{
                
                for record in beatRecords {
                    GlobalData.assignedAccounts.append(AssignedAccountModel(dict: record))
                }
            }
        }catch{
            print("Error: \(error)")
        }
    }
    
}
