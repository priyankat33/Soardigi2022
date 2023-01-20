//
//  EditProfileVC.swift
//  Soardigi
//
//  Created by Developer on 15/01/23.
//

import UIKit

class EditProfileVC: UIViewController {
    var userResponseModel:UserResponseModel?
    fileprivate var userViewModel:UserViewModel = UserViewModel()
    @IBOutlet weak fileprivate var phoneTF:CustomTextField!
    @IBOutlet weak fileprivate var nameTF:CustomTextField!
    @IBOutlet weak fileprivate var emailTF:CustomTextField!
    @IBOutlet weak fileprivate var mobileTF:CustomTextField!
    @IBOutlet weak fileprivate var refTF:CustomTextField!
    @IBOutlet weak fileprivate var countryFlag:UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTF.text = userResponseModel?.name ?? ""
        emailTF.text = userResponseModel?.email ?? ""
        mobileTF.text = userResponseModel?.mobile_no ?? ""
        refTF.text = userResponseModel?.ref_code ?? ""
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
    
    @IBAction func onClickUpate(_ sender:CustomButton) {
        userViewModel.updateProfile(sender: self, name: nameTF.text ?? "", email: emailTF.text ?? "", countryCode: userResponseModel?.code ?? "", mobile: mobileTF.text ?? "", refreal: refTF.text ?? "", onSuccess: {
            showAlertWithSingleAction1(sender: self, message: "Profile edit successfully", onSuccess: {
                self.navigationController?.popViewController(animated: true)
            })
        }, onFailure: {
            
        })
        
    }

}
