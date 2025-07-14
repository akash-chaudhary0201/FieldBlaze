//
//  PriceBook.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 14/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import Foundation
import UIKit

class PriceBookService{
    
    //--------------------------------------FUNCTION FOR PRICEBOOK, ZONE and PAYMENT TERMS------------------------------------------------
    public static func getPriceBookNames() async{
        let soqlQuery = "Select Id, Name from Price_Book__c"
        
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
            
            GlobalData.allPriceBooks.removeAll()
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let records = jsonData["records"] as? [[String:Any]]{
                for record in records{
                    GlobalData.allPriceBooks.append(PriceBookModel(dict: record))
                }
            }
        }catch{
            print("Error: \(error)")
        }
    }
}
