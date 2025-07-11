//
//  SideBarViewController.swift
//  FRATELLI
//
//  Created by Sakshi on 28/10/24.
//

import UIKit

class SideBarViewController: UIViewController {
    var completionHandler : (String) -> Void = {_ in }
    @IBOutlet var versionLabl: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func checkInternetConnection(storyBoardName : UIViewController) {
        if InternetConnectionManager.isConnectedToNetwork(){
            navigationController?.pushViewController(storyBoardName, animated: true)
        }else{
            self.completionHandler("fd")
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func logoutAction() {
        let checkInalert = UIAlertController(
            title: "Confirmation",
            message: "Are you sure you want to Logout?",
            preferredStyle: .alert
        )
        self.present(checkInalert, animated: true, completion: nil)
        checkInalert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
            print("Cancel tapped")
        }))
        checkInalert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            Utility.logoutAction(isRedirectedToLogin: true)
        }))
    }
    
}
