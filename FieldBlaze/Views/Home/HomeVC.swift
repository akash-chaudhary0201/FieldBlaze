//
//  HomeVC.swift
//  FieldBlaze
//
//  Created by Sakshi on 03/04/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import FSPagerView
import SideMenu
import MobileSync

class HomeVC: UIViewController {
    @IBOutlet weak var actionsCollection: UICollectionView!
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var sideMenuView: UIView?
    @IBOutlet weak var punchInView: UIView!
    @IBOutlet weak var punchButton: UIButton!
    @IBOutlet weak var pagerView: FSPagerView!
    @IBOutlet weak var punchInLabl: UILabel?
    
    var exObj = OrdersService()
    
    var isPunchedIn:Bool?
    
    var token:String?
    
    let obj = CustomerService()
    
    var imageNames = ["slider1", "slider2", "slider3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _ = DatabaseManager.shared
        
        token = UserDefaults.standard.string(forKey: "accessToken")
        print("User Id: \(Defaults.userId!)")
        
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        
        statusBarView.backgroundColor = UIColor(red: 62.0/255.0,
                                                green: 197.0/255.0,
                                                blue: 154.0/255.0,
                                                alpha: 1)
        
        view.addSubview(statusBarView)
        punchInLabl?.text = (Defaults.punchInTime?.isEmpty ?? false) ? "--" : Defaults.punchInTime
        
        if Defaults.isCheckIn!{
            punchButton.setTitle("Punch Out", for: .normal)
        }else{
            punchButton.setTitle("Punch In", for: .normal)
        }
        
        sideMenuView?.layer.cornerRadius = 20
        greenView.layer.cornerRadius = 30
        giveShadow(to: punchInView)
        punchButton.layer.cornerRadius = 25
        
        //Pager view setup :-
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        
        pagerView.isInfinite = true
        
        pagerView.automaticSlidingInterval = 3.0
        
        pagerView.interitemSpacing = -20
        pagerView.itemSize = CGSize(width: pagerView.frame.width * 0.75, height: pagerView.frame.height * 0.9)
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
    
        
    }
    
    @IBAction func menuAction() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let dashboardVC = storyboard.instantiateViewController(withIdentifier: "SideBarViewController") as! SideBarViewController
        
        // Add Top Space to SideBar
        dashboardVC.additionalSafeAreaInsets.top = 0
        
        let menu = SideMenuNavigationController(rootViewController: dashboardVC)
        menu.leftSide = true
        menu.menuWidth = UIScreen.main.bounds.width / 1.5
        menu.presentationStyle = .menuSlideIn
        menu.presentationStyle.backgroundColor = .clear
        menu.statusBarEndAlpha = 0
        
        dashboardVC.completionHandler = { textState in
            self.view.makeToast("Please check your internet connection")
        }
        
        present(menu, animated: true, completion: nil)
    }
    
    @IBAction func logoutAction() {
        let checkInalert = UIAlertController(
            title: "Confirmation",
            message: "Are you sure you want to Logout?",
            preferredStyle: .alert
        )
        self.present(checkInalert, animated: true, completion: nil)
        checkInalert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
            //            print("Cancel tapped")
        }))
        checkInalert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            Utility.logoutAction(isRedirectedToLogin: true)
        }))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        if #available(iOS 18.0, *) {
            tabBarController?.setTabBarHidden(false, animated: false)
        } else {
            
        }
        
    }
    
    //Function to give shadow :-
    func giveShadow(to view: UIView){
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 10
        view.layer.masksToBounds = false
    }
}

extension HomeVC: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return imageNames.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = UIImage(named: imageNames[index])
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
//        print("Tapped on banner at index: \(index)")
    }
}


extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actionCollectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = actionsCollection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ActionCollectionViewCell
        
        let action = actionCollectionData[indexPath.row]
        
        cell.actionLabel.text = action.actionTitle
        cell.actionImage.image = UIImage(named: action.actionImage)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let storyboardBundle = Bundle.main
            let storyboard = UIStoryboard(name: "Customers", bundle: storyboardBundle)
            let dashboardVC = storyboard.instantiateViewController(withIdentifier: "CustomersVC") as! CustomersVC
            dashboardVC.isFromHomeScreen = true
            self.navigationController?.pushViewController(dashboardVC, animated: true)
        }else if indexPath.row == 1{
            let storyboard = UIStoryboard(name: "Orders", bundle: nil)
            if let selectedVC = storyboard.instantiateViewController(withIdentifier: "OrdersVC") as? OrdersVC{
                navigationController?.pushViewController(selectedVC, animated: true)
            }
        }else if indexPath.row == 2{
            let storyboard = UIStoryboard(name: "Schemes", bundle: nil)
            if let selectedVC = storyboard.instantiateViewController(withIdentifier: "SchemeVC") as? SchemeVC{
                navigationController?.pushViewController(selectedVC, animated: true)
            }
        }else if indexPath.row == 5{
            let storyboard = UIStoryboard(name: "Approvals", bundle: nil)
            if let selectedVC = storyboard.instantiateViewController(withIdentifier: "ApprovalsVC") as? ApprovalsVC{
                navigationController?.pushViewController(selectedVC, animated: true)
            }
        }else if indexPath.row == 6{
            let storyboard = UIStoryboard(name: "Tasks", bundle: nil)
            if let selectedVC = storyboard.instantiateViewController(withIdentifier: "TasksVC") as? TasksVC{
                navigationController?.pushViewController(selectedVC, animated: true)
            }
        }else if indexPath.row == 8{
            let storyboard = UIStoryboard(name: "Beats", bundle: nil)
            if let selectedVC = storyboard.instantiateViewController(withIdentifier: "BeatsVC") as? BeatsVC{
                navigationController?.pushViewController(selectedVC, animated: true)
            }
        }else if indexPath.row == 10{
            let storyboard = UIStoryboard(name: "Stocks", bundle: nil)
            if let selectedVC = storyboard.instantiateViewController(withIdentifier: "StocksVC") as? StocksVC{
                navigationController?.pushViewController(selectedVC, animated: true)
            }
        }
        else if indexPath.row == 11{
            let storyboard = UIStoryboard(name: "Returns", bundle: nil)
            if let selectedVC = storyboard.instantiateViewController(withIdentifier: "ReturnsVC") as? ReturnsVC{
                navigationController?.pushViewController(selectedVC, animated: true)
            }
        }else if indexPath.row == 9{
            let storyboard = UIStoryboard(name: "Visits", bundle: nil)
            if let selectedVC = storyboard.instantiateViewController(withIdentifier: "AllVisitsVC") as? AllVisitsVC{
                navigationController?.pushViewController(selectedVC, animated: true)
            }
        }else if indexPath.row == 14{
            let storyboard = UIStoryboard(name: "Announcements", bundle: nil)
            if let selectedVC = storyboard.instantiateViewController(withIdentifier: "AnnouncementsVC") as? AnnouncementsVC{
                navigationController?.pushViewController(selectedVC, animated: true)
            }
        }
        
    }
    
}

class ActionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var actionImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadow()
    }
    
    private func setupShadow() {
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.3
        layer.shadowOpacity = 0.1
        layer.masksToBounds = false
    }
}

