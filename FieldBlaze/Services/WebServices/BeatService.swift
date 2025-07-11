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
    
    var allBeatsArray:[BeatModel] = []
    var singleBeatArray:[BeatModel] = []
    
    func getAllBeats() async{
        let soqlQuery = """
            select Id, OwnerId,  Name, Beat_Type_PI__c, Distributor_RE__r.Name from Beat_Plan__c where ownerId = '\(Defaults.userId!)'
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
            
            allBeatsArray.removeAll()
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let beatRecords = jsonData["records"] as? [[String:Any]]{
                
                //                print(beatRecords)
                
                for record in beatRecords {
                    let id = record["Id"] as? String ?? ""
                    let name = record["Name"] as? String ?? ""
                    let beatType = record["Beat_Type_PI__c"] as? String ?? ""
                    let distributor = (record["Distributor_RE__r"] as? [String: Any])?["Name"] as? String
                    
                    let beat = BeatModel(id: id, beatName: name, beatType: beatType, distributerName: distributor ?? "NA")
                    allBeatsArray.append(beat)
                }
            }
        }catch{
            print("Error: \(error)")
        }
    }
    
    
    //Function to get single Beat:
    func getSingleBeat(_ beatId:String) async -> BeatModel? {
        let soqlQuery = """
            select Id, OwnerId, Name, Beat_Type_PI__c, Distributor_RE__r.Name from Beat_Plan__c where Id = '\(beatId)'
            """
        
        guard let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let instanceUrl = Defaults.instanceUrl else {
            return nil
        }
        
        let fullUrl = "\(instanceUrl)/services/data/v59.0/query/?q=\(encodedQuery)"
        
        guard let url = URL(string: fullUrl) else {
            return nil
        }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let beatRecords = jsonData["records"] as? [[String: Any]],
               let record = beatRecords.first {
                
                let id = record["Id"] as? String ?? ""
                let name = record["Name"] as? String ?? ""
                let beatType = record["Beat_Type_PI__c"] as? String ?? ""
                let distributor = (record["Distributor_RE__r"] as? [String: Any])?["Name"] as? String ?? "NA"
                
                return BeatModel(id: id, beatName: name, beatType: beatType, distributerName: distributor)
            }
        } catch {
            print("Error: \(error)")
        }
        return nil
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
}
