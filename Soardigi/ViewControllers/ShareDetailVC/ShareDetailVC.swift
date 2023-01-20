//
//  ShareDetailVC.swift
//  Soardigi
//
//  Created by Developer on 05/01/23.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
class ShareDetailVC: UIViewController {
    var typeSelected:Int = 0
    fileprivate var pageAccessToken:String = ""
    fileprivate var fbPageData:[FBPageData] = [FBPageData]()
    var selectedImageURL:String = ""
    fileprivate var pageID:String = ""
    fileprivate let facebookLogin = FacebookLogin()
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak fileprivate var imageView:UIImageView!
    var image:UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        let w1 = self.imageView.bounds.width
        let h1  = CGFloat(1600)/CGFloat(1600) * w1
        DispatchQueue.main.async {
            self.imageHeightConstraint.constant = h1
        }
        imageView.image = image
    }
}

extension ShareDetailVC {
    @IBAction func onClickConnect(_ sender:UIButton) {
        if AccessToken.current?.tokenString != nil {
            showLoader(status: true)
            let graphRequest
            = GraphRequest(graphPath: "/me/accounts?fields=access_token,name", parameters: ["access_token":AccessToken.current?.tokenString])
            graphRequest.start( completion: { [self] (connection, result, error)-> Void in
                if ((error) != nil)
                {
                    print("Error: \(error)")
                }
                else
                {
                    
                    let array = ((result as! NSDictionary).value(forKey: "data") as! NSArray)
                    if array.count > 0 {
                        showLoader()
                        for tokens in array {
                            let tkn = ((tokens as! NSDictionary).value(forKey: "access_token")) as! String
                            let id = ((tokens as! NSDictionary).value(forKey: "id")) as! String
                            let name = ((tokens as! NSDictionary).value(forKey: "name")) as! String
                            fbPageData.append(FBPageData(name: name, id: id, accessToken: tkn))
                        }
                        let vc = mainStoryboard.instantiateViewController(withIdentifier: "FacebookShareVC") as! FacebookShareVC
                        vc.fbPageData = self.fbPageData
                        vc.dataUrl = selectedImageURL
                        vc.typeSelected = typeSelected
                        self.present(vc, animated: true, completion: nil)
                    } else {
                        showLoader()
                        showAlertWithSingleAction(sender: self, message: "No page found")
                    }
                    
                    print(fbPageData)
                }
                
            })
        } else {
            facebookLogin.facebookLogin(withController:self) { (success,user) in
                print("THE FACEBOOK USER IS------>",user)
                
                showLoader(status: true)
                //"https://graph.facebook.com/{user-id}/accounts
                //?access_token={user-access-token}"
                let graphRequest
                = GraphRequest(graphPath: "/me/accounts?fields=access_token,name", parameters: ["access_token":AccessToken.current?.tokenString ?? ""])
                graphRequest.start( completion: { [self] (connection, result, error)-> Void in
                    if ((error) != nil)
                    {
                        print("Error: \(error)")
                    }
                    else
                    {
                        let array = ((result as! NSDictionary).value(forKey: "data") as! NSArray)
                        if array.count > 0 {
                            showLoader()
                            for tokens in array {
                                let tkn = ((tokens as! NSDictionary).value(forKey: "access_token")) as! String
                                let id = ((tokens as! NSDictionary).value(forKey: "id")) as! String
                                let name = ((tokens as! NSDictionary).value(forKey: "name")) as! String
                                fbPageData.append(FBPageData(name: name, id: id, accessToken: tkn))
                            }
                            let vc = mainStoryboard.instantiateViewController(withIdentifier: "FacebookShareVC") as! FacebookShareVC
                            vc.fbPageData = self.fbPageData
                            vc.dataUrl = selectedImageURL
                            vc.typeSelected = typeSelected
                            self.present(vc, animated: true, completion: nil)
                        } else {
                            showLoader()
                            showAlertWithSingleAction(sender: self, message: "No page found")
                        }
                        print(fbPageData)
                    }
                    
                })
                //}
            }
        }
    }
}

struct FBPageData {
    var  name, id, accessToken:String?
}
