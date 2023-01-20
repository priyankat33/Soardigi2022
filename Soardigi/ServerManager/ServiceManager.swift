//
//  ServiceManager.swift
//  Sqimey
//
//  Created by apple on 01/07/19.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation
import UIKit
import CFNetwork
import Alamofire
import MobileCoreServices
import Kingfisher
typealias ServerSuccessCallBack = (_ data:Data,_ status:Int)->Void
typealias ServerFailureCallBack=(_ error:Error?)->Void
typealias ServerProgressCallBack = (_ progress:Double?) -> Void
typealias ServerNetworkConnectionCallBck = (_ reachable:Bool) -> Void

class ServerManager: NSObject {
    var networkManager:NetworkReachabilityManager{
        struct  Singlton{
            static let instance = NetworkReachabilityManager()
        }
        return Singlton.instance!
    }
    
    override init() {
        super.init()
    }
    var currentRequest: Alamofire.Request? = nil{
        didSet{
            cancelledRequest()
        }
    }
    func cancelledRequest(){
        backgroundManager.session.getAllTasks(completionHandler: {$0.forEach({ (task) in
            if let request = task.currentRequest , let current = self.currentRequest?.request , request.url! != current.url!{
                task.cancel()
            }
        })})
    }
    class var shared:ServerManager{
        struct  Singlton{
            static let instance = ServerManager()
        }
        return Singlton.instance
    }
    //MARK:- documentsDirectoryURL -
    lazy var documentsDirectoryURL : URL = {
        
        let documents = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return documents
    }()
    //MARK:- backgroundManager -
    private lazy var backgroundManager: Alamofire.SessionManager = {
        let bundleIdentifier = Bundle.main.bundleIdentifier
        let configure  = URLSessionConfiguration.background(withIdentifier: bundleIdentifier! + ".background")
        // configure.timeoutIntervalForRequest = 30
        
        let session = Alamofire.SessionManager(configuration: URLSessionConfiguration.background(withIdentifier: bundleIdentifier! + ".background"))
        session.startRequestsImmediately = true
        return session
    }()
    //MARK:- sessionManager -
    private lazy var sessionManager: Alamofire.SessionManager = {
        
        let configure  = URLSessionConfiguration.default
        configure.timeoutIntervalForRequest = 120
        configure.httpMaximumConnectionsPerHost = 20
        //configure.timeoutIntervalForResource = 60
        
        return Alamofire.SessionManager(configuration: configure)
    }()
    //MARK:- backgroundCompletionHandler -
    var backgroundCompletionHandler: (() -> Void)? {
        get {
            return backgroundManager.backgroundCompletionHandler
        }
        set {
            backgroundManager.backgroundCompletionHandler = newValue
        }
        
    }
    
