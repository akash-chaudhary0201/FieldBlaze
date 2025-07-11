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
            
            schemesArray.removeAll()
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let records = jsonData["records"] as? [[String:Any]]{
                for singleScheme in records{
                    if let Minimum_Order_Value__c = singleScheme["Minimum_Order_Value__c"],
                       let Name = singleScheme["Name"],
                       let Type__c = singleScheme["Type__c"],
                       let Scheme_Code__c = singleScheme["Scheme_Code__c"],
                       let Discount_Type__c = singleScheme["Discount_Type__c"],
                       let Status__c = singleScheme["Status__c"],
                       let End_Date__c = singleScheme["End_Date__c"],
                       let Start_Date__c = singleScheme["Start_Date__c"],
                       let Discount_Value__c = singleScheme["Discount_Value__c"]{
                        
                        let scheme = SchemeModel(
                            schemeName: Name as? String ?? "",
                            schemeType: Type__c as? String ?? "",
                            minimumOrder: "\(Minimum_Order_Value__c)",
                            discountType: Discount_Type__c as? String ?? "",
                            startDate: "\(Start_Date__c)",
                            endDate: "\(End_Date__c)",
                            discountValue: "\(Discount_Value__c)",
                            schemeCode: Scheme_Code__c as? String ?? "",
                            schemeStatus: "\(Status__c)"
                        )
                        
                        
                        schemesArray.append(scheme)
                    }
                }
//                print("-----------------------Schemes Array: \(schemesArray)")
            }
        }catch{
            print("Error")
        }
    }
    
    
}
