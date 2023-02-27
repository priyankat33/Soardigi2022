//
//  HomeVC.swift
//  Soardigi
//
//  Created by Developer on 13/11/22.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Alamofire
class HomeVC: UIViewController, SliderCollectionCell {
    func didPressedSlide(value: String) {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "HomeDetailVC") as! HomeDetailVC
                vc.id = value
        vc.subCatId = ""
                self.navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate var homeViewModel:HomeViewModel = HomeViewModel()
    @IBOutlet weak fileprivate var tableView:UITableView!
    @IBOutlet weak fileprivate var lblBusinessName:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        
            

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        homeViewModel.getMainHomeData(sender: self, onSuccess: {
            self.lblBusinessName.text = self.homeViewModel.businessName
            self.tableView.reloadData()
        }, onFailure: {
            
        })
    }
    
    @IBAction func onClickBusinessName(_ sender:UIButton) {
//        let vc = mainStoryboard.instantiateViewController(withIdentifier: "ShowBusinessCategoryDetailVC") as! ShowBusinessCategoryDetailVC
//        vc.businessName = lblBusinessName.text ?? ""
//        vc.categoryName = homeViewModel.categoryName
//        vc.businessImage = homeViewModel.businessImage
//        vc.id = homeViewModel.bussinessId
//        self.present(vc, animated: true, completion: nil)
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let fileURL = documentsURL?.appendingPathComponent("duck.png")
            return (fileURL!, [.removePreviousFile, .createIntermediateDirectories])
        }

        
        Alamofire.download("https://httpbin.org/image/png", to: destination).responseData { response in
            if let destinationUrl = response.destinationURL {
                print(destinationUrl)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onClickForward(_ sender:UIButton) {
        let value = sender.tag
       
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "HomeDetailVC") as! HomeDetailVC
                vc.id = homeViewModel.homeCategoryResponseModel[value].id ?? ""
        vc.subCatId = ""
                self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func onClickImage(_ sender:UIButton) {
        let value = sender.tag
       
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "HomeDetailVC") as! HomeDetailVC
        vc.id = homeViewModel.homeCategoryResponseModel[value].id ?? ""
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate, collectionCell_delegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeViewModel.homeCategoryResponseModel.count + 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SliderTVC", for: indexPath) as! SliderTVC
            cell.sliderCollectionCell = self
            cell.homeSliderResponseModel = homeViewModel.homeSliderResponseModel
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTVC", for: indexPath) as! CategoryTVC
            cell.imageResponseModel = homeViewModel.homeCategoryResponseModel[indexPath.section - 1].categoryImagesResponseModel
            cell.sectionValue = indexPath.section - 1
            cell.deleg = self
            cell.parent = self
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return CGFloat(UIScreen.main.bounds.height/3)
        } else {
            return 128
        }
       
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if section != 0 {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "SectionHeadingCell") as! SectionHeadingCell
            headerCell.forwardBtn.tag = section - 1
            headerCell.headingLBL.text = homeViewModel.homeCategoryResponseModel[section-1].title ?? ""
            return headerCell
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section != 0 ? 35.0 : 0.0
    }
    
    func didPressed(value: String,sectionValue:Int) {
            
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "HomeDetailVC") as! HomeDetailVC
                vc.id = homeViewModel.homeCategoryResponseModel[sectionValue].id ?? ""
        vc.subCatId = value
                self.navigationController?.pushViewController(vc, animated: true)
        }
}



enum FacebookPermissions:String {
    case email = "email"
    case publicProfile = "public_profile"
   
}



class FacebookLogin: NSObject {
    
    //MARK:- Facebook Login Methods
    func facebookLogin(withController:UIViewController,success:@escaping (_ finish: Bool,_ user:FacebookUserData) -> ()) {
        let fbLoginManager : LoginManager = LoginManager()
        //fbLoginManager.loginBehavior = LoginBehavior.browser
        fbLoginManager.logOut()
        fbLoginManager.logIn(permissions: [FacebookPermissions.publicProfile.rawValue,FacebookPermissions.email.rawValue,"pages_show_list","pages_read_engagement","publish_video","pages_manage_posts"], from: withController) { (result, error) in
            if error != nil{
                print(error.debugDescription)
                // Calling back to previous class if error occured
                success(false,error as! FacebookUserData)
                return
            }
            
            let FBLoginResult: LoginManagerLoginResult = result!
            
            if FBLoginResult.isCancelled{
                print("User cancelled the login process")
            }else if FBLoginResult.grantedPermissions.contains(FacebookPermissions.email.rawValue){
                self.getFBUserData(success: {(finish,user) in
                    if finish {
                        success(true,user)
                        return
                    }
                    success(false,user)
                })
            }
        }
        //success(true)
    }
    
    private func getFBUserData(success: @escaping(_ finished: Bool,_ user:FacebookUserData)-> ()){
        if (AccessToken.current != nil) {
            let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields" : "id, first_name, last_name, email, gender,friends"])
            let connection = GraphRequestConnection()
            connection.add(graphRequest, completion: { (connection, result, error) -> Void in
                let data = result as! [String : AnyObject]
                let accessToken = AccessToken.current?.tokenString ?? ""
                let email = (data["email"] as? String) ?? ""
                let snsId = (data["id"] as? String) ?? ""
                let firstName = (data["first_name"] as? String) ?? ""
                let lastName = (data["last_name"] as? String) ?? ""
                let url = "https://graph.facebook.com/\(snsId)/picture?type=large&return_ssl_resources=1"
                let profilePicure = url
                let user = FacebookUserData(id: snsId, email: email, firstName: firstName, lastName: lastName, profilePic: profilePicure,fbAccessToken:accessToken)
                success(true,user)
            })
            connection.start()
        }
    }
    
    func logoutFB() {
        // let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        let loginManager = LoginManager()
        loginManager.logOut()
        
        URLCache.shared.removeAllCachedResponses()
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
}
struct FacebookUserData {
    var id :String! = ""
    var email:String! = ""
    var firstName:String! = ""
    var lastName:String! = ""
    var profilePic:String! = ""
    var fbAccessToken:String! =  ""
}

