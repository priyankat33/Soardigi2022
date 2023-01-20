//
//  SignUpVC.swift
//  Soardigi
//
//  Created by Developer on 18/10/22.
//

import UIKit

class SignUpVC: UIViewController {
    @IBOutlet weak fileprivate var phoneTF:CustomTextField!
    @IBOutlet weak fileprivate var nameTF:CustomTextField!
    @IBOutlet weak fileprivate var emailTF:CustomTextField!
    @IBOutlet weak fileprivate var mobileTF:CustomTextField!
    @IBOutlet weak fileprivate var refTF:CustomTextField!
    @IBOutlet weak fileprivate var countryFlag:UIImageView!
    fileprivate var userViewModel: UserViewModel = UserViewModel()
    fileprivate var countryCode : String = "91"
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

extension SignUpVC {
    @IBAction func onClickSignUp(_ sender:CustomButton) {
        userViewModel.signUp(sender: self, name: nameTF.text ?? "", email: emailTF.text ?? "", countryCode: countryCode, mobile: mobileTF.text ?? "", refreal: refTF.text ?? "", onSuccess: {
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "OTPVerificationVC") as! OTPVerificationVC
            vc.email = self.emailTF.text ?? ""
            vc.phone = self.mobileTF.text ?? ""
            vc.name = self.nameTF.text ?? ""
            vc.code = self.countryCode
            self.navigationController?.pushViewController(vc, animated: true)
        }, onFailure: {
            
        })
        
    }
}
extension SignUpVC:PickerControllerDelegate {
    func picker(pikcer: CountryPickerVC, didSelectCountry: CountryModel) {
        
        phoneTF.text = "(\(didSelectCountry.phoneCode ?? "")) \(didSelectCountry.name ?? "")"
        let code = didSelectCountry.phoneCode ?? ""
        countryCode = String(code.dropFirst())
        countryFlag.image = didSelectCountry.flag
        //signUpHeader.codeLbl.text = didSelectCountry.phoneCode ?? ""
   }
    
}
extension SignUpVC:UIPopoverPresentationControllerDelegate{
    
    func adaptivePresentationStyle(for controller: UIPresentationController)-> UIModalPresentationStyle {

        if Platform.isPhone {
            return .none
        }else{
            return .popover
        }
        
    }
}

extension SignUpVC {
    
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
}
