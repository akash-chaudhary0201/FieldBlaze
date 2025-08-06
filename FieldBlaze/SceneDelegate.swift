/*
Copyright (c) 2019-present, salesforce.com, inc. All rights reserved.

Redistribution and use of this software in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:
* Redistributions of source code must retain the above copyright notice, this list of conditions
and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of
conditions and the following disclaimer in the documentation and/or other materials provided
with the distribution.
* Neither the name of salesforce.com, inc. nor the names of its contributors may be used to
endorse or promote products derived from this software without specific prior written
permission of salesforce.com, inc.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import UIKit
//import SwiftUI
import MobileSync
import SalesforceSDKCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var navigationController : UINavigationController?
    private(set) static var shared: SceneDelegate?
    
    // MARK: - UISceneDelegate Implementation
    
    func scene(_ scene: UIScene,
               openURLContexts urlContexts: Set<UIOpenURLContext>)
    {
    }
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions)
    {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        self.window?.windowScene = windowScene
        AuthHelper.registerBlock(forCurrentUserChangeNotifications: {
            self.resetViewState {
                self.redirectCheckInScreen()
            }
        })
        self.redirectCheckInScreen()
        
        if let urlContext = connectionOptions.urlContexts.first {
            useQrCodeLogInUrl(urlContext.url)
        }
    }
    
    static func getSceneDelegate() -> SceneDelegate {
        return UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
       
    }

    func sceneWillResignActive(_ scene: UIScene) {
       
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        self.initializeAppViewState()
        AuthHelper.loginIfRequired {
            self.redirectCheckInScreen()
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
       
    }
    
   func initializeAppViewState() {
       if (!Thread.isMainThread) {
           DispatchQueue.main.async {
               self.initializeAppViewState()
           }
           return
       }
       self.window?.rootViewController = InitialViewController(nibName: nil, bundle: nil)
       self.window?.makeKeyAndVisible()
   }
   
    func redirectCheckInScreen() {
        MobileSyncSDKManager.shared.setupUserStoreFromDefaultConfig()
        MobileSyncSDKManager.shared.setupUserSyncsFromDefaultConfig()
        self.window?.makeKeyAndVisible()
//        window?.overrideUserInterfaceStyle = .light
//        setupStatusBarBackgroundColor()
        if Defaults.isCheckIn ?? false {
            Utility.gotoTabbar()
        } else {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let checkInVC = storyboard.instantiateViewController(withIdentifier: "CheckInVC") as! CheckInVC
            let navController = UINavigationController(rootViewController: checkInVC)
            self.window?.rootViewController = navController
        }
    }
    
    private func resetViewState(completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            self.window?.rootViewController = nil
            completion()
        }
    }
    
    private func useQrCodeLogInUrl(_ url: URL) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        if (appDelegate.isQrCodeLoginUsingReferenceUrlFormat) {
            
            guard let components = NSURLComponents(
                url: url,
                resolvingAgainstBaseURL: true),
                  let scheme = components.scheme,
                  scheme == appDelegate.qrCodeLoginUrlScheme,
                  let host = components.host,
                  host == appDelegate.qrCodeLoginUrlHost,
                  let path = components.path,
                  path == SalesforceLoginViewController.qrCodeLoginUrlPath,
                  let queryItems = components.queryItems,
                  let _ = queryItems.first(where: { $0.name == SalesforceLoginViewController.qrCodeLoginUrlJsonParameterName })?.value else {
                SFSDKCoreLogger().e(classForCoder, message: "Invalid QR code log in URL.")
                return
            }
            let _ = LoginTypeSelectionViewController.loginWithFrontdoorBridgeUrlFromQrCode(url.absoluteString)
        } else {
            let frontdoorBridgeUrl = "your-qr-code-login-frontdoor-bridge-url"
            let pkceCodeVerifier = "your-qr-code-login-pkce-code-verifier"
            assert(frontdoorBridgeUrl != "your-qr-code-login-frontdoor-bridge-url", "Please implement your app's frontdoor bridge URL retrieval.")
            assert(pkceCodeVerifier != "your-qr-code-login-pkce-code-verifier", "Please add your app's PKCE code verifier retrieval if web server flow is used.")
            let _ = LoginTypeSelectionViewController.loginWithFrontdoorBridgeUrl(
                frontdoorBridgeUrl,
                pkceCodeVerifier: pkceCodeVerifier
            )
        }
    }
}
