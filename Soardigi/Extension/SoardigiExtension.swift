//
//  SoardigiExtension.swift
//  Soardigi
//
//  Created by Developer on 19/10/22.
//

import Foundation
import UIKit
import CoreLocation
extension UIViewController{
    @IBAction func onClickBack(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickClose(_ sender:UIButton){
        self.dismiss(animated: true
                    , completion: nil)
    }

//    func fetchCurrentLoction(onSuccess:@escaping()->()){
//        LocationManager.shared.setuplocationManager()
//        LocationManager.shared.updateLocations(didUpdateLocarionCompletion: { (locations:[CLLocation], manager:CLLocationManager) in
//            print("locations.last = \(String(describing: locations.last))")
//            currentLocation = locations.last
//            
//            onSuccess()
//        }) { (error:Error, manager:CLLocationManager) in
//      }
//        
//    }

}

//MARK:- EXTENSION FOR UIIMAGE
extension UIImage {
    var png: Data                 { return self.pngData()!       }
    var highestJPEG: Data        { return self.jpegData(compressionQuality: 1.0)!  }
    var highJPEG: Data           { return self.jpegData(compressionQuality: 0.75)! }
    var mediumJPEG: Data         { return self.jpegData(compressionQuality: 0.5)!  }
    var lowQualityJPEG: Data     { return self.jpegData(compressionQuality: 0.25)! }
    var lowestQualityJPEG:Data   { return self.jpegData(compressionQuality: 0.0)!  }
    
    func tint(with fillColor: UIColor) -> UIImage? {
        let image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        fillColor.set()
        image.draw(in: CGRect(origin: .zero, size: size))
        
        guard let imageColored = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        
        UIGraphicsEndImageContext()
        return imageColored
    }
    
    
    func imageWithImage(scaledToSize newSize:CGSize) -> UIImage?
    {
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage : UIImage? =  UIGraphicsGetImageFromCurrentImageContext()  //UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        let cgImage :CGImage = self.cgImage!
        let widthRatio  = newSize.width  / CGFloat(cgImage.width)
        let heightRatio = newSize.height / CGFloat(cgImage.height)
        let width:CGFloat =  newSize.width//CGFloat(cgImage.width / 2)
        var height:CGFloat = CGFloat(newSize.width)
        if widthRatio < heightRatio {
            height =  CGFloat(cgImage.height) * CGFloat(widthRatio)
            
        }
        
        let bitsPerComponent = cgImage.bitsPerComponent
        let bytesPerRow = cgImage.bytesPerRow
        let colorSpace = cgImage.colorSpace
        let bitmapInfo = cgImage.bitmapInfo
        
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace!, bitmapInfo: bitmapInfo.rawValue)
        context?.interpolationQuality = .high
        context?.draw(cgImage, in: CGRect(origin: .zero, size: CGSize(width:width, height: height)))
        
        
        let scaledImage =  UIImage(cgImage: (context?.makeImage()!)!)
        
        return scaledImage
        
    }
}

//MARK:- Extension of the userdefaults
extension UserDefaults {
    class func NTDefault(setIntegerValue integer: Int , forKey key : String){
        UserDefaults.standard.set(integer, forKey: key)
        UserDefaults.standard.synchronize()
    }
    class func NTDefault(setObject object: Any , forKey key : String){
        UserDefaults.standard.set(object, forKey: key)
        UserDefaults.standard.synchronize()
    }
    class func NTDefault(setValue object: Any , forKey key : String){
        UserDefaults.standard.setValue(object, forKey: key)
        UserDefaults.standard.synchronize()
    }
    class func NTDefault(setBool boolObject:Bool  , forKey key : String){
        UserDefaults.standard.set(boolObject, forKey : key)
        UserDefaults.standard.synchronize()
    }
    class func NTDefault(integerForKey  key: String) -> Int{
        let integerValue : Int = UserDefaults.standard.integer(forKey: key) as Int
        UserDefaults.standard.synchronize()
        return integerValue
    }
    class func NTDefault(objectForKey key: String) -> Any {
        let object  = UserDefaults.standard.object(forKey: key)
        if (object != nil) {
            UserDefaults.standard.synchronize()
            return object!
        }else{
            UserDefaults.standard.synchronize()
            return ""
        }
        
    }
    class func NTDefault(valueForKey  key: String) -> Any {
        let value  = UserDefaults.standard.value(forKey: key)
        if (value != nil) {
            UserDefaults.standard.synchronize()
            return value!
        }else{
            return ""
        }
        
    }
    class func NTDefault(boolForKey  key : String) -> Bool {
        let booleanValue : Bool = UserDefaults.standard.bool(forKey: key) as Bool
        UserDefaults.standard.synchronize()
        return booleanValue
    }
    
