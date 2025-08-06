//
//  GlobalPostRequest.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 08/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import Foundation

class GlobalPostRequest{
    public static  func commonPostFunction(_ urlString:String, _ requestBody:[String:Any], completion: @escaping (_ success:Bool, _ response:Any?) -> Void){
        guard let url = URL(string: "https://fbcom-dev-ed.develop.my.salesforce.com/services/data/\(urlString)") else{
            return
        }
        
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            print("Error encoding body: \(error)")
            completion(false, nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Request error: \(error?.localizedDescription ?? "Unknown error")")
                completion(false, nil)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                completion(true, json)
            } catch {
                print("Error parsing response: \(error)")
                completion(false, nil)
            }
        }
        
        task.resume()
    }
}



import UIKit
import Foundation

class GlobalPostRequestEx {
    
    public static func commonPostFunctionEx(
        _ urlString: String,
        _ requestBody: [String: Any],
        completion: @escaping (_ success: Bool, _ statusCode: Int?, _ response: Any?) -> Void
    ) {
        let fullURLString = "https://fbcom-dev-ed.develop.my.salesforce.com/services/data/\(urlString)"
        
        guard let url = URL(string: fullURLString) else {
            completion(false, nil, nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        if let accessToken = Defaults.accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            completion(false, nil, nil)
            return
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            completion(false, nil, nil)
            return
        }
        
        // Perform the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(false, nil, nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, nil, nil)
                return
            }
            
            let statusCode = httpResponse.statusCode
            
            guard let data = data else {
                completion(false, statusCode, nil)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let isSuccess = (200...299).contains(statusCode)
                
                if isSuccess {
                    print("successful")
                    completion(true, statusCode, json)
                } else {
                    print("failed")
                    if let errorArray = json as? [[String: Any]],
                       let firstError = errorArray.first,
                       let message = firstError["message"] as? String {
                        print("Error \(message)")
                    }

                    completion(false, statusCode, json)
                }
            } catch {
                completion(false, statusCode, nil)
            }

        }
        
        task.resume()
    }
}
