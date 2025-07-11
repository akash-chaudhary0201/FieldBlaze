//
//  SwiftLoader.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 03/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//
import UIKit
import SwiftLoader

class SwiftLoaderHelper{
    static func setLoader(){
        var config = SwiftLoader.Config()
        config.size = 100
        config.spinnerColor = UIColor(red: 35/255, green: 75/255, blue: 52/255, alpha: 255/255)
        config.backgroundColor = .white
        SwiftLoader.setConfig(config: config)
        SwiftLoader.show(title: "Loading...", animated: true)
    }
}
