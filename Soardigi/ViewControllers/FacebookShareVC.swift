//
//  FacebookShareVC.swift
//  Soardigi
//
//  Created by Developer on 05/01/23.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class FacebookShareVC: UIViewController, PagePickerControllerDelegate {
    
    @IBOutlet weak fileprivate var textField:UITextField!
    @IBOutlet weak fileprivate var textFieldTag:UITextField!
    @IBOutlet weak fileprivate var lbl:UILabel!
    var fbPageData:[FBPageData] = [FBPageData]()
    var selectedIndex:String = ""
    var dataUrl:String = ""
    var typeSelected:Int = 0
    fileprivate var isSchedule:Bool = true
    fileprivate var scheduleTime:UInt64 = 0
    var createdImage:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        if pageName.isEmpty && pageId.isEmpty {
            if fbPageData.count > 0 {
                lbl.text = fbPageData[0].name ?? ""
                pageName = fbPageData[0].name ?? ""
                pageId = fbPageData[0].id ?? ""
                selectedIndex = fbPageData[0].id ?? ""
            } else {
                
            }
         } else {
            lbl.text = pageName
            selectedIndex = pageId
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickSchedule(_ sender:UIButton) {
        if sender.isSelected {
            sender.isSelected = !sender.isSelected
            isSchedule = true
            if let viewWithTag = self.view.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
                
            }else{
                print("No!")
            }
        } else {
            sender.isSelected = !sender.isSelected
            let picker : UIDatePicker = UIDatePicker()
            picker.datePickerMode = UIDatePicker.Mode.dateAndTime
            picker.minimumDate = Calendar.current.date(byAdding: .minute, value: +10, to: Date())
            picker.tag = 100
            picker.maximumDate = Calendar.current.date(byAdding: .month, value: 6, to: Date())
            if #available(iOS 13.4, *) {
                picker.preferredDatePickerStyle = UIDatePickerStyle.wheels
            } else {
                // Fallback on earlier versions
            }
            picker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: UIControl.Event.valueChanged)
              let pickerSize : CGSize = picker.sizeThatFits(CGSize.zero)
              picker.frame = CGRect(x:0.0, y:250, width:pickerSize.width, height:300)
              // you probably don't want to set background color as black
            picker.backgroundColor = .black
              self.view.addSubview(picker)
        }
        
    }
    
    @objc func dueDateChanged(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.timeStyle = .short
  //        dobButton.setTitle(dateFormatter.string(from: sender.date), for: .normal)
        print("Start remove sibview")
            if let viewWithTag = self.view.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
            }else{
                print("No!")
            }
        isSchedule = false
        scheduleTime = UInt64((sender.date).timeIntervalSince1970)
        print(dateFormatter.string(from: sender.date))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FacebookPagePickerSegue" {
            let controller = segue.destination as! FacebookPagePickerVC
            controller.pagePickerControllerDelegate = self
            controller.fbPageData = fbPageData
            guard let souceView = sender as? UIButton else{return}
            self.showFacebookPages(controller: controller, sourceView:souceView )
        }
    }
    
    fileprivate func showFacebookPages(controller:FacebookPagePickerVC, sourceView:UIButton) {
        if let popoverController = controller.popoverPresentationController {
            popoverController.sourceView = sourceView
            popoverController.sourceRect = sourceView.bounds
            popoverController.delegate = self
            let height:CGFloat = 300
            let width:CGFloat = 300
            controller.preferredContentSize = CGSize(width: width, height: height)
        }
    }
    
    @IBAction func onClickPost(_ sender:UIButton) {
         getPageAccessToken(pageID: selectedIndex, url: dataUrl)
    }
    func getPageAccessToken(pageID:String = "", url:String = "") {
showLoader(status: true)
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "\(pageID)", parameters: ["fields": "access_token"])) { httpResponse, result,error  in
            if let error = error {
                print(error.localizedDescription)
              } else {
                let info = result as! [String : AnyObject]
                 if info["access_token"] as? String != nil {
                     let pageAccessToken = info["access_token"] as? String ?? ""
                     self.postMessage(pageID: pageID, pageAccessToken: pageAccessToken, url: url)
                 }
               
              }
        }
        connection.start()
    }
    
    
    
    func postMessage(pageID:String = "",pageAccessToken:String = "",url:String = "") {
        var message:String = ""
        if textFieldTag.text!.isEmpty {
            message = textField.text ?? ""
        } else {
            message = "\(textField.text ?? "")\n\(textFieldTag.text ?? "")"
        }
        guard let imageData = createdImage?.pngData() else {return}
        let requestPage : GraphRequest = typeSelected == 0 ? (isSchedule ? GraphRequest(graphPath: "\(pageID)/photos", parameters: ["source" : imageData, "message":message], tokenString: pageAccessToken, version: nil , httpMethod: .post ) : GraphRequest(graphPath: "\(pageID)/photos", parameters: ["source" : imageData, "message":message,"scheduled_publish_time":scheduleTime,"published": false], tokenString: pageAccessToken, version: nil , httpMethod: .post )) : (isSchedule ? GraphRequest(graphPath: "\(pageID)/videos", parameters: ["file_url" : url,"description":message], tokenString: pageAccessToken, version: nil , httpMethod: .post ):GraphRequest(graphPath: "\(pageID)/videos", parameters: ["file_url" : url,"description":message,"scheduled_publish_time":scheduleTime,"published": false], tokenString: pageAccessToken, version: nil , httpMethod: .post ))
        requestPage.start(completion: { (connection, result, error) -> Void in
            showLoader()
            if let error = error {
                print(error.localizedDescription)
              } else {
                  
                showAlertWithSingleAction1(sender: self, message: "Post Added successfully", onSuccess: {
                    pageName = self.lbl.text ?? ""
                    pageId = self.selectedIndex
                    self.dismiss(animated: true)
                })
              }
        })
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
    
    func pagePicker(selectedPage: String, index: String) {
        lbl.text = selectedPage
        selectedIndex = index
    }
}

