//
//  TabbarView.swift
//  FRATELLI
//
//  Created by Sakshi on 21/10/24.
//

import UIKit
import SideMenu

class TabbarView: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setValue(CustomTabBar(), forKey: "tabBar")
        
        tabBar.tintColor = UIColor("3EC59A", alpha: 1)
        tabBar.unselectedItemTintColor = UIColor.darkText
        tabBar.layer.cornerRadius = 20
        tabBar.layer.masksToBounds = true
        
        setupViewControllers()
    }
    
    func setupViewControllers() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home_unselected"), selectedImage: UIImage(named: "home_selected"))
        
        let VisitsStoryBoard = UIStoryboard(name: "Visits", bundle: nil)
        let visitsVC = VisitsStoryBoard.instantiateViewController(withIdentifier: "TodaysVisitsVC") as! TodaysVisitsVC
        visitsVC.tabBarItem = UITabBarItem(title: "Today Visits", image: UIImage(named: "visits_unselected"), selectedImage: UIImage(named: "visits_selected"))
        
        let CustomerStoryBoard = UIStoryboard(name: "Customers", bundle: nil)
        let customersVC = CustomerStoryBoard.instantiateViewController(withIdentifier: "CustomersVC") as! CustomersVC
        customersVC.isFromHomeScreen = false
        customersVC.tabBarItem = UITabBarItem(title: "Customers", image: UIImage(named: "customers_unselected"), selectedImage: UIImage(named: "customers_selected"))
        
        viewControllers = [homeVC, visitsVC, customersVC]
    }
}