    //MARK:- showProgressBarHud-
    
    
    //MARK:- hideHud-
    
    
    var isNetworkActivity:Bool = false{
        didSet{
            UIApplication.shared.isNetworkActivityIndicatorVisible = isNetworkActivity
        }
    }
    //MARK: - checkNetworkConnetion-
    func CheckNetwork(sender:UIViewController) -> Bool
    {
        let isReachable = self.networkManager.isReachable//Reachability.isConnectedToNetwork()
        if !isReachable {
            DispatchQueue.main.async {
                 let alert = UIAlertController(title: "No Internet Connection", message: "InternetConnectionOffline", preferredStyle: UIAlertController.Style.alert)
                          alert.addAction(UIAlertAction(title: "Settings" + "!", style: UIAlertAction.Style.destructive, handler: {(action:UIAlertAction!) in
                              print("Action")
                          AppDelegate.sharedDelegate.openSettings()
                          }))
                          alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))

                          sender.present(alert, animated: true, completion: nil)
                    
               
            }
        }
        return isReachable
        
    }

    
    
   var apiHeaders: HTTPHeaders? {
        return ["Authorization":"Bearer \(accessToken)"]
    }

   
    
    //MARK: - createServerPath-
   
    //MARK:- onResponseBlock
    fileprivate func onResponseBlock(response:DataResponse<Any>,onSuccessHandler:@escaping ServerSuccessCallBack,onFailureHandler:@escaping ServerFailureCallBack){
        if let error  = response.error {
            onFailureHandler(error)
        }else if let data = response.data{
            onSuccessHandler(data,response.response?.statusCode ?? 0)
        }
        
    }
    
    //MARK:- requestTask
    fileprivate func requestTask(url:URLConvertible,method:HTTPMethod,isBackgroundTask isBackground:Bool = false,params:[String:Any]?, headers: HTTPHeaders? = nil,successHandler:@escaping ServerSuccessCallBack,failureHandler:@escaping ServerFailureCallBack){
        print("service name =\(url)")
        if let params = params{
            print("service params =\(params)")
        }
        
        
        if isBackground {
            
            currentRequest =  backgroundManager.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print("response\(response)")
                        self.onResponseBlock(response: response, onSuccessHandler: successHandler,onFailureHandler: failureHandler)
                        
                    }
                    break
                    
                case .failure(_):
                    if response.result.error!._code == NSURLErrorTimedOut {
                        // ServerManager.shared.hideHud()
                        return
                    }
                    failureHandler(response.result.error!)
                    
                    break
                    
                }
            })
            currentRequest?.resume()
            self.backgroundManager.delegate.sessionDidFinishEventsForBackgroundURLSession = {
                session in
                // record the fact that we're all done moving stuff around
                // now, call the saved completion handler
                self.backgroundCompletionHandler?()
                self.backgroundCompletionHandler = nil
            }
            
            self.backgroundManager.backgroundCompletionHandler = {
                // finshed task
            }
        }else{
            currentRequest = sessionManager.request (url, method:method, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print("response\(response)")
                        
                       
                        self.onResponseBlock(response: response, onSuccessHandler: successHandler,onFailureHandler: failureHandler)
                        
                    }
                    break
                    
                case .failure(_):
                    if response.result.error!._code == NSURLErrorTimedOut {
                        //  ServerManager.shared.hideHud()
                        return
                    }
                    print(response.result.error?.code)
                    failureHandler(response.result.error!)
                    break
                    
                }
                
            }
            currentRequest?.resume()
        }
    }
    
    //    //
    
    
    
    //MARK:-uploadTask
    fileprivate func uploadTask(url:URLConvertible,method:HTTPMethod,params:[String:Any]?, isBackgroundTask isBackground:Bool = false,headers: HTTPHeaders? = nil ,multipartObject :[MultipartData]?,successHandler:@escaping ServerSuccessCallBack,failureHandler:@escaping ServerFailureCallBack,progressHandler:ServerProgressCallBack? = nil){
        
        if (multipartObject != nil) , multipartObject!.count > 0{
            if isBackground {
                backgroundManager.upload(multipartFormData: { (multipartFormData) in
                    if let mediaList  = multipartObject
                    {
                        for object in mediaList
                        {
                            multipartFormData.append(object.media, withName: object.mediaUploadKey, fileName: object.fileName, mimeType: object.mimType)
                        }
                    }
                    if (params != nil){
                        for (key, value) in params! {
                            multipartFormData.append("\(value)".data(using:.utf8)!, withName: key)
                        }
                    }
                }, to: "\(url)",headers:headers, encodingCompletion: { (result) in
                    
                    switch result {
                    case .success(let upload, _, _):
                        self.currentRequest = upload
                        upload.uploadProgress(closure: { (Progress) in
                            print("Upload Progress: \(Progress.fractionCompleted)")
                            if let progressHandler = progressHandler{
                                progressHandler(Progress.fractionCompleted)
                            }
                        })
                        upload.resume()
                        upload.responseJSON { response in
                            if response.result.value != nil{
                                print("response\(response)")
                                self.onResponseBlock(response: response, onSuccessHandler: successHandler,onFailureHandler: failureHandler)
                                
                            }
                        }
                        
                    case .failure(let encodingError):
                       
                        failureHandler(encodingError as NSError )
                        
                    }
                })
                backgroundManager.delegate.sessionDidFinishEventsForBackgroundURLSession = {
                    session in
                    // record the fact that we're all done moving stuff around
                    // now, call the saved completion handler
                    self.backgroundCompletionHandler?()
                    self.backgroundCompletionHandler = nil
                }
                backgroundManager.backgroundCompletionHandler = {
                    // finshed task
                }
            }else{
                sessionManager.upload(multipartFormData: { (multipartFormData) in
                    if let mediaList  = multipartObject
                    {
                        for object in mediaList
                        {
                            multipartFormData.append(object.media, withName: object.mediaUploadKey, fileName: object.fileName, mimeType: object.mimType)
                        }
                    }
                    if let params = params {
                        for (key, value) in params {
                            multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                        }
                    }
                }, to: url,headers:headers, encodingCompletion: { (result) in
                    
                    switch result {
                    case .success(let upload, _, _):
                        self.currentRequest = upload
                        upload.uploadProgress(closure: { (Progress) in
                            print("Upload Progress: \(Progress.fractionCompleted)")
                            if let progressHandler = progressHandler {
                                progressHandler(Progress.fractionCompleted)
                            }
                            
                        })
                        upload.resume()
                        
                        upload.responseJSON { response in
                            if response.result.value != nil{
                                print("response\(response)")
                                self.onResponseBlock(response: response, onSuccessHandler: successHandler,onFailureHandler: failureHandler)
                            }
                        }
                        
                    case .failure(let encodingError):
                        
                        failureHandler(encodingError)
                        
                    }
                })
            }
            
        }else{
            self.requestTask(url: url, method: method, isBackgroundTask: isBackground, params: params, headers: headers, successHandler: successHandler, failureHandler: failureHandler)
        }
        
        
    }
    
    //MARK:- httpBackgroundTaskRequest-
    func httpBackgroundRequest(request api:String,params:[String:Any]? ,method :HTTPMethod = .post,headers: HTTPHeaders? = nil,successHandler:@escaping ServerSuccessCallBack,failureHandler:@escaping ServerFailureCallBack){
        self.requestTask(url: "\(api)", method: method, params: params, successHandler: successHandler, failureHandler: failureHandler)
        
    }
    
    //MARK: - httpDelete -
    func httpDelete(request api:String,params:[String:Any]?, isBackgroundTask isBackground:Bool = false, headers: HTTPHeaders? = nil,successHandler:@escaping ServerSuccessCallBack,failureHandler:@escaping ServerFailureCallBack){
        
        self.requestTask(url: "\(api)", method: .delete,isBackgroundTask: isBackground, params: params, headers: headers,successHandler: successHandler, failureHandler: failureHandler)
        
    }
    // MARK:- httpPut
    func httpPut(request api:String,params:[String:Any]?, isBackgroundTask isBackground:Bool = false,headers: HTTPHeaders? = nil,successHandler:@escaping ServerSuccessCallBack,failureHandler:@escaping ServerFailureCallBack){
        self.requestTask(url: "\(api)", method: .put, isBackgroundTask: isBackground, params: params, headers: headers, successHandler: successHandler, failureHandler: failureHandler)
    }
    //MARK:- httpPost
    func httpPost(request api:String,params:Parameters?, isBackgroundTask isBackground:Bool = false,headers: HTTPHeaders? = nil,successHandler:@escaping ServerSuccessCallBack,failureHandler:@escaping ServerFailureCallBack){
        self.requestTask(url: "\(api)", method: .post, isBackgroundTask: isBackground, params: params, headers: headers, successHandler: successHandler, failureHandler: failureHandler)
    }
    //MARK:- httpGetRequest
    func httpGet(request api:String,params:[String:Any]?, isBackgroundTask isBackground:Bool = false,headers: HTTPHeaders? = nil ,successHandler:@escaping ServerSuccessCallBack,failureHandler:@escaping ServerFailureCallBack){
        self.requestTask(url: "\(api)", method: .get, isBackgroundTask: isBackground, params: params, headers: headers, successHandler: successHandler, failureHandler: failureHandler)
    }
        //MARK:- httpUploadRequest
    func httpUpload(request api:String,params:[String:Any]?,  isBackgroundTask isBackground:Bool = false,headers: HTTPHeaders? = nil ,multipartObject :[MultipartData]?,method:HTTPMethod = .post,successHandler:@escaping ServerSuccessCallBack,failureHandler:@escaping ServerFailureCallBack,progressHandler:ServerProgressCallBack? = nil){
        self.uploadTask(url: "\(api)", method: method, params: params, isBackgroundTask: isBackground, headers: headers, multipartObject: multipartObject, successHandler: successHandler, failureHandler: failureHandler, progressHandler: progressHandler)
    
        }
    //    //MARK:- httpDownloadRequest
    //    func httpDownload(request api:String ,isBackgroundTask isBackground:Bool = false ,successHandler:@escaping (_ destinationURL:URL?)->Void,failureHandler:ServerFailureCallBack?,progressHandler:ServerProgressCallBack? = nil){
    //        print("\(api)")
    //        guard let fileUrl  = URL(string: "\(api)") else {
    //
    //            if (failureHandler != nil){
    //
    //                let errorTemp = SMError(localizedTitle: "file url incorrect", localizedDescription: "file url incorrect", code: 500)
    //                failureHandler!(errorTemp )
    //            }
    //            return
    //        }
    //        let request = URLRequest(url: fileUrl)
    //        let destination: DownloadRequest.DownloadFileDestination = { filePath,response in
    //
    //            let directory : NSURL = (self.documentsDirectoryURL as NSURL)
    //
    //            let fileURL =   directory.appendingPathComponent(response.suggestedFilename!)!
    //            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
    //        }
    //
    //        if isBackground {
    //            backgroundManager.download(request, to: destination).response(completionHandler: { (response:DefaultDownloadResponse) in
    //
    //                if response.error != nil{
    //                    if let failureHandler = failureHandler  {
    //                        failureHandler(response.error! as NSError )
    //                    }
    //                }
    //                else{
    //                    if  response.response?.statusCode == 200{
    //                        successHandler(response.destinationURL)
    //                    }else if response.response?.statusCode == 401{
    //
    //                        if let failureHandler = failureHandler {
    //                            let localizedString = HTTPURLResponse.localizedString(forStatusCode: 401)
    //                            let error  = SMError(localizedTitle: nil, localizedDescription: localizedString, code: 401)
    //                            failureHandler(error  as NSError )
    //                        }
    //
    //
    //                    }
    //                }
    //
    //            }).downloadProgress(queue: DispatchQueue.global(qos: .utility)) { (progress) in
    //                if let onProgress = progressHandler {
    //                    onProgress(progress.fractionCompleted)
    //                }
    //                }.resume()
    //
    //            backgroundManager.delegate.sessionDidFinishEventsForBackgroundURLSession = {
    //                session in
    //                // record the fact that we're all done moving stuff around
    //                // now, call the saved completion handler
    //                self.backgroundCompletionHandler?()
    //                self.backgroundCompletionHandler = nil
    //            }
    //            backgroundManager.backgroundCompletionHandler = {
    //                // finshed task
    //            }
    //
    //        }else{
    //
    //            sessionManager.download(request, to: destination).validate(statusCode: 200..<300).response(completionHandler: { (response:DefaultDownloadResponse) in
    //
    //                if response.error != nil{
    //                    if let failureHandler = failureHandler{
    //                        failureHandler(response.error! as NSError )
    //                    }
    //                }
    //                else{
    //                    print("response\(response)")
    //                    if  response.response?.statusCode == 200{
    //
    //                        successHandler(response.destinationURL)
    //
    //                    }else if response.response?.statusCode == 401{
    //                        if let failureHandler = failureHandler{
    //                            let localizedString = HTTPURLResponse.localizedString(forStatusCode: 401)
    //                            let error  = SMError(localizedTitle: nil, localizedDescription: localizedString, code: 401)
    //                            failureHandler(error  as NSError )
    //                        }
    //
    //                    }
    //                }
    //
    //            }).downloadProgress(queue: DispatchQueue.global(qos: .utility)) { (progress) in
    //                if let progressHandler = progressHandler {
    //                    progressHandler(progress.fractionCompleted)
    //                }
    //                }.resume()
    //
    //
    //        }
    //
    //
    //
    //    }
}

extension AppDelegate {
    func openSettings(){
        let shared = UIApplication.shared
        let url = URL(string:UIApplication.openSettingsURLString)!
        if #available(iOS 10.0, *) {
            shared.open(url)
            
        } else {
            shared.openURL(url)
        }
    }
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        let bundleIdentifier = Bundle.main.bundleIdentifier!+".background"
        if application.backgroundRefreshStatus == .available , identifier == bundleIdentifier{
            ServerManager.shared.backgroundCompletionHandler = completionHandler
        }else{
           
            
            
            
        }
        //AWSS3Manager.shared.interceptApplication(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler)
    }
}
