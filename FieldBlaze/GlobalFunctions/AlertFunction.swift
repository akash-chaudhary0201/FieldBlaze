//
//  AlertFunction.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary on 14/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import Foundation
import UIKit

class AlertFunction {
    public static func showErrorAlert(title: String = "Error", _ message: String, _ viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    public static func showAlertAndPop(title: String = "Success",_ message: String, _ viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            viewController.navigationController?.popViewController(animated: true)
        }

        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
