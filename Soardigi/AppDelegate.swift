//
//  AppDelegate.swift
//  Soardigi
//
//  Created by Developer on 17/10/22.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
        return true
    }

    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate{
    class var sharedDelegate:AppDelegate {
        return (UIApplication.shared.delegate as? AppDelegate)!
    }
}

extension AppDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
            let dict = self.separateDeeplinkParamsIn(url: url.absoluteString, byRemovingParams: nil)
            print("🔶 Paytm Callback Response: ", dict)
            // Below code is for adding mpass-events when user receives callback from to paytm app to sdk
            /* AIHandler().callGetURLRequest(mID: dict["mid"] ?? "",orderID: dict["orderId"] ?? "", eventAction: "Paytm_App_Response", eventLabel:"true" )
            var statusStr = "fail"
            if dict["status"] == "PYTM_103"{
                statusStr = "success"
                
            }
            AIHandler().callGetURLRequest(mID: dict["mid"] ?? "", orderID: dict["orderId"] ?? "", eventAction: "Response_Back",eventLabel: statusStr) */

//            let alert = UIAlertController(title: "Response", message: dict.description, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//            window?.rootViewController?.present(alert, animated: true, completion: nil)
            return true
        }

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

