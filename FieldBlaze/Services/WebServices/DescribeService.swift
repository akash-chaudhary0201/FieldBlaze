//
//  DescribeService.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 04/08/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import Foundation

class DescribeService{
    
    public static func getDetails() async{
        let fullUrl = "https://fbcom-dev-ed.develop.my.salesforce.com/services/data/v60.0/sobjects/Account/describe/"
        
        guard let url = URL(string: fullUrl) else {
            return
        }
        
        do{
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let fields = jsonData["fields"] as? [[String:Any]]{
                for field in fields {
                    if let label = field["label"] as? String {
                        if label == "Account Type",
                           let picklistValues = field["picklistValues"] as? [[String: Any]] {
                            for item in picklistValues {
                                if let typeLabel = item["label"] as? String {
                                    let typeModel = AccountTypeModel(accounType: typeLabel)
                                    GlobalData.accountType.append(typeModel)
                                }
                            }
                        }
                        
                        if label == "Payment Terms",
                           let picklistValues = field["picklistValues"] as? [[String: Any]] {
                            for item in picklistValues {
                                if let termLabel = item["label"] as? String {
                                    let termModel = PaymentTermsModel(paymentTermName: termLabel)
                                    GlobalData.allPaymentTerms.append(termModel)
                                }
                            }
                        }
                    }
                }
            }
        }catch{
            print("Error")
            
        }
    }
}
