//
//  ApprovalCommentVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 08/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class ApprovalCommentVC: UIViewController {
    
    @IBOutlet weak var commentTextField: UITextField!
    var approvalResult:String?
    var approvalId:String?
    var completionHandler: (String) -> Void = {_ in}
    
    var requestBody: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("-------------------------------\(approvalResult!)")
        print("--------------------------------\(approvalId!)")
        
    }
    
    @IBAction func backAction(_ sender:UIButton){
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    @IBAction func approvalSubmitAction(_ sender: Any) {
        
        let comment = commentTextField.text ?? ""
        requestBody = [
            "requests": [
                [
                    "actionType": approvalResult == "Approve" ? "Approve" : "Reject",
                    "contextId": approvalId!,
                    "comments": comment
                ]
            ]
        ]
        
        GlobalPostRequest.commonPostFunction("v63.0/process/approvals", requestBody) { status, response in
            DispatchQueue.main.async {
                if status {
                    self.completionHandler(EMPTY)
                    print(response ?? "No response")
                    self.willMove(toParent: nil)
                    self.view.removeFromSuperview()
                    self.removeFromParent()
                } else {
                    print(response ?? "Error")
                }
            }
        }
    }
    
}
