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
    @IBOutlet weak fileprivate var imgView:CustomImageView!
    fileprivate var imagePicker = UIImagePickerController()
    fileprivate var userViewModel: UserViewModel = UserViewModel()
    fileprivate var countryCode : String = "91"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
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
        userViewModel.signUp(image:imgView.image!,sender: self, name: nameTF.text ?? "", email: emailTF.text ?? "", countryCode: countryCode, mobile: mobileTF.text ?? "", refreal: refTF.text ?? "", onSuccess: {
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



extension SignUpVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate {

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

func makeTransparent(image: UIImage) -> UIImage? {
    guard let rawImage = image.cgImage else { return nil}
    let colorMasking: [CGFloat] = [255, 255, 255, 255, 255, 255]
    UIGraphicsBeginImageContext(image.size)
    
    if let maskedImage = rawImage.copy(maskingColorComponents: colorMasking),
        let context = UIGraphicsGetCurrentContext() {
        context.translateBy(x: 0.0, y: image.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.draw(maskedImage, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage
    }
    
    return nil
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
