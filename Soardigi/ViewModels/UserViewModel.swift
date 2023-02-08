//
//  UserViewModel.swift
//  Netpune Security
//
//  Created by Developer on 12/04/21.
//

import UIKit

class UserViewModel: NSObject {
    
    var message:String = ""
    var token:String = ""
    func login(selectedType:SelectedType ,sender:UIViewController,email:String = "",phone:String = "",code:String = "", type:String = "0",onSuccess:@escaping()->Void,onFailure:@escaping()->Void) {
        if  ServerManager.shared.CheckNetwork(sender: sender) {
            if selectedType == .mobile {
                if phone.isEmpty{
                    showAlertWithSingleAction(sender:sender, message: ValidationMessage.kPhone)
                }else if phone.count < 10{
                    showAlertWithSingleAction(sender:sender, message: "Mobile number must be of 10 digits")
                }else {
                    let params:[String:Any] = ["phone":phone,"device":"12122", "code": code, "type":type ]
                    showLoader(status: true)
                    ServerManager.shared.httpPost(request:  baseURL + "api/auth/v1/" + API.kLogin, params: params,headers: ServerManager.shared.apiHeaders, successHandler: { (responseData:Data,status)  in
                        
                        DispatchQueue.main.async {
                            showLoader()
                            guard let response = responseData.decoder(UserResponseModel1.self) else{return}
                            
                            switch status{
                            case 200:
                                if !response.success {
                                    showAlertWithSingleAction(sender: sender, message: response.message ?? "")
                                    
                                    onFailure()
                                } else {
                                    onSuccess()
                                }
                                
                                break
                            default:
                                showAlertWithSingleAction(sender: sender, message: response.message ?? "")
                                
                                onFailure()
                                break
                            }
                        }
                    }, failureHandler: { (error) in
                        DispatchQueue.main.async {
                            showLoader()
                            showAlertWithSingleAction(sender: sender, message: error?.localizedDescription ?? "")
                            onFailure()
                        }
                    })
                }
            } else {
                if email.isEmpty{
                    showAlertWithSingleAction(sender:sender, message: ValidationMessage.kEmail)
                }else if !email.isEmail{
                    showAlertWithSingleAction(sender:sender, message: "Please enter valid email")
                }else {
                    let params:[String:Any] = ["phone":email,"device":"12122", "code": code, "type":type ]
                    showLoader(status: true)
                    ServerManager.shared.httpPost(request:  baseURL + "api/auth/v1/" + API.kLogin, params: params,headers: ServerManager.shared.apiHeaders, successHandler: { (responseData:Data,status)  in
                        
                        DispatchQueue.main.async {
                            showLoader()
                            guard let response = responseData.decoder(UserResponseModel1.self) else{return}
                            
                            switch status{
                            case 200:
                                if !(response.success) {
                                    showAlertWithSingleAction(sender: sender, message: response.message ?? "")
                                    
                                    onFailure()
                                } else {
                                    onSuccess()
                                }
                                
                                break

                            default:
                                showAlertWithSingleAction(sender: sender, message: response.message ?? "")
                                
                                onFailure()
                                break
                            }
                        }
                    }, failureHandler: { (error) in
                        DispatchQueue.main.async {
                            showLoader()
                            showAlertWithSingleAction(sender: sender, message: error?.localizedDescription ?? "")
                            onFailure()
                        }
                    })
                }
            }
        }
    }
    
    fileprivate func set1(data:Any)->[MultipartData] {
           let dataFormate:DataFormate = .multipart
           let dataType:DataType!
           let uploadKey = "image"
           if let image = data as? UIImage {
               dataType = DataType.image(image: image, fileName: nil, uploadKey: uploadKey, formate: .jpeg(quality: .medium))
           }else if let url = data as? URL{
               dataType =  DataType.file(file: url, uploadKey: uploadKey)
           }else if let filePath = data as? String{
               dataType =  DataType.file(file: filePath, uploadKey: uploadKey)
           }else{
               return []
           }

           return [dataFormate.result(dataType: dataType) as! MultipartData]
       }
    
