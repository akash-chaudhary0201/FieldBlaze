//
//  ContactsServices.swiftD
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 09/06/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import Foundation

class ContactsServices{
    let webRequest = BaseWebService()
    let endPoint = EndPoints()
    
    public static func getContactsBasedOnAccoundId(_ accountId:String) async{
        let soqlQuery = """
                SELECT Id, Name, Email, Phone, Department,  Account.Id, Account.Name FROM Contact where AccountId = '\(accountId)'
            """
        
        guard let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let instanceUrl = Defaults.instanceUrl else {
            return
        }
        let fullUrl = "\(instanceUrl)/services/data/v59.0/query/?q=\(encodedQuery)"
        
        guard let url = URL(string: fullUrl) else{
            return
        }
        
        GlobalData.allContacts.removeAll()
        
        do{
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let records = json["records"] as? [[String:Any]]{
                for singleRecords in records{
                    GlobalData.allContacts.append(ContactsModel(dict: singleRecords))
                }
            }
        }catch{
            print("Error")
        }
    }
}
