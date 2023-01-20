//
//  SMUtility.swift
//  BindUserApp
//
//  Created by apple on 14/11/19.
//  Copyright © 2019 apple. All rights reserved.
//
import UIKit
import Foundation
import MobileCoreServices
//TAG: - AppUtility

class SMUtility:NSObject{
    class var shared:SMUtility{
        struct  Singlton{
            static let instance = SMUtility()
        }
        return Singlton.instance
    }
 
    //MARK:- mimeTypeForPath-
    static func mimeType(forPath filePath:URL)->String{
        var mimeType:String
        let fileExtension:CFString = filePath.pathExtension as CFString
        let UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, nil)
        let str = UTTypeCopyPreferredTagWithClass(UTI!.takeUnretainedValue(), kUTTagClassMIMEType)
        if let value = str {
            mimeType = value.takeUnretainedValue() as String
        }else{
            mimeType = "application/octet-stream"
        }
        return mimeType
    }
    //MARK:- filename-
    static func filename(Prefix:String , fileExtension:String)-> String{
        let dateformatter=DateFormatter()
        dateformatter.dateFormat="MddyyHHmmss"
        let dateInStringFormated=dateformatter.string(from: Date() )
        return "\(Prefix)_\(dateInStringFormated).\(fileExtension)"
    }
    
}
public enum JPEGQuality:Int,CustomStringConvertible {
    case highest
    case high
    case medium
    case low
    case lowest
    public var description: String {
        switch self {
        case .highest:return "highest Quality JPEG Formate data"
        case .high:return "high Quality JPEG Formate data"
        case .medium:return  "medium Quality JPEG Formate data"
        case .low:return  "low Quality JPEG Formate data"
        case .lowest:return "lowest Quality JPEG Formate data"
        }
    }
}
public enum ImageFormate:CustomStringConvertible {
    case png
    case jpeg(quality:JPEGQuality)
    func imageData(image:UIImage)->Data{
        switch self {
        case .jpeg(let quality):
            switch quality{
            case .highest:return image.highestJPEG
            case .high:return image.highJPEG
            case .medium:return image.mediumJPEG
            case .low:return image.lowQualityJPEG
            case .lowest:return image.lowestQualityJPEG
            }
        case .png:
            return image.png
            
        }
    }
    public var description: String{
        switch self {
        case .png:
            return "png"
        default:
            return "jpeg"
        }
    }
    public var mimType:String{
        switch self {
        case .png:
            return "image/png"
        default:
            return "image/jpeg"
        }
    }
    
}
internal enum DataType {
    case image(image: UIImage, fileName: String?, uploadKey: String, formate: ImageFormate)
    case file(file: Any,uploadKey: String)
    
}

enum DataFormate:Int{
    case base64
    case multipart
    func result(dataType:DataType)->Any{
        switch self {
        case .base64:
            switch dataType{
            case .file(let file, let uploadKey):
                return Base64Data(file: file, mediaKey: uploadKey)
            case .image(let image, let fileName, let uploadKey, let formate):
                return Base64Data(image: image, fileName: fileName, mediaKey: uploadKey, formate: formate)
            }
        case .multipart:
            switch dataType{
            case .file(let file, let uploadKey):
                return MultipartData(file: file, mediaKey: uploadKey)
            case .image(let image, let fileName, let uploadKey, let formate):
                return MultipartData(image: image, fileName: fileName, mediaKey: uploadKey, formate: formate)
            }
        }
    }
}


struct Base64Data {
    var base64String:String!
    var mediaUploadKey:String!
    var fileName:String!
    var pathExtension:String!
    
    init(image:UIImage,fileName:String? = nil,mediaKey uploadKey:String,formate:ImageFormate = .png) {
        
        let data            = formate.imageData(image: image)
        self.base64String   = data.base64EncodedString()
        self.pathExtension  = formate.description
        self.mediaUploadKey = uploadKey
        self.fileName       = fileName ?? SMUtility.filename(Prefix: "image", fileExtension:  self.pathExtension)
    }
    
    init(file:Any,mediaKey uploadKey:String) {
        var imagedata :Data?
        if let filepath = file as? String{
            let url = NSURL.fileURL(withPath: filepath)
            self.pathExtension = url.pathExtension
            self.fileName = url.lastPathComponent
            imagedata = try! Data(contentsOf: url)
        }else if  let fileurl = file as? URL {
            self.pathExtension = fileurl.pathExtension
            self.fileName = fileurl.lastPathComponent
            imagedata = try! Data(contentsOf: fileurl)
            
        }
        guard let data  = imagedata else {return}
        self.mediaUploadKey = uploadKey
        self.base64String = data.base64EncodedString()
        
        
    }
    
}
//MARK:- MultipartData
struct MultipartData{
    var media:Data!
    var mediaUploadKey:String!
    var fileName:String!
    var mimType:String!
    var pathExtension:String!
    init(image:UIImage,fileName:String? = nil,mediaKey uploadKey:String,formate:ImageFormate = .png) {
        
        self.media          = formate.imageData(image: image)
        self.mimType        = formate.mimType
        self.pathExtension  = formate.description
        self.fileName = fileName ?? SMUtility.filename(Prefix: "image", fileExtension:  self.pathExtension)
        self.mediaUploadKey = uploadKey
    }
    init(file:Any,mediaKey uploadKey:String) {
        if let filepath = file as? String{
            let url = NSURL.fileURL(withPath: filepath)
            self.pathExtension = url.pathExtension
            self.fileName = url.lastPathComponent
            self.media = try! Data(contentsOf: url)
            self.mimType = SMUtility.mimeType(forPath:url)
        }else if  let fileurl = file as? URL {
            self.pathExtension = fileurl.pathExtension
            self.fileName = fileurl.lastPathComponent
            self.media = try! Data(contentsOf: fileurl)
            self.mimType = SMUtility.mimeType(forPath:fileurl)
        }
        self.mediaUploadKey = uploadKey
        
    }
    
    
    
}


protocol SMErrorProtocol: Error {
    
    var localizedTitle: String { get }
    var localizedDescription: String { get }
    var code: Int { get }
}
struct SMError: SMErrorProtocol {
    
    var localizedTitle: String
    var localizedDescription: String
    var code: Int
    
    init(localizedTitle: String?, localizedDescription: String, code: Int) {
        self.localizedTitle = localizedTitle ?? "Error"
        self.localizedDescription = localizedDescription
        self.code = code
    }
}
extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}

