//
//  AnnouncementService.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 15/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import Foundation

class AnnouncementService{
    public static func getAllnnouncements(completion:@escaping (Bool) -> Void) async{
        let soqlQuery = """
            select Id, Name, Start_Date_DA__c, End_Date_DA__c, Description_TX__c, Type_PI__c, Announcement_Image__c from Announcement__c 
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
        
        GlobalData.allAnnouncements.removeAll()
        
        do{
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            let(data, _) = try await URLSession.shared.data(for: request)
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let stockRecords = jsonData["records"] as? [[String:Any]]{
                
                for singleRecord in stockRecords{
                    GlobalData.allAnnouncements.append(AnnouncementModel(dict: singleRecord))
                }
                completion(true)
            }
        }catch{
            print("Error in fetching details", error)
            completion(false)
        }
    }
    
    //Function to get single announcement s based on id:
    public static func getSingleAnnouncement(_ annId:String) async{
        let soqlQuery = """
            select Id, Name, Start_Date_DA__c, End_Date_DA__c, Description_TX__c, Type_PI__c, Announcement_Image__c from Announcement__c where Id = '\(annId)'
            """
        
        guard let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let instanceUrl = Defaults.instanceUrl else {
            return
        }
        
        let fullUrl = "\(instanceUrl)/services/data/v59.0/query/?q=\(encodedQuery)"
        
        guard let url = URL(string: fullUrl) else {
            return
        }
        
        GlobalData.allAnnouncements.removeAll()
        
        do{
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            let(data, _) = try await URLSession.shared.data(for: request)
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let annRecord = jsonData["records"] as? [[String:Any]],
               let firstRecord = annRecord.first{
                GlobalData.allAnnouncements.append(AnnouncementModel(dict: firstRecord))
            }
        }catch{
            print("Error in fetching details", error)
        }
    }
}
