//
//  SetTextFields.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 10/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import Foundation
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class SetTextFields{
    public static func setTextField(_ textField:MDCOutlinedTextField?, _ labelText:String?){
        textField?.label.text = labelText
        textField?.setOutlineColor(UIColor.systemGray4, for: .normal)
        textField?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        textField?.setNormalLabelColor(UIColor.systemGray4, for: .normal)
        textField?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        textField?.setLeadingAssistiveLabelColor(UIColor.red, for: .normal)
    }
}
