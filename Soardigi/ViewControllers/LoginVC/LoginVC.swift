//
//  LoginVC.swift
//  Soardigi
//
//  Created by Developer on 17/10/22.
//
enum SelectedType {
    case mobile
    case email
    
    var value: String? {
        switch self {
        case .email: return "0"
        case .mobile: return "1"
        }
    }
}
import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
class LoginVC: UIViewController {
    
    //outlets
    @IBOutlet weak fileprivate var loginEmail:CustomButton!
    @IBOutlet weak fileprivate var loginPhone:CustomButton!
    @IBOutlet weak fileprivate var view1:CustomView!
    @IBOutlet weak fileprivate var view2:CustomView!
    @IBOutlet weak fileprivate var countryFlag:UIImageView!
    @IBOutlet weak fileprivate var view3:CustomView!
    @IBOutlet weak fileprivate var phoneTF:CustomTextField!
    @IBOutlet weak fileprivate var emailTF:CustomTextField!
    @IBOutlet weak fileprivate var mobileTF:CustomTextField!
    fileprivate var userViewModel: UserViewModel = UserViewModel()
    fileprivate var countryCode : String = "91"
    fileprivate var selectedType:SelectedType = .mobile
    fileprivate var pageAccessToken:String = ""
    fileprivate var pageID:String = ""
    fileprivate let facebookLogin = FacebookLogin()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

extension LoginVC {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CountryCodePickerSegue" {
            let controller = segue.destination as! CountryPickerVC
            controller.delegate = self
            guard let souceView = sender as? UIButton else{return}
            self.showCountryPicker(controller: controller, sourceView:souceView )
            
        }
    }
    
    fileprivate func showCountryPicker(controller:CountryPickerVC, sourceView:UIButton){
        
        if let popoverController = controller.popoverPresentationController {
            popoverController.sourceView = sourceView
            popoverController.sourceRect = sourceView.bounds
            popoverController.delegate = self
            let height:CGFloat = 300
            let width:CGFloat = 300
            
            
            controller.preferredContentSize = CGSize(width: width, height: height)
        }
        
    }
    
    @IBAction fileprivate func onClickEmail(_ sender:CustomButton) {
        loginEmail.backgroundColor = CustomColor.customYellowColor
        loginPhone.backgroundColor = .clear
        view1.isHidden = true
        view2.isHidden = true
        view3.isHidden = false
        loginEmail.setTitleColor(.white, for: .normal)
        loginPhone.setTitleColor(CustomColor.customYellowColor, for: .normal)
        selectedType = .email
    }
    
    @IBAction fileprivate func onClickPhone(_ sender:CustomButton) {
        loginEmail.backgroundColor = .clear
        loginPhone.backgroundColor = CustomColor.customYellowColor
        view1.isHidden = false
        view2.isHidden = false
        view3.isHidden = true
        loginPhone.setTitleColor(.white, for: .normal)
        loginEmail.setTitleColor(CustomColor.customYellowColor, for: .normal)
        selectedType = .mobile
    }
    @IBAction fileprivate func onClickSignIn(_ sender:CustomButton) {
        userViewModel.login(selectedType:selectedType,sender: self, email: emailTF.text ?? "", phone: mobileTF.text ?? "", code: countryCode, type: selectedType.value ?? "", onSuccess: {
                    let vc = mainStoryboard.instantiateViewController(withIdentifier: "OTPVerificationVC") as! OTPVerificationVC
                    vc.email = self.emailTF.text ?? ""
                    vc.phone = self.mobileTF.text ?? ""
                    vc.selectedType = self.selectedType
                    vc.isFromLogin = true
                    vc.code = self.countryCode
                    self.navigationController?.pushViewController(vc, animated: true)
                }, onFailure: {
        
                })
        
    }
}

extension LoginVC:PickerControllerDelegate {
    func picker(pikcer: CountryPickerVC, didSelectCountry: CountryModel) {
        
        phoneTF.text = "(\(didSelectCountry.phoneCode ?? "")) \(didSelectCountry.name ?? "")"
        let code = didSelectCountry.phoneCode ?? ""
        countryCode = String(code.dropFirst())
        countryFlag.image = didSelectCountry.flag
        //signUpHeader.codeLbl.text = didSelectCountry.phoneCode ?? ""
    }
    
}
extension LoginVC:UIPopoverPresentationControllerDelegate{
    
    func adaptivePresentationStyle(for controller: UIPresentationController)-> UIModalPresentationStyle {
        
        if Platform.isPhone {
            return .none
        }else{
            return .popover
        }
        
    }
}

