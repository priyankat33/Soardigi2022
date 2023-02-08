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
    @IBOutlet weak var imgView:CustomImageView!
    fileprivate var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.imgView.kf.indicatorType = .activity
        self.imgView.kf.setImage(with: URL(string: self.userResponseModel?.profile ?? ""), placeholder: nil, options: nil) { result in
            switch result {
            case .success(let value):
                print("Image: \(value.image). Got from: \(value.cacheType)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
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
        userViewModel.updateProfile(image:imgView.image!,sender: self, name: nameTF.text ?? "", email: emailTF.text ?? "", countryCode: userResponseModel?.code ?? "", mobile: mobileTF.text ?? "", refreal: refTF.text ?? "", onSuccess: {
            showAlertWithSingleAction1(sender: self, message: "Profile edit successfully", onSuccess: {
                self.navigationController?.popViewController(animated: true)
            })
        }, onFailure: {
            
        })
        
    }

}

extension EditProfileVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBAction func onClickChooseImage(_ sender:UIButton) {
        myImagePicker()
    }
    
 fileprivate func myImagePicker() {
     let pickerView = UIImagePickerController()
     pickerView.delegate = self
     pickerView.sourceType = .photoLibrary
     
     
     let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
    
     let gallaryAction = UIAlertAction(title: "Open Media Library", style: UIAlertAction.Style.default) {
         UIAlertAction in
         self.openGallery()
     }
     let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
         UIAlertAction in
     }
     
     if let popoverController = alert.popoverPresentationController {
         popoverController.sourceView = self.view
         popoverController.sourceRect =  CGRect.init(x: self.view.center.x + 50 , y: 75, width: 20, height: 20)
     }
     alert.addAction(gallaryAction)
     alert.addAction(cancelAction)
     alert.view.tintColor = CustomColor.appThemeColor
     self.present(alert, animated: true, completion: nil)
 }

func openCamera()
{
    if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
        imagePicker.sourceType = UIImagePickerController.SourceType.camera
        imagePicker.allowsEditing = true
        self .present(imagePicker, animated: true, completion: nil)
    } else {
        let alert = UIAlertController(title: "Warning", message: "You don't have camera" , preferredStyle: .actionSheet)
        let secondAction = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction?) -> Void in
            
        })
        alert.addAction(secondAction)
        self.present(alert, animated: true)
    }
}


func openGallery() {
    imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
    imagePicker.allowsEditing = true
    self.present(imagePicker, animated: true, completion: nil)
}

func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
   
    if let editedImage = info[.editedImage] as? UIImage {
        
        imgView.image = editedImage
        
      } else if let originalImage = info[.originalImage] as? UIImage {
          imgView.image = originalImage
      }
       picker.dismiss(animated: true, completion: {
    })
}
}
