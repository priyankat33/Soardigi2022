//
//  OTPVerificationVC.swift
//  Soardigi
//
//  Created by Developer on 20/10/22.
//

import UIKit

class OTPVerificationVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak fileprivate var tf1:CustomTextField!
    @IBOutlet weak fileprivate var tf2:CustomTextField!
    @IBOutlet weak fileprivate var tf3:CustomTextField!
    @IBOutlet weak fileprivate var tf4:CustomTextField!
    @IBOutlet weak fileprivate var tf5:CustomTextField!
    @IBOutlet weak fileprivate var tf6:CustomTextField!
    var email:String = ""
    var name:String = ""
    var phone:String = ""
    var code:String = ""
    var isFromLogin:Bool = false
    var selectedType:SelectedType = .mobile
    
    fileprivate var userViewModel:UserViewModel = UserViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tf1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.tf1.textContentType = .oneTimeCode
        tf1.becomeFirstResponder()
       
        // Do any additional setup after loading the view.
    }

    @objc func textFieldDidChange(_ textField: CustomTextField) {
        
            if textField.textContentType == UITextContentType.oneTimeCode{
                textField.maxLength = 6
                //here split the text to your four text fields
                if let otpCode = textField.text, otpCode.count > 5 {
                    tf1.text = String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: 0)])
                    tf2.text = String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: 1)])
                    tf3.text = String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: 2)])
                    tf4.text = String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: 3)])
                    tf5.text = String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: 4)])
                    tf6.text = String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: 5)])
                }
            }
       }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

          if (string.count == 1){
              if textField == tf1 {
                  tf2?.becomeFirstResponder()
              }
              if textField == tf2 {
                  tf3?.becomeFirstResponder()
              }
              if textField == tf3 {
                  tf4?.becomeFirstResponder()
              }
              if textField == tf4 {
                  tf5?.becomeFirstResponder()
              }
              if textField == tf5 {
                  tf6?.becomeFirstResponder()
              }
              if textField == tf6 {
                  tf6?.resignFirstResponder()
                  textField.text? = string
              }
              textField.text? = string
              return false
          }else{
              if textField == tf1 {
                  tf1?.becomeFirstResponder()
              }
              if textField == tf2 {
                  tf1?.becomeFirstResponder()
              }
              if textField == tf3 {
                  tf2?.becomeFirstResponder()
              }
              if textField == tf4 {
                  tf3?.becomeFirstResponder()
              }
              if textField == tf5 {
                  tf4?.becomeFirstResponder()
              }
              if textField == tf6 {
                  tf5?.becomeFirstResponder()
              }
              textField.text? = string
              return false
          }
      }
    
    @IBAction func onClickResendOTP(_ sender: UIButton) {
        userViewModel.login(selectedType:selectedType,sender: self, email: email, phone: phone, code: code, type: selectedType.value ?? "", onSuccess: {
            
                    showAlertWithSingleAction(sender: self, message: "OTP sent successfully")
                }, onFailure: {
        
                })
    }
    
    @IBAction func onClickVerification(_ sender: UIButton) {
        
        let data = tf1.text!  + tf2.text!  +  tf3.text!  + tf4.text! + tf5.text! + tf6.text!
        if isFromLogin {
            userViewModel.otpVerification(type:selectedType.value ?? "",isFromLogin:isFromLogin, phone: phone, code: code, sender: self, email: email, otp: data, onSuccess: { [self] in
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "ChooseLanguageVC") as! ChooseLanguageVC
                
                self.navigationController?.pushViewController(vc, animated: true)
            }, onFailure: {
                
            })
        } else {
            userViewModel.otpVerification(name: name, phone: phone, code: code, sender: self, email: email, otp: data, onSuccess: {
                showAlertWithSingleAction1(sender: self, message: "Email Verified Successfully", onSuccess: {
                    self.navigationController?.popToRootViewController(animated: true)
                })
            }, onFailure: {
                
            })
        }
        
    }
    
//    @IBAction func onClickResend(_ sender: UIButton) {
//        userViewModel.resendOtp(sender: self, email: email, onSuccess: {
//            showAlertWithSingleAction1(sender: self, message: "OTP sent Successfully", onSuccess: {
//                
//            })
//        }, onFailure: {
//            
//        })
//    }

}
