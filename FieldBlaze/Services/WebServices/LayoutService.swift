//
//  LayoutService.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 31/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//
import UIKit
import Foundation

class LayoutService {
    static func getLayoutDetails(completion: @escaping ([[String: Any]]) -> Void) {
        let originalUrl = "https://fbcom-dev-ed.develop.my.salesforce.com/services/data/v59.0/ui-api/layout/Account"

        guard let url = URL(string: originalUrl) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                if let jsonData = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let sections = jsonData["sections"] as? [[String: Any]] {
                    completion(sections)
                }
            } catch {
                print("Parsing error: \(error)")
            }
        }.resume()
    }
}
