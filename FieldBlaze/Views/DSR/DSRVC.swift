//
//  DSRVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 22/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import SwiftLoader

class DSRVC: UIViewController {
    
    @IBOutlet weak var dsrButton: UIButton!
    
    var dsrUrl:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dsrButton.isHidden = true
        
        SwiftLoaderHelper.setLoader()
        
        Task{
            await DSRService.getDRS(Defaults.userId!) { status in
                DispatchQueue.main.async {
                    if status{
                        SwiftLoader.hide()
                        self.dsrButton.isHidden = false
                        self.dsrUrl = GlobalData.dsr.first?.downloadUrl ?? "a"
                    }
                }
            }
        }
    }
    
    //Button to download dsr:
    @IBAction func downloadDSRAction(_ sender: Any) {
        SwiftLoaderHelper.setLoader()
        downloadFile(from: dsrUrl) { success, fileURL in
            DispatchQueue.main.async {
                SwiftLoader.hide()
                if success, let fileURL = fileURL {
                    let message = "DSR downloaded"
                    AlertFunction.showAlertAndPop(message, self)
                } else {
                    AlertFunction.showErrorAlert("Error in downloading DSR", self)
                }
            }
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Functiom to download file from DSRUrl:
    func downloadFile(from fullUrl: String, completion: @escaping (Bool, URL?) -> Void) {
        guard let url = URL(string: fullUrl) else {
            completion(false, nil)
            return
        }
        
        let downloadTask = URLSession.shared.downloadTask(with: url) { tempURL, response, error in
            guard let tempURL = tempURL, error == nil else {
                completion(false, nil)
                return
            }
            
            let fileName = response?.suggestedFilename ?? "DownloadedFile"
            
            let destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
            
            do {
                try? FileManager.default.removeItem(at: destination)
                
                try FileManager.default.moveItem(at: tempURL, to: destination)
                
                print("File saved to: \(destination)")
                
                completion(true, destination)
            } catch {
                print("Error moving file: \(error)")
                completion(false, nil)
            }
        }
        
        downloadTask.resume()
    }
    
}
