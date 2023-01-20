//
//  CreateBusinessVC.swift
//  Soardigi
//
//  Created by Developer on 06/11/22.
//

import UIKit
import Alamofire
class CreateBusinessVC: UIViewController {
    @IBOutlet weak fileprivate var businessNameTF:CustomTextField!
    @IBOutlet weak fileprivate var emailTF:CustomTextField!
    @IBOutlet weak fileprivate var mobileTF:CustomTextField!
    @IBOutlet weak fileprivate var phoneTF:CustomTextField!
    @IBOutlet weak fileprivate var altMobileTF:CustomTextField!
    @IBOutlet weak fileprivate var websiteTF:CustomTextField!
    @IBOutlet weak fileprivate var addressTF:CustomTextField!
    @IBOutlet weak fileprivate var cityTF:CustomTextField!
    @IBOutlet weak fileprivate var headingLBL:UILabel!
    @IBOutlet weak fileprivate var countryFlag:UIImageView!
    var heading:String = ""
    var id:Int = 0
    fileprivate var countryCode : String = "91"
    fileprivate var homeViewModel:HomeViewModel = HomeViewModel()
    @IBOutlet weak fileprivate var imgView:CustomImageView!
    var imagePicker = UIImagePickerController()
    fileprivate var selectedImageValue:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        headingLBL.text = "Create Business - \(heading)"
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
    
    @IBAction func onClickSave(_ sender:UIButton) {
        
        if let image = self.imgView.image {
            homeViewModel.saveBusineesCategory(image: image, category_id: "\(id)", name: businessNameTF.text ?? "", email: emailTF.text ?? "", code: "91", mobile_no: altMobileTF.text ?? "", alt_mobile_no: phoneTF.text ?? "", website: websiteTF.text ?? "", address: addressTF.text ?? "", city: cityTF.text ?? "", sender: self, onSuccess: {
                
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "BusinessImageFrameVC") as! BusinessImageFrameVC
                vc.id = self.homeViewModel.tokenId
                self.navigationController?.pushViewController(vc, animated: true)
            }, onFailure: {
                
            })
        } else {
            showAlertWithSingleAction(sender: self, message: "Please add a image")
        }
      }
    
    
    @IBAction func onClickChooseImage(_ sender:UIButton) {
        myImagePicker()
    }
 }

extension CreateBusinessVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
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
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            
          } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
          }
  
           picker.dismiss(animated: true, completion: {
            showAlertWithTwoActions(sender: self, message: "Are you want to remove background of image", title: "Yes", secondTitle: "No", onSuccess: {
                self.selectedImageValue = true
                self.imgView.image =  self.makeTransparent(image: selectedImage!)
                
//                let imgData = selectedImage!.jpegData(compressionQuality: 0.2)!
//                Alamofire.upload(multipartFormData: { multipartFormData in
//                        multipartFormData.append(imgData, withName: "image_file",fileName: "file.jpg", mimeType: "image/jpeg")
//                        //Optional for extra parameters
//                    },
//                to:"https://api.remove.bg/v1.0/removebg",headers: [
//                    "X-Api-Key": "vjxQi9UG6QR6VYokNaMe8dMJ"])
//                { (result) in
//                    switch result {
//                    case .success(let upload, _, _):
//
//                        upload.uploadProgress(closure: { (progress) in
//                            print("Upload Progress: \(progress.fractionCompleted)")
//                        })
//
//                        upload.responseJSON { response in
//                            print(response.data)
//
//                            if let imageData = response.data,
//                               let image = UIImage(data: imageData){
//                                self.imgView.image = image
//                            }
//                        }
//
//                    case .failure(let encodingError):
//                        print(encodingError)
//                    }
//                }
                
//                 self.homeViewModel.uploadImage(image: selectedImage!, sender: self, onSuccess: {
//
//                }, onFailure: {
//
//                })
             }, onCancel: {
                self.selectedImageValue = true
                self.imgView.image = selectedImage
            })
        })
    }
}

extension CreateBusinessVC:PickerControllerDelegate {
    func picker(pikcer: CountryPickerVC, didSelectCountry: CountryModel) {
        
        mobileTF.text = "(\(didSelectCountry.phoneCode ?? "")) \(didSelectCountry.name ?? "")"
        let code = didSelectCountry.phoneCode ?? ""
        countryCode = String(code.dropFirst())
        countryFlag.image = didSelectCountry.flag
        //signUpHeader.codeLbl.text = didSelectCountry.phoneCode ?? ""
   }
    
}
extension CreateBusinessVC:UIPopoverPresentationControllerDelegate{
    
    func adaptivePresentationStyle(for controller: UIPresentationController)-> UIModalPresentationStyle {

        if Platform.isPhone {
            return .none
        }else{
            return .popover
        }
        
    }
}

extension CreateBusinessVC {
    
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
