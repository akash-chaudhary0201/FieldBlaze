//
//  VisitsService.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 03/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import Foundation
import UIKit

class VisitsService{
    let webRequest = BaseWebService()
    let endPoint = EndPoints()
    
    var allVisitsArray:[VisitsModel] = []
    var singleVisit:VisitsModel?
    
    //Function to get all visits:
    func getAllVisits() async{
        let soqlQuery = """
                SELECT Id, Name, Account_RE__r.Name, Visit_Approval_Status__c, CreatedDate, Zone_RE__r.Name FROM Visit__c ORDER BY CreatedDate DESC
            """
        guard let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let instanceUrl = Defaults.instanceUrl else {
            return
        }
        let fullUrl = "\(instanceUrl)/services/data/v59.0/query/?q=\(encodedQuery)"
        
        guard let url = URL(string: fullUrl) else{
            return
        }
        
        do{
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            GlobalData.allVisits.removeAll()
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let records = jsonData["records"] as? [[String:Any]]{
                for record in records {
                    GlobalData.allVisits.append(VisitsModel(dict: record))
                }
            }
        }catch{
            print("Error: \(error)")
        }
    }
    
    //Function to get details of a single visit:
    func getSingleVisitOnId(_ visitId:String) async -> VisitsModel?{
        let soqlQuery = """
                            SELECT Id, Name, Account_RE__r.Name, Visit_Approval_Status__c, Visit_Type__c,  CreatedDate, Zone_RE__r.Name FROM Visit__c where Id = '\(visitId)'
                        """
        guard let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let instanceUrl = Defaults.instanceUrl else {
            return nil
        }
        let fullUrl = "\(instanceUrl)/services/data/v59.0/query/?q=\(encodedQuery)"
        
        guard let url = URL(string: fullUrl) else{
            return nil
        }
        
        do{
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            let(data, _) = try await URLSession.shared.data(for: request)
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let visitRecords = jsonData["records"] as? [[String:Any]],
               let firstRecord = visitRecords.first{

                
                let visitModel = VisitsModel(dict: firstRecord)
                
                return visitModel
            }else {
                print("Error: No visit records found for ID: \(visitId)")
                return nil
            }
        }catch{
            print("Error")
        }
        return nil
    }
    
    //Function to create a new visit:
    func createVisit(_ visitType:String, _ date:String, _ customerId:String, completion: @escaping (Bool) -> Void){
        guard let url = URL(string: "https://fbcom-dev-ed.develop.my.salesforce.com/services/data/v63.0/sobjects/Visit__c") else{
            return
        }
        
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "Name": visitType,
            "Date_DA__c": date,
            "Account_RE__c": customerId
        ]
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: .fragmentsAllowed)
        }catch{
            print("Failed to encode request body: \(error)")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                if let responseJSON = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                    print("Visit Created Successful:")
                    print(responseJSON)
                    completion(true)
                }
            } catch {
                print("Failed to parse response: \(error)")
            }
        }
        task.resume()
    }
    
    //Function to fetch today's visit:
    func getTodaysVisit(_ date:String, completion:@escaping(_ status:Bool) -> Void)async{
        let soqlQuery = """
               select Id, Name, Account_RE__r.Name, Account_RE__r.Id, Date_DA__c,  Visit_Approval_Status__c  from Visit__c where Visit_Approval_Status__c  = 'Approved' and Date_DA__c  = \(date) ORDER BY CreatedDate DESC NULLS LAST
            """
        guard let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let instanceUrl = Defaults.instanceUrl else {
            completion(false)
            return
        }
        let fullUrl = "\(instanceUrl)/services/data/v59.0/query/?q=\(encodedQuery)"
        
        guard let url = URL(string: fullUrl) else{
            completion(false)
            return
        }
        
        do{
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            GlobalData.todaysVisits.removeAll()
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let records = jsonData["records"] as? [[String:Any]]{
                for record in records {
                    GlobalData.todaysVisits.append(VisitsModel(dict: record))
                    completion(true)
                }
            }
        }catch{
            print("Error: \(error)")
            completion(false)
        }
    }
}
