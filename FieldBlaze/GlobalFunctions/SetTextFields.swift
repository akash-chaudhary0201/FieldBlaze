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
import MaterialComponents.MaterialTextControls_OutlinedTextAreas

class SetTextFields{
    public static func setTextField(_ textField:MDCOutlinedTextField?, _ labelText:String?){
        textField?.label.text = labelText
        textField?.setOutlineColor(UIColor.systemGray4, for: .normal)
        textField?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        textField?.setNormalLabelColor(UIColor.systemGray4, for: .normal)
        textField?.setFloatingLabelColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        textField?.setLeadingAssistiveLabelColor(UIColor.red, for: .normal)
    }
    
    public static func setTextAreas(_ textArea:MDCOutlinedTextArea?, _ labelText:String?){
        textArea?.label.text = labelText
        textArea?.setOutlineColor(UIColor.systemGray4, for: .normal)
        textArea?.setOutlineColor(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        textArea?.setNormalLabel(UIColor.systemGray4, for: .normal)
        textArea?.setFloatingLabel(UIColor(red: 62.0 / 255.0, green: 197.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0), for: .editing)
        textArea?.translatesAutoresizingMaskIntoConstraints = false
    }
}
