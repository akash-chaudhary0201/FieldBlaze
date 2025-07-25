//
//  Utility.swift
//  FRATELLI
//
//  Created by Sakshi on 21/10/24.
//

import UIKit
import AssetsLibrary
import AVFoundation

class Utility {
    static var tabbarView: TabbarView?
    static var isMenuOpen : Bool = false
    static var isFromHome : Bool = false
    static var fromOtherScreen : Bool = false
    static var button = UIButton()
    static var containerController : UIViewController?
    static var presentController : UIViewController?
    
    func getActualValue(key : String, dict : [String : Any]) -> String {
        if dict[key] is String {
            return dict[key] as! String
        } else if dict[key] is Int {
            return String(dict[key] as! Int)
        } else if dict[key] is Float {
            return String(format: "%.2f", dict[key] as! Float)
        } else if dict[key] is Double {
            return String(format: "%.2f", dict[key] as! Double)
        } else if dict[key] is Bool {
            return String(dict[key] as! Bool)
        } else {
            return EMPTY
        }
    }
    
    static func getConvertedPoint(_ targetView: UIView, baseView: UIView?) -> CGPoint {
        var pnt = targetView.frame.origin
        if nil == targetView.superview {
            return pnt
        }
        var superView = targetView.superview
        while superView != baseView {
            pnt = superView!.convert(pnt, to: superView!.superview)
            if nil == superView!.superview {
                break
            } else {
                superView = superView!.superview
            }
        }
        return superView!.convert(pnt, to: baseView)
    }
    
    static func gotoTabbar() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Tabbar", bundle:nil)
        tabbarView = storyBoard.instantiateViewController(withIdentifier: "TabbarView") as? TabbarView
        SceneDelegate.getSceneDelegate().navigationController = UINavigationController(rootViewController: tabbarView ?? TabbarView())
        SceneDelegate.getSceneDelegate().navigationController?.isNavigationBarHidden = true
        SceneDelegate.getSceneDelegate().window!.rootViewController = SceneDelegate.getSceneDelegate().navigationController
    }
    
    static func logoutAction(isRedirectedToLogin: Bool = true) {
        Defaults.isUserLoggedIn = false
        Defaults.userMobileNumber = EMPTY
        Defaults.accessToken = EMPTY
        Defaults.userId = EMPTY
        Defaults.userName = EMPTY
        Defaults.userEmail = EMPTY
        Defaults.removeUserImage()
        Defaults.userId = EMPTY
        if isRedirectedToLogin {
            self.gotoLoginView()
        }
    }
    
    static func gotoLoginView() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "CheckInVC") as! CheckInVC
        SceneDelegate.getSceneDelegate().navigationController = UINavigationController(rootViewController: viewController)
        SceneDelegate.getSceneDelegate().navigationController?.isNavigationBarHidden = true
        SceneDelegate.getSceneDelegate().window!.rootViewController = SceneDelegate.getSceneDelegate().navigationController
    }

    static func getUniqueName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmssSSSS"
        let dateString = dateFormatter.string(from: Date())
        return dateString
    }
    
    static func getStatus(responseCode: Int) -> ResponseStatus {
        switch responseCode {
        case 200, 201, 203, 204:
            return ResponseStatus.success
        case 409:
            return ResponseStatus.alreadyRegister
        case 500:
            return ResponseStatus.error
        case 401:
            return ResponseStatus.tokenExpired
        case 400:
            return ResponseStatus.badRequest
        default:
            return ResponseStatus.error
        }
    }
    
    static func setRightViewController(containerController: UIViewController, childViewController : UIViewController, isAnimated : Bool, fromOtherSCreen : Bool = false ) {
        self.fromOtherScreen = fromOtherSCreen
        presentController = childViewController
        removeAllChildController(containerController: containerController)
        let navigationController = UINavigationController(rootViewController: childViewController)
        navigationController.isNavigationBarHidden = true
        containerController.addChild(navigationController)
        containerController.view.addSubview(navigationController.view)
        navigationController.view.dropShadow(color: UIColor.black, opacity: 1.0, offSet: CGSize(width: -1, height: 1), radius:0.0, scale: true)
        navigationController.didMove(toParent: containerController)
        isMenuOpen = false
        if isAnimated {
            navigationController.view.frame.origin.x = getSideMenuWidth()
            UIView.animate(withDuration: 0.2, animations: {
                navigationController.view.frame.origin.x = 0
            })
        }
    }
    
    static func tokenExpiredAction() {
        
    }
    
    static func removeAllChildController(containerController: UIViewController) {
        for(_, controller) in containerController.children.enumerated() {
            controller.removeFromParent()
            controller.view.removeFromSuperview()
        }
    }
    
    static var overlayView: UIView?
    static var sideBarVC: SideBarViewController?

    static func gotoSideMenu(containerController: UIViewController, isFromHome: Bool = false) {
        fromOtherScreen = false
        self.containerController = containerController
        self.isFromHome = isFromHome
        if isMenuOpen && !isFromHome {
            UIView.animate(withDuration: 0.3, animations: {
                sideBarVC?.view.frame.origin.x = -getSideMenuWidth()
                overlayView?.alpha = 0
            }) { _ in
                sideBarVC?.view.removeFromSuperview()
                sideBarVC?.removeFromParent()
                overlayView?.removeFromSuperview()
                overlayView = nil
                self.isMenuOpen = false
            }
        } else {
            overlayView = UIView(frame: containerController.view.bounds)
            overlayView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            overlayView?.alpha = 0
            containerController.view.addSubview(overlayView!)
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            guard let sideMenu = storyboard.instantiateViewController(withIdentifier: "SideBarViewController") as? SideBarViewController else {
                print("Failed to load SideBarViewController")
                return
            }
            self.sideBarVC = sideMenu
            sideMenu.view.frame = CGRect(x: -getSideMenuWidth(), y: 35, width: getSideMenuWidth(), height: containerController.view.frame.height)
            containerController.addChild(sideMenu)
            containerController.view.addSubview(sideMenu.view)
            sideMenu.didMove(toParent: containerController)
            UIView.animate(withDuration: 0.3, animations: {
                sideMenu.view.frame.origin.x = 0
                overlayView?.alpha = 1
            })
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSideMenu))
            overlayView?.addGestureRecognizer(tapGesture)

            self.isMenuOpen = true
        }
    }

    @objc static func dismissSideMenu() {
        if !fromOtherScreen {
            guard containerController != nil else { return }
            
            UIView.animate(withDuration: 0.3, animations: {
                sideBarVC?.view.frame.origin.x = -getSideMenuWidth()
                overlayView?.alpha = 0
            }) { _ in
                sideBarVC?.view.removeFromSuperview()
                sideBarVC?.removeFromParent()
                overlayView?.removeFromSuperview()
                overlayView = nil
                self.isMenuOpen = false
            }
        }
    }

    static func getSideMenuWidth() -> CGFloat {
        return 250.0
    }

    
}

