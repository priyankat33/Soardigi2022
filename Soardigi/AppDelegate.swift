//
//  AppDelegate.swift
//  Soardigi
//
//  Created by Developer on 17/10/22.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import AudioToolbox
import FirebaseCore
import Firebase
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
//        FirebaseApp.configure()
//        self.registerApns(application: application)
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



// MARK:- To Register Apns

extension AppDelegate {
    
    func registerApns(application: UIApplication) {
        
        if #available(iOS 10.0, *) {
            
            UIApplication.shared.delegate = self
            
            UNUserNotificationCenter.current().delegate = self
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                DispatchQueue.main.async {
                    if (granted) {
                        //self.processInitialAPNSRegistration()
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                    print("permission granted?: (granted)")
                }
            }
            
            
        }else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    //MARK: Notification Methods-
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        deviceTokenNew = Messaging.messaging().fcmToken ?? ""
        
        Messaging.messaging().token { token, error in
            fcmToken =  token ?? ""
        }
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        deviceTokenNew = token
        print("APNs token retrieved: \(token)")
     }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
}


@available(iOS 10, *)
extension AppDelegate:UNUserNotificationCenterDelegate{
    
    //Called when a notification is delivered to a foreground app.
    
   
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        // create a sound ID, in this case its the tweet sound.
        
        let systemSoundID: SystemSoundID = 1315//1003 // SMSReceived (see SystemSoundID below)
        // to play sound
        AudioServicesPlaySystemSound (systemSoundID)
        
//        if UIApplication.shared.applicationState == .active {
//            let showAction = self.didReceiveRemoteNotification(userAction: false, resRPUsernse: userInfo)
//            if showAction == true {
//                completionHandler([.alert, .badge, .sound])
//            }else{
//                guard let data = notification.request.content.userInfo as? [String:Any] else { return }
//                guard let notitype = data["notItype"] as? Int else { return  }
//
//                if notitype == 11{
//
//                }else{
//                     completionHandler([.alert,.badge, .sound])
//                }
//
//            }
//        }
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
        completionHandler([.alert, .sound])
    }
    

    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive resRPUsernse: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = resRPUsernse.notification.request.content.userInfo
        
        
//        if isFromKilled == "2"{
//            isFromKilled = "1"
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//
//                _ =  self.didReceiveRemoteNotification(userAction: true,resRPUsernse: userInfo)
//                   }
//        }else{
//
//                _ =  self.didReceiveRemoteNotification(userAction: true,resRPUsernse: userInfo)
//
//        }
        
        
      
        completionHandler()
    }
}
