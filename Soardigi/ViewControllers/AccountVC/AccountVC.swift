//
//  AccountVC.swift
//  Soardigi
//
//  Created by Developer on 09/01/23.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
class AccountVC: UIViewController {
    fileprivate var homeViewModel:HomeViewModel = HomeViewModel()
    @IBOutlet weak var nameLBL:UILabel!
    @IBOutlet weak var emailLBL:UILabel!
    @IBOutlet weak var subsLBL:UILabel!
    @IBOutlet weak var pointsLBL:UILabel!
    @IBOutlet weak var coeLBL:UILabel!
    @IBOutlet weak var imgView:CustomImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onClickFacebookLogout(_ sender:UIButton) {

        showAlertWithTwoActions(sender: self, message: "Are you sure want to logout from facebook?", title: "Yes", secondTitle: "No", onSuccess: {
            let fbLoginManager = LoginManager()
                fbLoginManager.logOut()
                let cookies = HTTPCookieStorage.shared
                let facebookCookies = cookies.cookies(for: URL(string: "https://facebook.com/")!)
                for cookie in facebookCookies! {
                    cookies.deleteCookie(cookie )
                }
            pageName = ""
            pageId = ""
        }, onCancel: {
            
        })
    }
    
    @IBAction func onClickProfile(_ sender:UIButton) {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        vc.userResponseModel = self.homeViewModel.userResponseModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickBusiness(_ sender:UIButton) {
        
    }
    
    @IBAction func onClickPreffredLanguage(_ sender:UIButton) {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "PreferredLanguageVC") as! PreferredLanguageVC
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func onClickThemeChange(_ sender:UIButton) {
//        let window = UIApplication.shared.keyWindow
//        window?.overrideUserInterfaceStyle = .light
        
        showAlertWithSingleAction(sender: self, message: "Coming Soon")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeViewModel.getUserProfile(sender: self, onSuccess: {
            
            self.imgView.kf.indicatorType = .activity
            self.imgView.kf.setImage(with: URL(string: self.homeViewModel.userResponseModel?.profile ?? ""), placeholder: nil, options: nil) { result in
                switch result {
                case .success(let value):
                    print("Image: \(value.image). Got from: \(value.cacheType)")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
            self.nameLBL.text =  self.homeViewModel.userResponseModel?.name ?? ""
            self.emailLBL.text =  self.homeViewModel.userResponseModel?.email ?? ""
            self.coeLBL.text =  "Referral Code: \(self.homeViewModel.userResponseModel?.ref_code ?? "")"
            self.pointsLBL.text = "Point: \( self.homeViewModel.userResponseModel?.points ?? 0)"
        }, onFailure: {
            
        })
    }
    
    @IBAction func onClickLogout(_ sender:UIButton) {
       showAlertWithTwoActions(sender: self, message: "Are you sure want to logout?", title: "Yes", secondTitle: "No", onSuccess: {
           self.homeViewModel.userLogout(sender: self, onSuccess: {
               SceneDelegate().logout(self.view)
           }, onFailure: {
               
           })
       }, onCancel: {
           
       })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
