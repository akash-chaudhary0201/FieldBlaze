//
//  ApprovalService.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 08/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import Foundation

class ApprovalService{
    let webRequest = BaseWebService()
    let endPoint = EndPoints()
    
    func getAlApprovalRequest(completion:@escaping(_ status:Bool) -> Void) async{
        let soqlQuery = """
                SELECT ActorId, CreatedById, CreatedBy.Name,CreatedDate, Id, OriginalActorId, ProcessInstanceId, ProcessInstance.Status, ProcessInstance.ProcessDefinition.Name, ProcessInstance.SubmittedById,ProcessInstance.TargetObjectId,ProcessInstance.TargetObject.Type, ProcessInstance.TargetObject.Name FROM ProcessInstanceWorkitem  ORDER BY CreatedDate DESC NULLS LAST
            """
        guard let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let instanceUrl = Defaults.instanceUrl else {
            completion(false)
            return
        }
        let fullUrl = "\(instanceUrl)/services/data/v59.0/query/?q=\(encodedQuery)"
        
        guard let url = URL(string: fullUrl) else{
            completion(false)
            return
        }
        
        GlobalData.allApprovalRequest.removeAll()
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let approvalArray = json["records"] as? [[String:Any]]{
                for approvalDict in approvalArray{
                    GlobalData.allApprovalRequest.append(Approvals(dict: approvalDict))
                    completion(true)
                }
            }
        }catch{
            print("Error")
            completion(false)
        }
    }
}
