//
//  SceneDelegate.swift
//  Soardigi
//
//  Created by Developer on 17/10/22.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKCoreKit
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        sleep(3)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        if isLogin {
            if let windowScene = scene as? UIWindowScene {
                self.window = UIWindow(windowScene: windowScene)
                if isDarkMode {
                    self.window?.overrideUserInterfaceStyle = isDarkModeOn ? .light : .dark
                }
                if  ((self.window?.rootViewController) != nil)  {
                    self.window?.rootViewController = nil
                }
                if  let loginNavigationController : UITabBarController = self.getController(name:"TabViewController", storyBoard: mainStoryboard) as? UITabBarController {
                    self.window?.rootViewController = loginNavigationController
                    self.window?.makeKeyAndVisible()
                }
            }
            
        } else {
            if isDarkMode {
                self.window?.overrideUserInterfaceStyle = isDarkModeOn ? .light : .dark
            }
        }
    }
    
    
    private func getController(name identifier : String, storyBoard: UIStoryboard)->UIViewController
    {
        
        let controller:UIViewController = storyBoard.instantiateViewController(withIdentifier: identifier)as UIViewController
        return controller
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
        
        let dict = self.separateDeeplinkParamsIn(url: url.absoluteString, byRemovingParams: nil)
        print("🔶 Paytm Callback Response: ")
        let objToBeSent = dict["status"] as? String ?? ""
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: objToBeSent)
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

extension SceneDelegate {
    func separateDeeplinkParamsIn(url: String?, byRemovingParams rparams: [String]?)  -> [String: String] {
        guard let url = url else {
            return [String : String]()
        }
        
        /// This url gets mutated until the end. The approach is working fine in current scenario. May need a revisit.
        var urlString = stringByRemovingDeeplinkSymbolsIn(url: url)
        
        var paramList = [String : String]()
        let pList = urlString.components(separatedBy: CharacterSet.init(charactersIn: "&?"))
        for keyvaluePair in pList {
            let info = keyvaluePair.components(separatedBy: CharacterSet.init(charactersIn: "="))
            if let fst = info.first , let lst = info.last, info.count == 2 {
                paramList[fst] = lst.removingPercentEncoding
                if let rparams = rparams, rparams.contains(info.first!) {
                    urlString = urlString.replacingOccurrences(of: keyvaluePair + "&", with: "")
                    //Please dont interchage the order
                    urlString = urlString.replacingOccurrences(of: keyvaluePair, with: "")
                }
            }
            if info.first == "response" {
                paramList["response"] = keyvaluePair.replacingOccurrences(of: "response=", with: "").removingPercentEncoding
            }
        }
        if let trimmedURL = pList.first {
            paramList["trimmedurl"] = trimmedURL
        }
        if let status = paramList["status"] {
            paramList["statusReason"] = addStatusString(status)
        }
        return paramList
    }
    
    private func addStatusString(_ status: String) -> String {
        switch status {
        case "PYTM_100":
            return "none"
        case "PYTM_101":
            return "initiated"
        case "PYTM_102":
            return "paymentMode"
        case "PYTM_103":
            return "paymentDeduction"
        case "PYTM_104":
            return "errorInParameter"
        case "PYTM_105":
            return "error"
        case "PYTM_106":
            return "cancel"
        default:
            return ""
        }
    }
    
    func  stringByRemovingDeeplinkSymbolsIn(url: String) -> String {
        var urlString = url.replacingOccurrences(of: "$", with: "&")
        
        /// This may need a revisit. This is doing more than just removing the deeplink symbol.
        if let range = urlString.range(of: "&"), urlString.contains("?") == false{
            urlString = urlString.replacingCharacters(in: range, with: "?")
        }
        return urlString
    }
}

extension SceneDelegate {
    func logout(_ view: UIView){
        UserDefaults.NTDefault(removeObjectForKey: kIsLogin)
        UserDefaults.NTDefault(removeObjectForKey: "SaveDownloadImageModel")
        
        DispatchQueue.main.async {
            self.setUpLogin(view)
        }
    }
    
    private func setUpLogin(_ view: UIView)
    {
        if  ((self.window?.rootViewController) != nil)  {
            self.window?.rootViewController = nil
        }
        if  let loginNavigationController : UINavigationController = self.getController(name:"LoginNavigation",storyBoard: mainStoryboard) as? UINavigationController{
            view.window?.rootViewController = loginNavigationController
            view.window?.makeKeyAndVisible()
        }
    }
}
