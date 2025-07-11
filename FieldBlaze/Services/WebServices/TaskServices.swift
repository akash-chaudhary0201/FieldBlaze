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
    
    var allTasksArray:[TaskModel] = []
    
    var singleTask:TaskModel?
    
    //Function to get all Tasks:
    func getAllTasks(completion:@escaping(Bool) ->  Void) async{
        
        let soqlQuery = """
            select Id, Account.Name, CreatedDate, Priority,   Description, Subject from Task ORDER BY CreatedDate DESC
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
            
            allTasksArray.removeAll()
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let taskRecords = jsonData["records"] as? [[String:Any]]{
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                
                for taskRecord in taskRecords{
                    if let subject = taskRecord["Subject"] as? String,
                       let dateString = taskRecord["CreatedDate"] as? String,
                       let id = taskRecord["Id"] as? String,
                       let description = taskRecord["Description"] as? String,
                       let priority = taskRecord["Priority"] as? String{
                        
                        let isoFormatter = ISO8601DateFormatter()
                        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                        if let date = isoFormatter.date(from: dateString) {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "dd-MM-yyyy"
                            let formattedDate = formatter.string(from: date)
                            
                            let singleTask = TaskModel(subject: subject, description: description, id: id, date: formattedDate, priority: priority)
                            allTasksArray.append(singleTask)
                            completion(true)
                        } else {
                            print("Error")
                            completion(false)
                        }
                    }
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
                if let title = firstRecord["Subject"] as? String,
                   let dateString = firstRecord["CreatedDate"] as? String,
                   let description = firstRecord["Description"] as? String,
                   let priority = firstRecord["Priority"] as? String{
                    let isoFormatter = ISO8601DateFormatter()
                    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                    if let date = isoFormatter.date(from: dateString) {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd-MM-yyyy"
                        let formattedDate = formatter.string(from: date)
                        
                        completion(true)
                        return TaskModel(subject: title, description: description, id: id, date: formattedDate, priority: priority)
                    } else {
                        print("Error")
                        completion(false)
                    }
                }
            }
        }catch{
            print("Error")
            completion(false)
        }
        return nil
    }
    
    //Function to create a new task:
    func createNewTask(_ taskTitle:String, _ taskPriority:String, _ taskDescription:String, completion:@escaping(Bool) -> Void){
        guard let url = URL(string: "https://fbcom-dev-ed.develop.my.salesforce.com/services/data/v63.0/sobjects/Task") else{
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "Subject": taskTitle,
            "Priority": taskPriority,
            "Description":taskDescription
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
            completion(false)
            return
        }
        
        let task =  URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: no valid HTTP response")
                completion(false)
                return
            }
            
            if httpResponse.statusCode == 201{
                print("Task created successfully \(response!)")
                completion(true)
            }else{
                completion(false)
            }
        }
        task.resume()
    }
}