    class func NTDefault(removeObjectForKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    //Save no-premitive data
//    static func NTDefault( set codble:Mappable,forKey key:String){
//
//        if let encoded = codble.encoder() {
//            let defaults = UserDefaults.standard
//            defaults.set(encoded, forKey: key)
//            defaults.synchronize()
//        }
//    }
//    static func NTDefault<T>(_ type:T.Type ,forKey key:String)->T? where T:Mappable{
//        let defaults = UserDefaults.standard
//        if let storedData = defaults.object(forKey: key) as? Data {
//            let objectValue = storedData.decoder(T.self)
//            defaults.synchronize()
//            return objectValue
//        }
//        return nil
//    }
    
    class func NTDefault(setArchivedDataObject object: Any! , forKey key : String) {
        if (object != nil) {
            let data : NSData? = NSKeyedArchiver.archivedData(withRootObject: object) as NSData?
            UserDefaults.standard.set(data, forKey: key)
            UserDefaults.standard.synchronize()
        }
        
    }
    class func NTDefault(getUnArchiveObjectforKey key: String) -> Any {
        //var objectValue : Any?
        if  let storedData  = UserDefaults.standard.object(forKey: key) as? Data{
            
            let objectValue   =  NSKeyedUnarchiver.unarchiveObject(with: storedData)
            if (objectValue != nil)  {
                UserDefaults.standard.synchronize()
                return objectValue!
                
            }else{
                UserDefaults.standard.synchronize()
                return ""
                
            }
        }else{
            //objectValue = ""
            return ""
        }
    }
}

extension String {
   
    
    var intValue:     Int?        { return NumberFormatter().number(from: self)?.intValue    }
    var int8Value:    Int8?       { return NumberFormatter().number(from: self)?.int8Value   }
    var int16Value:   Int16?      { return NumberFormatter().number(from: self)?.int16Value  }
    var int32Value:   Int32?      { return NumberFormatter().number(from: self)?.int32Value  }
    var int64Value:   Int64?      { return NumberFormatter().number(from: self)?.int64Value  }
    var floatValue:   Float?      { return NumberFormatter().number(from: self)?.floatValue  }
    var doubleValue:  Double?     { return NumberFormatter().number(from: self)?.doubleValue }
    var boolValue:    Bool?       { return NumberFormatter().number(from: self)?.boolValue   }
    var decimalValue: Decimal?    { return NumberFormatter().number(from: self)?.decimalValue}
    var binaryValue:  Data?       { return self.data(using: .utf8)                           }
    
   
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
    
    func isValidUrl() -> Bool {
            let regex = "((http|https|ftp)://)?((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
            let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
            return predicate.evaluate(with: self)
        } 
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.width
    }
    
   
    
    var length: Int {
        get {
            return self.count
        }
    }
    
    var isAlphanumericWithWhiteSpace: Bool {
        let regex = try! NSRegularExpression(pattern: ".*[^A-Z0-9a-z ].*", options: [])
        if regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil {
            return false
        }else{
            return true
        }
    }
    
    var isOnlyAlphanumeric: Bool {
        return !isEmpty && self.onlyNumbers && self.onlyAlphabet
    }
    
