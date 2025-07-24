//
//  DSRService.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 23/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import Foundation

class DSRService{
    public static func getDRS(_ userId:String, completion:@escaping (Bool) -> Void) async {
        let fullUrl = "https://fbcom-dev-ed.develop.my.salesforce.com/services/apexrest/getAttachment?userId=\(userId)"
        
        guard let url = URL(string: fullUrl) else {
            completion(false)
            return
        }
        
        do{
            var request = URLRequest(url:url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            GlobalData.dsr.removeAll()
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                GlobalData.dsr.append(DSRModel(dict: jsonData))
                completion(true)
            }
            
        }catch{
            
        }
    }
}
