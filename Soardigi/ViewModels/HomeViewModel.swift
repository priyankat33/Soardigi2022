//
//  HomeViewModel.swift
//  Soardigi
//
//  Created by Developer on 03/11/22.
//

import UIKit

class HomeViewModel: NSObject {
    var userResponseModel:UserResponseModel?
    var businessCategoryResponseModel:[BusinessCategoryResponseModel] = [BusinessCategoryResponseModel]()
    var businessCategoryResponseModel1:[BusinessCategoryResponseModel1] = [BusinessCategoryResponseModel1]()
    var businessModel:[BusinessModel] = [BusinessModel]()
    var businessName:String = ""
    var categoryName:String = ""
    var businessImage:String = ""
    var imageFrameResponseModel:[ImageFrameResponseModel] = [ImageFrameResponseModel]()
    var categoryImagesResponseModel:[CategoryImagesResponseModel] = [CategoryImagesResponseModel]()
    var categoryImagesResponseModel1:[FrameImagesResponseModel] = [FrameImagesResponseModel]()
    var homeSliderResponseModel:[HomeSliderResponseModel] = [HomeSliderResponseModel]()
    var homeCategoryResponseModel:[HomeCategoryResponseModel] = [HomeCategoryResponseModel]()
    var tokenId:String = ""
    var languages:[LanguageResponseModel] = [LanguageResponseModel]()
    func getLanguageList(sender:UIViewController,onSuccess:@escaping()->Void,onFailure:@escaping()->Void) {
        if  ServerManager.shared.CheckNetwork(sender: sender){
            showLoader(status: true)
            ServerManager.shared.httpPost(request:  "http://stgapi.soardigi.in/api/v1/" + API.kLanguageGet, params: nil,headers: ServerManager.shared.apiHeaders, successHandler: { (responseData:Data,status)  in
                DispatchQueue.main.async {
                    showLoader()
                    guard let response = responseData.decoder(LanguageResponseMainModel.self) else{return}
                    
                    switch status{
                    case 200:
                        print(response)
                        self.languages = response.languages ?? []
                        onSuccess()
                        
                        break
                    default:
                        
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
    
    func getPreferLanguage(sender:UIViewController,onSuccess:@escaping()->Void,onFailure:@escaping()->Void) {
        if  ServerManager.shared.CheckNetwork(sender: sender){
            showLoader(status: true)
            ServerManager.shared.httpPost(request:  "http://stgapi.soardigi.in/api/v1/" + API.kLanguageGet, params: nil,headers: ServerManager.shared.apiHeaders, successHandler: { (responseData:Data,status)  in
                DispatchQueue.main.async {
                    
                    guard let response = responseData.decoder(LanguageResponseMainModel.self) else{return}
                    
                    switch status{
                    case 200:
                        print(response)
                        self.languages = response.languages ?? []
                        onSuccess()
                        
                        break
                    default:
                        
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
    
    func userLogout(sender:UIViewController,onSuccess:@escaping()->Void,onFailure:@escaping()->Void) {
        if  ServerManager.shared.CheckNetwork(sender: sender){
            showLoader(status: true)
            ServerManager.shared.httpPost(request:  "http://stgapi.soardigi.in/api/auth/v1/logout", params: nil,headers: ServerManager.shared.apiHeaders, successHandler: { (responseData:Data,status)  in
                DispatchQueue.main.async {
                    showLoader(status: false)
                    guard let response = responseData.decoder(LanguageResponseMainModel.self) else{return}
                    
                    switch status{
                    case 200:
                        
                        onSuccess()
                        
                        break
                    default:
                        
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
    
    func getUserProfile(sender:UIViewController,onSuccess:@escaping()->Void,onFailure:@escaping()->Void) {
        if  ServerManager.shared.CheckNetwork(sender: sender){
            showLoader(status: true)
            ServerManager.shared.httpPost(request:  "http://stgapi.soardigi.in/api/auth/v1/user", params: nil,headers: ServerManager.shared.apiHeaders, successHandler: { (responseData:Data,status)  in
                DispatchQueue.main.async {
                    showLoader()
                    guard let response = responseData.decoder(GetUserResponseMainModel.self) else{return}
                    
                    switch status{
                    case 200:
                        self.userResponseModel = response.user
                        onSuccess()
                        break
                    default:
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
    
    
    func getMainHomeData(sender:UIViewController,onSuccess:@escaping()->Void,onFailure:@escaping()->Void) {
        if  ServerManager.shared.CheckNetwork(sender: sender){
            showLoader(status: true)
            ServerManager.shared.httpPost(request:  "http://stgapi.soardigi.in/api/v1/" + API.kHomePage, params: nil,headers: ServerManager.shared.apiHeaders, successHandler: { (responseData:Data,status)  in
                DispatchQueue.main.async {
                    showLoader()
                    guard let response = responseData.decoder(HomeResponseMainModel.self) else{return}
                    
                    switch status{
                    case 200:
                        self.businessName = response.business?.name ?? ""
                        self.categoryName = response.business?.businessCategoryModel?.name ?? ""
                        self.businessImage = response.business?.thumbnail ?? ""
                        self.homeSliderResponseModel =  response.homeSliderResponseModel ?? []
                        self.homeCategoryResponseModel = response.homeCategoryResponseModel ?? []
                        onSuccess()
                        break
                    default:
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
    
    func getBusineesHomeFrames(sender:UIViewController,onSuccess:@escaping()->Void,onFailure:@escaping()->Void) {
        if  ServerManager.shared.CheckNetwork(sender: sender) {
            showLoader(status: true)
           
            ServerManager.shared.httpPost(request:  "http://stgapi.soardigi.in/api/v1/business-frame-get"  , params: nil,headers: ServerManager.shared.apiHeaders, successHandler: { (responseData:Data,status)  in
                
                    DispatchQueue.main.async {
                        showLoader()
                        guard let response = responseData.decoder(HomeDetailFrameResponseMainModel.self) else{return}
                        
                        switch status{
                        case 200:
                            self.categoryImagesResponseModel1 = response.frames ?? []
                            onSuccess()
                            break
                        default:
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
    
    
    func getImageWithFrames(id:Int = 0,imageURl:String,waterMark:Int = 0,sender:UIViewController,onSuccess:@escaping()->Void,onFailure:@escaping()->Void) {
        if  ServerManager.shared.CheckNetwork(sender: sender) {
            showLoader(status: true)
           
            ServerManager.shared.httpGet(request:  "http://stgapi.soardigi.in/api/business-frame-first/64697505ab8add3aa07f761321d06014?frame=\(String(id))&watermark=\(0)&index=\(imageURl)"  , params: nil,headers: ServerManager.shared.apiHeaders, successHandler: { (responseData:Data,status)  in
                
                    DispatchQueue.main.async {
                        showLoader()
                        guard let response = responseData.decoder(HomeDetailFrameResponseMainModel.self) else{return}
                        
                        switch status{
                        case 200:
                            self.categoryImagesResponseModel1 = response.frames ?? []
                            onSuccess()
                            break
                        default:
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
    
    
    func getBusineesHomeImages(type:Int = 0,id:String = "",sender:UIViewController,onSuccess:@escaping()->Void,onFailure:@escaping()->Void) {
        if  ServerManager.shared.CheckNetwork(sender: sender) {
            showLoader(status: true)
            let params:[String:Any] = ["category":id]
            ServerManager.shared.httpPost(request: type == 0 ? "http://stgapi.soardigi.in/api/v1/category-images" : "http://stgapi.soardigi.in/api/v1/category-videos" , params: params,headers: ServerManager.shared.apiHeaders, successHandler: { (responseData:Data,status)  in
                if type == 0 {
                    DispatchQueue.main.async {
                        showLoader()
                        guard let response = responseData.decoder(HomeDetailResponseMainModel.self) else{return}
                        
                        switch status{
                        case 200:
                            self.categoryImagesResponseModel = response.frames ?? []
                            onSuccess()
                            break
                        default:
                            
                            
                            onFailure()
                            break
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        showLoader()
                        guard let response = responseData.decoder(HomeDetailVideoResponseMainModel.self) else{return}
                        
                        switch status{
                        case 200:
                            self.categoryImagesResponseModel = response.frames ?? []
                            onSuccess()
                            break
                        default:
                            
                            
                            onFailure()
                            break
                        }
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
    
    func getBusineesFrame(id:String = "",sender:UIViewController,onSuccess:@escaping()->Void,onFailure:@escaping()->Void) {
        if  ServerManager.shared.CheckNetwork(sender: sender) {
            showLoader(status: true)
        
            ServerManager.shared.httpPost(request:  "http://stgapi.soardigi.in/api/v1/image-frame-get?template=\(id)" , params: nil,headers: ServerManager.shared.apiHeaders, successHandler: { (responseData:Data,status)  in
                DispatchQueue.main.async {
                    showLoader()
                    guard let response = responseData.decoder(BusinessFrameResponseMainModel.self) else{return}
                    
                    switch status{
                    case 200:
                        self.imageFrameResponseModel = response.frames ?? []
                        onSuccess()
                        break
                    default:
                        
                        
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
    
    
    func saveBusineesFrame(array: [[String:String]],businessId:String = "",sender:UIViewController,onSuccess:@escaping()->Void,onFailure:@escaping()->Void) {
        if  ServerManager.shared.CheckNetwork(sender: sender) {
            showLoader(status: true)
           
            let params:[String:Any] = ["business":businessId, "frames" :convertToJSONString(value: array) ?? ""]
            
            ServerManager.shared.httpPost(request:  "http://stgapi.soardigi.in/api/v1/save-business-frame" , params: params,headers: ServerManager.shared.apiHeaders, successHandler: { (responseData:Data,status)  in
                DispatchQueue.main.async {
                    showLoader()
                    guard let response = responseData.decoder(SaveBusinessFrameResponseMainModel.self) else{return}
                    
                    switch status{
                    case 200:
                       
                        onSuccess()
                        break
                    default:
                        
                        
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
    
    func getBusineesCategory(search:String = "",sender:UIViewController,onSuccess:@escaping()->Void,onFailure:@escaping()->Void) {
        if  ServerManager.shared.CheckNetwork(sender: sender) {
            showLoader(status: true)
            
            let params:[String:Any] = ["search":search]
            
            ServerManager.shared.httpPost(request:  "http://stgapi.soardigi.in/api/v1/business-category" , params: params,headers: ServerManager.shared.apiHeaders, successHandler: { (responseData:Data,status)  in
                DispatchQueue.main.async {
                    showLoader()
                    guard let response = responseData.decoder(BusinessCategoryResponseMainModel.self) else{return}
                    
                    switch status{
                    case 200:
                        self.businessCategoryResponseModel.removeAll()
                        self.businessCategoryResponseModel = response.businessCategoryResponseModel ?? []
                        onSuccess()
                        break
                    default:
                        
                        
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
    
    
    
    func setWaterMark(isWaterMark:Bool = false,sender:UIViewController,onSuccess:@escaping()->Void,onFailure:@escaping()->Void) {
        if  ServerManager.shared.CheckNetwork(sender: sender) {
            
            
            let params:[String:Any] = ["watermark":isWaterMark]
            
            ServerManager.shared.httpPost(request:  "http://stgapi.soardigi.in/api/auth/v1/setting" , params: params,headers: ServerManager.shared.apiHeaders, successHandler: { (responseData:Data,status)  in
                DispatchQueue.main.async {
                    
                    guard let response = responseData.decoder(BusinessCategoryResponseMainModel1.self) else{return}
                    
                    switch status{
                    case 200:
                       
                        self.businessCategoryResponseModel1 = response.businessCategoryResponseModel ?? []
                        onSuccess()
                        break
                    default:
                        
                        
                        onFailure()
                        break
                    }
                }
            }, failureHandler: { (error) in
                DispatchQueue.main.async {
                    showAlertWithSingleAction(sender: sender, message: error?.localizedDescription ?? "")
                    onFailure()
                }
            })
            
        }
    }
    
    
    
    func getSearchCategory(search:String = "",sender:UIViewController,onSuccess:@escaping()->Void,onFailure:@escaping()->Void) {
        if  ServerManager.shared.CheckNetwork(sender: sender) {
            
            
            let params:[String:Any] = ["search":search]
            
            ServerManager.shared.httpPost(request:  "http://stgapi.soardigi.in/api/v1/category-search" , params: params,headers: ServerManager.shared.apiHeaders, successHandler: { (responseData:Data,status)  in
                DispatchQueue.main.async {
                    
                    guard let response = responseData.decoder(BusinessCategoryResponseMainModel1.self) else{return}
                    
                    switch status{
                    case 200:
                       
                        self.businessCategoryResponseModel1 = response.businessCategoryResponseModel ?? []
                        onSuccess()
                        break
                    default:
                        
                        
                        onFailure()
                        break
                    }
                }
            }, failureHandler: { (error) in
                DispatchQueue.main.async {
                    showAlertWithSingleAction(sender: sender, message: error?.localizedDescription ?? "")
                    onFailure()
                }
            })
            
        }
    }
    
    
    func getBusineesList(sender:UIViewController,onSuccess:@escaping()->Void,onFailure:@escaping()->Void) {
        if  ServerManager.shared.CheckNetwork(sender: sender) {
            showLoader(status: true)
            
           
            ServerManager.shared.httpPost(request:  "http://stgapi.soardigi.in/api/v1/business-get" , params: nil,headers: ServerManager.shared.apiHeaders, successHandler: { (responseData:Data,status)  in
                DispatchQueue.main.async {
                    showLoader()
                    guard let response = responseData.decoder(CategoryPickerMainModel.self) else{return}
                    
                    switch status{
                    case 200:
                        self.businessModel = response.businessModel ?? []
                        onSuccess()
                        break
                    default:
                        
                        
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
    
    func saveLanguage(selectedLanguage:[SelectedLanguage] = [SelectedLanguage](),sender:UIViewController,onSuccess:@escaping()->Void,onFailure:@escaping()->Void) {
        if  ServerManager.shared.CheckNetwork(sender: sender){
            showLoader(status: true)
            
            let value = selectedLanguage.count > 1 ? [["id":selectedLanguage[0].id],["id":selectedLanguage[1].id]] : [["id":selectedLanguage[0].id]]
            
            let params:[String:Any] = ["languages":convertToJSONString(value: value) ?? ""]
            
            // http://stgapi.soardigi.in/api/v1/language-save
            ServerManager.shared.httpPost(request:  "http://stgapi.soardigi.in/api/v1/" + API.kLanguageSave, params: params,headers: ServerManager.shared.apiHeaders, successHandler: { (responseData:Data,status)  in
                DispatchQueue.main.async {
                    showLoader()
                    guard let response = responseData.decoder(LanguageResponseMainModel.self) else{return}
                    
                    switch status{
                    case 200:
                        print(response)
                        onSuccess()
                        break
                    default:
                        
                        
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
    
    
    func saveCategory(categoryName:String,sender:UIViewController,onSuccess:@escaping()->Void,onFailure:@escaping()->Void) {
        if  ServerManager.shared.CheckNetwork(sender: sender){
            showLoader(status: true)
           
            let params:[String:Any] = ["name":categoryName]
            
            // http://stgapi.soardigi.in/api/v1/language-save
            //http://stgapi.soardigi.in/api/v1/change-business
            ServerManager.shared.httpPost(request:  "http://stgapi.soardigi.in/api/v1/" + API.kChangeBusiness, params: params,headers: ServerManager.shared.apiHeaders, successHandler: { (responseData:Data,status)  in
                DispatchQueue.main.async {
                    showLoader()
                    guard let response = responseData.decoder(LanguageResponseMainModel.self) else{return}
                    
                    switch status{
                    case 200:
                        print(response)
                        onSuccess()
                        break
                    default:
                        
                        
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
    
    func convertToJSONString(value: Any) -> String? {
            if JSONSerialization.isValidJSONObject(value) {
                do{
                    let data = try JSONSerialization.data(withJSONObject: value, options: [])
                    if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                        return string as String
                    }
                }catch{
                }
            }
            return nil
        }
    
    
    
    func saveBusineesCategory(image:Any,category_id:String = "",name:String = "",email:String = "",code:String = "",mobile_no:String = "",alt_mobile_no:String = "",website:String = "",address:String = "",city:String = "",sender:UIViewController,onSuccess:@escaping()->Void,onFailure:@escaping()->Void) {
        if  ServerManager.shared.CheckNetwork(sender: sender) {
            
            if name.isEmpty{
                showAlertWithSingleAction(sender:sender, message: "Please enter Business Name")
            } else if email.isEmpty{
                showAlertWithSingleAction(sender:sender, message: "Please enter Business Email")
            } else if !email.isEmail{
                showAlertWithSingleAction(sender:sender, message: "Please enter valid email")
            }else if mobile_no.isEmpty {
                showAlertWithSingleAction(sender:sender, message: "Please enter Mobile Number")
            } else if mobile_no.count < 10{
                showAlertWithSingleAction(sender:sender, message: "Mobile number must be of 10 digits")
            }else if !alt_mobile_no.isEmpty && alt_mobile_no.count < 10{
                showAlertWithSingleAction(sender:sender, message:"Alternate Mobile number must be of 10 digits")
            }else if !website.isEmpty && !website.isValidUrl(){
                showAlertWithSingleAction(sender:sender, message:"Please enter valid website URL")
            }else {
                showLoader(status: true)
                let array = self.set1(data: image)
                if array.isEmpty{
                     showLoader()
                    return
               }
                let params:[String:Any] = ["category_id":category_id,"name":name,"email":email,"code":code,"mobile_no":mobile_no,"alt_mobile_no":alt_mobile_no,"website":website,"address":address,"city":city]
                
                ServerManager.shared.httpUpload(request:  "http://stgapi.soardigi.in/api/v1/business-save" , params: params,headers: ServerManager.shared.apiHeaders,multipartObject: array, successHandler: { (responseData:Data,status)  in
                    DispatchQueue.main.async {
                        showLoader()
                        guard let response = responseData.decoder(BusinessSaveResponseMainModel.self) else{return}
                        
                        switch status{
                        case 200:
                            self.tokenId = response.token ?? ""
                            onSuccess()
                            break
                        default:
                            
                            
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
    
    func verifyUrl (urlString: String?) -> Bool {
       if let urlString = urlString {
           if let url  = URL(string: urlString) {
               return UIApplication.shared.canOpenURL(url)
            }
       }
       return false
    }

    
    func uploadImage(image:Any,sender:UIViewController,onSuccess:@escaping()->Void,onFailure:@escaping()->Void) {
        if  ServerManager.shared.CheckNetwork(sender: sender) {
               showLoader(status: true)
                let array = self.set2(data: image)
                if array.isEmpty {
                     showLoader()
                    return
               }
                ServerManager.shared.httpUpload(request:  "https://api.remove.bg/v1.0/removebg" , params: nil,headers: [ "X-Api-Key": "vjxQi9UG6QR6VYokNaMe8dMJ"],multipartObject: array, successHandler: { (responseData:Data,status)  in
                    DispatchQueue.main.async {
                        showLoader()
                        guard let response = responseData.decoder(BusinessSaveResponseMainModel.self) else{return}
                        switch status {
                        case 200:
                            onSuccess()
                            break
                        default:
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
    
     func set2(data:Any)->[MultipartData] {
           let dataFormate:DataFormate = .multipart
           let dataType:DataType!
           let uploadKey = "image_file"
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
}


extension HomeViewModel {
    
    func numberOfRows() -> Int {
        businessCategoryResponseModel.count
    }
    
    func numberOfRowsSearch() -> Int {
        businessCategoryResponseModel1.count
    }
    
    func numberOfRowsFrame() -> Int {
        imageFrameResponseModel.count
    }
    
    func cellForRowFrameAt(indexPath:IndexPath) -> ImageFrameResponseModel {
        imageFrameResponseModel[indexPath.row]
    }
    
    func didSelectFrameAt(indexPath:IndexPath) -> ImageFrameResponseModel {
        imageFrameResponseModel[indexPath.row]
    }
    
    func cellForRowAt(indexPath:IndexPath) -> BusinessCategoryResponseModel {
        businessCategoryResponseModel[indexPath.row]
    }
    
    func cellForRowAtSearcg(indexPath:IndexPath) -> BusinessCategoryResponseModel1 {
        businessCategoryResponseModel1[indexPath.row]
    }
    
    func didSelectAt(indexPath:IndexPath) -> BusinessCategoryResponseModel {
        businessCategoryResponseModel[indexPath.row]
    }
}
