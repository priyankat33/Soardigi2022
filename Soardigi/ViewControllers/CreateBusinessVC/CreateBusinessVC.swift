//
//  CreateBusinessVC.swift
//  Soardigi
//
//  Created by Developer on 06/11/22.
//

import UIKit
import Alamofire
class CreateBusinessVC: UIViewController {
    @IBOutlet weak var viewheight: NSLayoutConstraint!
    var catName:String = ""
    var catThumb:String = ""
    var isImageSelected:Bool = false
    var bussineeName:String = ""
    var emailId:String = ""
    var phoneNumber:String = ""
    var altPhoneNumber:String = ""
    var website:String = ""
    var address:String = ""
    var city:String = ""
    var thumbnail:String = ""
    @IBOutlet weak fileprivate var businessNameTF:CustomTextField!
    @IBOutlet weak fileprivate var cateView:UIView!
    @IBOutlet weak fileprivate var emailTF:CustomTextField!
    @IBOutlet weak fileprivate var mobileTF:CustomTextField!
    @IBOutlet weak fileprivate var phoneTF:CustomTextField!
    @IBOutlet weak fileprivate var altMobileTF:CustomTextField!
    @IBOutlet weak fileprivate var websiteTF:CustomTextField!
    @IBOutlet weak fileprivate var addressTF:CustomTextField!
    @IBOutlet weak fileprivate var cityTF:CustomTextField!
    @IBOutlet weak fileprivate var headingLBL:UILabel!
    @IBOutlet weak fileprivate var catLBL:UILabel!
    @IBOutlet weak fileprivate var countryFlag:UIImageView!
    var heading:String = ""
    var id:Int = 0
    var businessId:Int = 0
    fileprivate var countryCode : String = "91"
    fileprivate var homeViewModel:HomeViewModel = HomeViewModel()
    @IBOutlet weak fileprivate var imgView:CustomImageView!
    @IBOutlet weak fileprivate var catimgView:UIImageView!
    fileprivate var imagePicker = UIImagePickerController()
    fileprivate var selectedImageValue:Bool = false
    var isFromEdit:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        if isFromEdit {
            cateView.isHidden = false
            viewheight.constant = 160.0
            catLBL.text = catName
            catimgView.kf.indicatorType = .activity
            catimgView.kf.setImage(with: URL(string: catThumb), placeholder: nil, options: nil) { result in
                switch result {
                case .success(let value):
                    print("Image: \(value.image). Got from: \(value.cacheType)")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
            imgView.kf.indicatorType = .activity
            imgView.kf.setImage(with: URL(string: thumbnail), placeholder: nil, options: nil) { result in
                switch result {
                case .success(let value):
                    print("Image: \(value.image). Got from: \(value.cacheType)")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
            businessNameTF.text = heading
            emailTF.text = emailId
            phoneTF.text = phoneNumber
            altMobileTF.text = altPhoneNumber
            websiteTF.text = website
            addressTF.text = address
            cityTF.text = city
            headingLBL.text = "Edit Business - \(heading)"
            
            } else {
                cateView.isHidden = true
                viewheight.constant = 0.0
            headingLBL.text = "Create Business - \(heading)"
            
        }
       
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
    
    @IBAction func onClickCategory(_ sender:UIButton) {
        
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "SelectBusinessVC") as! SelectBusinessVC
        vc.isFromEdit = true
        vc.callback = { name, id, catThumb in
            self.catLBL.text = name
            self.id = id
            self.catimgView.kf.indicatorType = .activity
            self.catimgView.kf.setImage(with: URL(string: catThumb), placeholder: nil, options: nil) { result in
                switch result {
                case .success(let value):
                    print("Image: \(value.image). Got from: \(value.cacheType)")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickSave(_ sender:UIButton) {
        
        if isFromEdit {
            
            homeViewModel.updateBusineesCategory(business_id:businessId,image: self.imgView.image, category_id: "\(id)", name: businessNameTF.text ?? "", email: emailTF.text ?? "", code: "91", mobile_no: altMobileTF.text ?? "", alt_mobile_no: phoneTF.text ?? "", website: websiteTF.text ?? "", address: addressTF.text ?? "", city: cityTF.text ?? "", sender: self, onSuccess: {
                        
                        let vc = mainStoryboard.instantiateViewController(withIdentifier: "BusinessImageFrameVC") as! BusinessImageFrameVC
                        vc.id = self.homeViewModel.tokenId
                vc.isFromEdit = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }, onFailure: {
                        
                    })
                
        } else {
            if let image = self.imgView.image {
                if isImageSelected {
                    homeViewModel.saveBusineesCategory(image: image, category_id: "\(id)", name: businessNameTF.text ?? "", email: emailTF.text ?? "", code: "91", mobile_no: altMobileTF.text ?? "", alt_mobile_no: phoneTF.text ?? "", website: websiteTF.text ?? "", address: addressTF.text ?? "", city: cityTF.text ?? "", sender: self, onSuccess: {
                        
                        let vc = mainStoryboard.instantiateViewController(withIdentifier: "BusinessImageFrameVC") as! BusinessImageFrameVC
                        vc.id = self.homeViewModel.tokenId
                        vc.isFromEdit = false
                        self.navigationController?.pushViewController(vc, animated: true)
                    }, onFailure: {
                        
                    })
                } else {
                    showAlertWithSingleAction(sender: self, message: "Please add a image")
                }
                
            }
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
            isImageSelected = true
          } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
              isImageSelected = true
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
