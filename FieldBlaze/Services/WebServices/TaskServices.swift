//
//  TaskServices.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 03/06/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import Foundation
import UIKit

class TaskServices{
    let webRequest = BaseWebService()
    let endPoint = EndPoints()
    
    var singleTask:TaskModel?
    
    //Function to get all Tasks:
    func getAllTasks(_ userId:String , completion:@escaping(Bool) ->  Void) async{
        
        let soqlQuery = """
            SELECT Id, Status, Priority,Description,Subject,CreatedDate FROM Task WHERE OwnerId = '\(userId)' ORDER BY CreatedDate DESC
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
            
            GlobalData.allTasks.removeAll()
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let taskRecords = jsonData["records"] as? [[String:Any]]{
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                
                for taskRecord in taskRecords{
                    GlobalData.allTasks.append(TaskModel(dict: taskRecord))
                    completion(true)
                }
            }
            
        }catch{
            print("Error: \(error)")
            completion(false)
        }
    }
    
    //Function to get a single task:
    func getSingleTask(_ id:String, completion:@escaping(Bool) -> Void) async -> TaskModel?  {
        let soqlQuery = """
            select Id, Account.Name, CreatedDate, Priority,   Description, Subject from Task where Id = '\(id)'
            """
        
        guard let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let instanceUrl = Defaults.instanceUrl else {
            return nil
        }
        
        let fullUrl = "\(instanceUrl)/services/data/v59.0/query/?q=\(encodedQuery)"
        
        guard let url = URL(string: fullUrl) else {
            return nil
        }
        
        do{
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            let(data, _) = try await URLSession.shared.data(for: request)
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let taskRecords = jsonData["records"] as? [[String:Any]],
               let firstRecord = taskRecords.first{
                completion(true)
                return TaskModel(dict: firstRecord)
            }
        }catch{
            print("Error")
            completion(false)
        }
        return nil
    }
    
}