extension FacebookShareVC:UIPopoverPresentationControllerDelegate{
    
    func adaptivePresentationStyle(for controller: UIPresentationController)-> UIModalPresentationStyle {

        if Platform.isPhone {
            return .none
        }else{
            return .popover
        }
        
    }
}



import Foundation

struct MultipartFormDataRequest {
    private let boundary: String = UUID().uuidString
    var httpBody = NSMutableData()
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func addTextField(named name: String, value: String) {
        httpBody.appendString(textFormField(named: name, value: value))
    }
    
    private func textFormField(named name: String, value: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "Content-Type: text/plain; charset=ISO-8859-1\r\n"
        fieldString += "Content-Transfer-Encoding: 8bit\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"
        
        return fieldString
    }
    
    
    func addDataField(fieldName: String, fileName: String, data: Data, mimeType: String) {
        httpBody.append(dataFormField(fieldName: fieldName,fileName:fileName,data: data, mimeType: mimeType))
    }
    
    private func dataFormField(fieldName: String,
                               fileName: String,
                               data: Data,
                               mimeType: String) -> Data {
        let fieldData = NSMutableData()
        
        fieldData.appendString("--\(boundary)\r\n")
        fieldData.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        fieldData.appendString("Content-Type: \(mimeType)\r\n")
        fieldData.appendString("\r\n")
        fieldData.append(data)
        fieldData.appendString("\r\n")
        return fieldData as Data
    }
    
    func asURLRequest() -> URLRequest {
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        httpBody.appendString("--\(boundary)--")
        request.httpBody = httpBody as Data
        return request
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}


extension URLSession {
    func dataTask(with request: MultipartFormDataRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    -> URLSessionDataTask {
        return dataTask(with: request.asURLRequest(), completionHandler: completionHandler)
    }
}
