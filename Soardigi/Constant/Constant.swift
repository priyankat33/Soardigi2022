//
//  Constant.swift
//  Netpune Security
//
//  Created by Developer on 10/04/21.
//

import Foundation
import UIKit
import CoreLocation
import KRProgressHUD

let kAuthTokenKey   =  "AuthToken"
let kIsLogin   =  "isLogin"
let kPageName   =  "PageName"
let kPageId = "PageId"
let kRoleCode = "RoleCode"
var userCoordinate:CLLocationCoordinate2D!
var currentLocation:CLLocation!
let kAppname:String =  "Soardigi"
let kEmail   =  "Email"
let kPassword   =  "Password"
let kRemeberMe   =  "RemeberMe"
//constant Color
let secondaryColor = #colorLiteral(red: 1, green: 0.6926085353, blue: 0, alpha: 1)

let primaryColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

var mainStoryboard: UIStoryboard = {
    return UIStoryboard(name: "Main", bundle: Bundle.main)
}()
func showLoader(status:Bool = false) {
    if status{
        DispatchQueue.main.async {
            KRProgressHUD.set(activityIndicatorViewColors: [secondaryColor,.black])
            KRProgressHUD.show()
        }
     }else{
        DispatchQueue.main.async {
            KRProgressHUD.dismiss()
        }
        
    }
}

enum Server {
    case live
    case local
    var serverType:String {
        switch self {
        case .live:
            return "https://trackneptune.com/api/v1/json/i/"
        case .local:
            return "http://stgapi.soardigi.in/api/auth/v1/"
            
        
        }
    }
}

struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }()
    static var isPhone:Bool {
        return UIDevice.current.userInterfaceIdiom == .phone ? true :false
    }
}
//Base URl for the Application
public let baseURL  = Server.local.serverType


func showAlertWithSingleAction1(sender:UIViewController,message:String = "",onSuccess:@escaping()->Void)  {
    
    let alertController = UIAlertController(title: kAppname, message: message, preferredStyle: .alert)
    
    // Create the actions
    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
        UIAlertAction in
        onSuccess()
        
    }
    alertController.addAction(okAction)
    sender.present(alertController, animated: true, completion: nil)
}

func showAlertWithSingleAction(sender:UIViewController,message:String = "") {
    
    let alertController = UIAlertController(title: kAppname, message: message, preferredStyle: .alert)
    
    // Create the actions
    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
        UIAlertAction in
        
        
    }
    alertController.addAction(okAction)
    sender.present(alertController, animated: true, completion: nil)
}

func showAlertWithTwoActions(sender:UIViewController,message:String = "",title:String = "",secondTitle:String = "",onSuccess:@escaping()->Void,onCancel:@escaping()->Void) {
    let alertController = UIAlertController(title: kAppname, message: message, preferredStyle: .alert)
    // Create the actions
    let okAction = UIAlertAction(title: title, style: .destructive) {
        UIAlertAction in
        onSuccess()
    }
    let cancelAction = UIAlertAction(title: secondTitle, style: .cancel) {
        UIAlertAction in
        onCancel()
    }
    
    // Add the actions
    alertController.addAction(okAction)
    alertController.addAction(cancelAction)
    sender.present(alertController, animated: true, completion: nil)
}
var accessToken:String{
    get{
        guard let accessToken = UserDefaults.NTDefault(objectForKey: kAuthTokenKey) as? String else { return "" }
        return accessToken
    }
    set{
        UserDefaults.NTDefault(setObject: newValue, forKey: kAuthTokenKey )
    }
}

var isLogin:Bool{
    get{
        guard let isLogin = UserDefaults.NTDefault(objectForKey: kIsLogin) as? Bool else { return false }
        return isLogin
    }
    set{
        UserDefaults.NTDefault(setObject: newValue, forKey: kIsLogin )
    }
}

var pageName:String {
    get{
        guard let accessToken = UserDefaults.NTDefault(objectForKey: kPageName) as? String else { return "" }
        return accessToken
    }
    set{
        UserDefaults.NTDefault(setObject: newValue, forKey: kPageName )
    }
}

var pageId:String{
    get{
        guard let accessToken = UserDefaults.NTDefault(objectForKey: kPageId) as? String else { return "" }
        return accessToken
    }
    set{
        UserDefaults.NTDefault(setObject: newValue, forKey: kPageId )
    }
}

var roleCode:String{
    get{
        guard let roleCode = UserDefaults.NTDefault(objectForKey: kRoleCode) as? String else { return "" }
        return roleCode
    }
    set{
        UserDefaults.NTDefault(setObject: newValue, forKey: kRoleCode )
    }
}

var remeberUser:String{
    get{
        guard let email = UserDefaults.NTDefault(objectForKey: kRemeberMe) as? String else { return "" }
        return email
    }
    set{
        UserDefaults.NTDefault(setObject: newValue, forKey: kRemeberMe )
    }
}

var emailRemeber:String{
    get{
        guard let email = UserDefaults.NTDefault(objectForKey: kEmail) as? String else { return "" }
        return email
    }
    set{
        UserDefaults.NTDefault(setObject: newValue, forKey: kEmail )
    }
}

var passwordRemeber:String{
    get{
        guard let password = UserDefaults.NTDefault(objectForKey: kPassword) as? String else { return "" }
        return password
    }
    set{
        UserDefaults.NTDefault(setObject: newValue, forKey: kPassword )
    }
}
