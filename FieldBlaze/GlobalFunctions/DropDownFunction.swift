//
//  DropDownFunction.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 04/06/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import Foundation
import DropDown
import UIKit

class DropDownFunction{
    
    //Drop Down function for taks
    static func setupDropDown(dropDown: DropDown, anchor: UIView, dataSource: [String], labelToUpdate: UILabel) {
        dropDown.anchorView = anchor
        dropDown.dataSource = dataSource
        dropDown.direction = .any
        
        dropDown.selectionAction = { (index: Int, item: String) in
            labelToUpdate.text = item
            labelToUpdate.textColor = .black
        }
        
        dropDown.backgroundColor = .white
        dropDown.setupCornerRadius(10)
        dropDown.textColor = .black
    }
}