    func signUp(image:Any,sender:UIViewController,name:String = "",email:String = "",countryCode:String = "",mobile:String = "",refreal:String = "",onSuccess:@escaping()->Void,onFailure:@escaping()->Void) {
        if  ServerManager.shared.CheckNetwork(sender: sender){
            if name.isEmpty{
                showAlertWithSingleAction(sender:sender, message: ValidationMessage.kFirstName)
            } else if email.isEmpty{
                showAlertWithSingleAction(sender:sender, message: ValidationMessage.kEmail)
            }  else if !email.isEmail{
                showAlertWithSingleAction(sender:sender, message: "Please enter valid email")
            }else if mobile.isEmpty{
                
                showAlertWithSingleAction(sender:sender, message: ValidationMessage.kPhone)
            } else if mobile.count < 10{
                showAlertWithSingleAction(sender:sender, message: "Mobile number must be of 10 digits")
            } else if !refreal.isEmpty && refreal.count < 6{
                showAlertWithSingleAction(sender:sender, message: "Refreal Code must be of 6 characters")
            } else{
                
                let array = self.set1(data: image)
                if array.isEmpty{
                     showLoader()
                    return
               }
                let params:[String:Any] = ["name":name,"email":email, "phone":mobile , "ref_code" :refreal, "code":countryCode,"device":"12122"]
                showLoader(status: true)
                ServerManager.shared.httpUpload(request:  baseURL + "api/auth/v1/" + API.kRegisterOTP, params: params,headers: ServerManager.shared.apiHeaders,multipartObject: array, successHandler: { (responseData:Data,status)  in
                    
                    DispatchQueue.main.async {
                        showLoader()
                        guard let response = responseData.decoder(UserResponseModel1.self) else{return}
                        
                        switch status {
                        case 200:
                            if !response.success {
                                showAlertWithSingleAction(sender: sender, message: response.message ?? "")
                                
                                onFailure()
                            } else {
                                onSuccess()
                            }
                            
                            break
                        default:
                            showAlertWithSingleAction(sender: sender, message: response.message ?? "")
                            
                            onFailure()
                            break
                        }
                    }
                }, failureHandler: { (error) in
                    DispatchQueue.main.async {
                        showLoader()
                        showAlertWithSingleAction(sender: sender, message: error?.localizedDescription ?? "")
                        onFailure()
                    }
                })
            }
        }
    }
    
    
    func updateProfile(image:Any,sender:UIViewController,name:String = "",email:String = "",countryCode:String = "",mobile:String = "",refreal:String = "",onSuccess:@escaping()->Void,onFailure:@escaping()->Void) {
        if  ServerManager.shared.CheckNetwork(sender: sender){
            if name.isEmpty{
                showAlertWithSingleAction(sender:sender, message: ValidationMessage.kFirstName)
            } else if email.isEmpty{
                showAlertWithSingleAction(sender:sender, message: ValidationMessage.kEmail)
            }  else if !email.isEmail{
                showAlertWithSingleAction(sender:sender, message: "Please enter valid email")
            }else if mobile.isEmpty{
                
                showAlertWithSingleAction(sender:sender, message: ValidationMessage.kPhone)
            } else if mobile.count < 10{
                showAlertWithSingleAction(sender:sender, message: "Mobile number must be of 10 digits")
            } else if !refreal.isEmpty && refreal.count < 6{
                showAlertWithSingleAction(sender:sender, message: "Refreal Code must be of 6 characters")
            } else{
                let array = self.set1(data: image)
                if array.isEmpty{
                     showLoader()
                    return
               }
                let params:[String:Any] = ["name":name,"email":email, "phone":mobile , "ref_code" :refreal, "code":countryCode]
                showLoader(status: true)
                ServerManager.shared.httpUpload(request: baseURL + "api/auth/v1/profile", params: params,headers: ServerManager.shared.apiHeaders,multipartObject: array, successHandler: { (responseData:Data,status)  in
                    
                    DispatchQueue.main.async {
                        showLoader()
                        guard let response = responseData.decoder(UserResponseModel1.self) else{return}
                        
                        switch status {
                        case 200:
                            if !response.success {
                                showAlertWithSingleAction(sender: sender, message: response.message ?? "")
                                
                                onFailure()
                            } else {
                                onSuccess()
                            }
                            
                            break
                        default:
                            showAlertWithSingleAction(sender: sender, message: response.message ?? "")
                            
                            onFailure()
                            break
                        }
                    }
                }, failureHandler: { (error) in
                    DispatchQueue.main.async {
                        showLoader()
                        showAlertWithSingleAction(sender: sender, message: error?.localizedDescription ?? "")
                        onFailure()
                    }
                })
            }
        }
    }
    
    func otpVerification(type:String = "1",isFromLogin:Bool = false
                         ,name:String = "",phone:String = "",code:String = "",sender:UIViewController,email:String = "",otp:String = "",onSuccess:@escaping()->Void,onFailure:@escaping()->Void) {
        if  ServerManager.shared.CheckNetwork(sender: sender) {
            if otp.isEmpty{
                showAlertWithSingleAction(sender:sender, message: "Please enter OTP")
            } else if otp.count < 6 {
                showAlertWithSingleAction(sender:sender, message: "Please fill all digits of the OTP")
            }
            else{
                if isFromLogin {
                    let params:[String:Any] = ["device":"12122","phone":phone,"code":code,"email":email,"otp":otp,"type":type]
                    showLoader(status: true)
                    ServerManager.shared.httpPost(request:  baseURL  + "api/auth/v1/" + API.kLoginOTP, params: params,headers: ServerManager.shared.apiHeaders, successHandler: { (responseData:Data,status)  in
                        DispatchQueue.main.async {
                            showLoader()
                            guard let response = responseData.decoder(UserResponseModel1.self) else{return}
                            
                            switch status{
                            case 200:
                                if response.success {
                                    accessToken = response.token ?? ""
                                    onSuccess()
                                } else {
                                    showAlertWithSingleAction(sender: sender, message: response.message ?? "")
                                    onSuccess()
                                }
                                
                                break
                            default:
                                showAlertWithSingleAction(sender: sender, message: response.message ?? "")
                                onFailure()
                                break
                            }
                        }
                    }, failureHandler: { (error) in
                        DispatchQueue.main.async {
                            showLoader()
                            showAlertWithSingleAction(sender: sender, message: "Wrong OTP")
                            onFailure()
                        }
                    })
                } else {
                    let params:[String:Any] = ["device":"12122","phone":phone,"code":code,"name":name,"email":email,"otp":otp]
                    showLoader(status: true)
                    ServerManager.shared.httpPost(request:  baseURL + "api/auth/v1/" + API.kVerifyOtpCode, params: params,headers: ServerManager.shared.apiHeaders, successHandler: { (responseData:Data,status)  in
                        DispatchQueue.main.async {
                            showLoader()
                            guard let response = responseData.decoder(UserResponseModel1.self) else{return}
                            
                            switch status{
                            case 200:
                                
                                onSuccess()
                                break
                            default:
                                showAlertWithSingleAction(sender: sender, message: response.message ?? "")
                                
                                onFailure()
                                break
                            }
                        }
                    }, failureHandler: { (error) in
                        DispatchQueue.main.async {
                            showLoader()
                            showAlertWithSingleAction(sender: sender, message: error?.localizedDescription ?? "")
                            onFailure()
                        }
                    })
                }
            }
        }
    }
}