    var isAlphanumeric: Bool {
        
        let regex = try! NSRegularExpression(pattern: "[^a-zA-Z0-9_]", options: [])
        if regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil {
            return false
        }else{
            return true
        }
        // return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    //MARK:-isValidPassword-
    var isValidPassword: Bool
    {
        if (self.isEmpty){return false}
        let passRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{6,20}"
        let passwordTest=NSPredicate(format: "SELF MATCHES %@", passRegEx);
        return passwordTest.evaluate(with: self)
    }
    
    

    
    var validateUsername:Bool{
        if (self.isEmpty){return false}
               let userNameRegEx = "^[0-9a-zA-Z\\_]"
               let userNameTest=NSPredicate(format: "SELF MATCHES %@", userNameRegEx);
               return userNameTest.evaluate(with: self)
    }
    
   
    
    
    var removeWhiteSpace:String{
        return self.trimmingCharacters(in: .whitespaces)
    }
    var trimWhiteSpace: String{
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var isEmail: Bool {
        
        let regex = try? NSRegularExpression(pattern: "^(?!(?:(?:\\x22?\\x5C[\\x00-\\x7E]\\x22?)|(?:\\x22?[^\\x5C\\x22]\\x22?)){255,})(?!(?:(?:\\x22?\\x5C[\\x00-\\x7E]\\x22?)|(?:\\x22?[^\\x5C\\x22]\\x22?)){65,}@)(?:(?:[\\x21\\x23-\\x27\\x2A\\x2B\\x2D\\x2F-\\x39\\x3D\\x3F\\x5E-\\x7E]+)|(?:\\x22(?:[\\x01-\\x08\\x0B\\x0C\\x0E-\\x1F\\x21\\x23-\\x5B\\x5D-\\x7F]|(?:\\x5C[\\x00-\\x7F]))*\\x22))(?:\\.(?:(?:[\\x21\\x23-\\x27\\x2A\\x2B\\x2D\\x2F-\\x39\\x3D\\x3F\\x5E-\\x7E]+)|(?:\\x22(?:[\\x01-\\x08\\x0B\\x0C\\x0E-\\x1F\\x21\\x23-\\x5B\\x5D-\\x7F]|(?:\\x5C[\\x00-\\x7F]))*\\x22)))*@(?:(?:(?!.*[^.]{64,})(?:(?:(?:xn--)?[a-z0-9]+(?:-+[a-z0-9]+)*\\.){1,126}){1,}(?:(?:[a-z][a-z0-9]*)|(?:(?:xn--)[a-z0-9]+))(?:-+[a-z0-9]+)*)|(?:\\[(?:(?:IPv6:(?:(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){7})|(?:(?!(?:.*[a-f0-9][:\\]]){7,})(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){0,5})?::(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){0,5})?)))|(?:(?:IPv6:(?:(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){5}:)|(?:(?!(?:.*[a-f0-9]:){5,})(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){0,3})?::(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){0,3}:)?)))?(?:(?:25[0-5])|(?:2[0-4][0-9])|(?:1[0-9]{2})|(?:[1-9]?[0-9]))(?:\\.(?:(?:25[0-5])|(?:2[0-4][0-9])|(?:1[0-9]{2})|(?:[1-9]?[0-9]))){3}))\\]))$", options: .caseInsensitive)
        
        return regex?.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil
    }
    var checkSpecial: Bool {
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9 ].*", options: [])
        if regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil {
            return false
            
        }else{
            return true
        }
    }
    var checkAddress: Bool {
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9._@#/()-+*., ].*", options: [])
        if regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil {
            return false
            
        }else{
            return true
        }
    }

    var onlyNumbers: Bool {
        let regex = try! NSRegularExpression(pattern: ".*[^0-9].*", options: [])
        if regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil {
            return false
        }else{
            return true
        }
    }
    var isPhoneNumber: Bool
    {
        let phone_regex = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phone_regex)
        return !self.isEmpty && phoneTest.evaluate(with: self)
    }
    var onlyNumbersExpressionPlus: Bool {
        let regex = try! NSRegularExpression(pattern: ".*[^0-9+].*", options: [])
        if regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil {
            return false
        }else{
            return true
        }
    }
    var onlyAlphabet: Bool{
        
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z].*", options: [])
        if regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil {
            return false
        }else{
            return true
        }
    }
    var isAlphabetWithSpace: Bool{
        
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
        if regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil {
            return false
        }else{
            return true
        }
    }
    
    func safelyLimitedTo(length n: Int)->String {
        let c = String(self)
        if (c.count <= n) { return self }
        return String( Array(c).prefix(upTo: n) )
    }
    
    // convert string date to Date
    func timeZoneDateFormatter(timeZone :String = "UTC", localFormat:String = "MM-dd-yyyy EEE,HH:mm:ss" , serverFormat:String = "yyyy-MM-dd,HH:mm:ss") -> (date:Date?,dateTimeStr:String?,timeStr:String?){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = serverFormat
        dateFormatter.timeZone = TimeZone(abbreviation: timeZone)
        let date = dateFormatter.date(from: self)// create date from string
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = localFormat
        dateFormatter.timeZone =  TimeZone.current
        
        let dateStamp = dateFormatter.string(from: date!)
        dateFormatter.dateFormat = "h:mm a"
        let time = dateFormatter.string(from: date!)
        return (date,dateStamp,time)
        
    }
    
    
    var urlQueryAllowed:String?{
       return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    }
    
    var utfData: Data {
        return Data(utf8)
    }

    var attributedHtmlString: NSAttributedString? {

        do {
            return try NSAttributedString(data: utfData,
            options: [
                      .documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf8.rawValue
                     ], documentAttributes: nil)
        } catch {
            print("Error:", error)
            return nil
        }
    }
 
 }
