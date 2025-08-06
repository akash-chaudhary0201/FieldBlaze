//
//  TabbarView.swift
//  FRATELLI
//
//  Created by Sakshi on 21/10/24.
//

import UIKit
import SideMenu

class TabbarView: UIViewController {
    
    //Home:
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var homeLabel: UILabel!
    
    //Today visits:
    @IBOutlet weak var todayVisitsImage: UIImageView!
    @IBOutlet weak var todayVisitsLabel: UILabel!
    
    //Customers:
    @IBOutlet weak var customerImage: UIImageView!
    @IBOutlet weak var customerLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    private var currentChildVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchToTab(index: 0)
    
    }
    
    @IBAction func tabButtonTapped(_ sender: UIButton){
        let tag = sender.tag
        print("Select buttons: tag: \(tag)")
        switchToTab(index: tag)
    }
    
    //Swift to tab function:
    private func switchToTab(index: Int) {
    
        if let currentVC = currentChildVC {
            currentVC.willMove(toParent: nil)
            currentVC.view.removeFromSuperview()
            currentVC.removeFromParent()
        }
        
        var storyboardName = ""
        var viewControllerID = ""
        
        switch index {
        case 0:
            storyboardName = "Home"
            viewControllerID = "HomeVC"
        case 1:
            storyboardName = "Visits"
            viewControllerID = "TodaysVisitsVC"
        case 2:
            storyboardName = "Customers"
            viewControllerID = "CustomersVC"
        default:
            return
        }
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: viewControllerID)
        
        addChild(newVC)
        newVC.view.frame = containerView.bounds
        containerView.addSubview(newVC.view)
        newVC.didMove(toParent: self)
        
        currentChildVC = newVC
    }
    
}
