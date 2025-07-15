//
//  SchemeService.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 22/05/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//


import Foundation

class SchemeService{
    let webRequest = BaseWebService()
    let endPoint = EndPoints()
    
    var schemesArray:[SchemeModel] = []
    
    //Function to fetch all schemes:
    func getAllSchemes() async{
        let soqlQuery = """
            select Id, Name, Type__c, Minimum_Order_Value__c, Scheme_Code__c, Discount_Type__c, Status__c, Start_Date__c, End_Date__c, Discount_Value__c from Schemes__c
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
            
            GlobalData.allSchemes.removeAll()
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let records = jsonData["records"] as? [[String:Any]]{
                for singleScheme in records{
                    GlobalData.allSchemes.append(SchemeModel(dict: singleScheme))
                }
            }
        }catch{
            print("Error")
        }
    }
    
    
}
