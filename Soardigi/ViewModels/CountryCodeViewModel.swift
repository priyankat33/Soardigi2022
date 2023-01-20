//
//  CountryCodeViewModel.swift
//  Soardigi
//
//  Created by Developer on 19/10/22.
//

import UIKit
struct CountryModel {
    var code: String?
    var name: String?
    var phoneCode: String?
    var flag: UIImage? {
        guard let code = self.code else { return nil }
        return UIImage(named: "SwiftCountryPicker.bundle/Images/\(code.uppercased())", in: Bundle.main, compatibleWith: nil)
    }
    
    init(code: String?, name: String?, phoneCode: String?) {
        self.code = code
        self.name = name
        self.phoneCode = phoneCode
    }
}

class CountryCodeViewModel: NSObject {
    
    fileprivate var countries = [CountryModel]()
    //var countries = [CountryModel]()
    func getcountryNamesByCode(OnCompletion:@escaping ()->Void) {
        countries.removeAll()
        let frameworkBundle = Bundle(for: type(of: self))
        guard let jsonPath = frameworkBundle.path(forResource: "SwiftCountryPicker.bundle/Data/countryCodes", ofType: "json"), let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
            
           // alertMessage = "Worng json path"
            return
        }
        
        do {
            if let jsonObjects = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray {
                
                for jsonObject in jsonObjects {
                    
                    guard let countryObj = jsonObject as? NSDictionary, let code = countryObj["code"] as? String, let phoneCode = countryObj["dial_code"] as? String, let name = countryObj["name"] as? String else {
                       // alertMessage = "No Data found"
                        return
                    }
                    
                    let country = CountryModel(code: code, name: name, phoneCode: phoneCode)
                    countries.append(country)
                }
                if countries.count>0{
                    OnCompletion()
                }
            }
        } catch {
           // alertMessage = error.localizedDescription
        }
    }
    
    
    
    func getcountryNamesBySearch(_ name:String,OnCompletion:@escaping ()->Void) {
        countries.removeAll()
        let frameworkBundle = Bundle(for: type(of: self))
        guard let jsonPath = frameworkBundle.path(forResource: "SwiftCountryPicker.bundle/Data/countryCodes", ofType: "json"), let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
          //  alertMessage = "Worng json path"
            return
        }
        
        do {
            if let jsonObjects = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray {
                
                for jsonObject in jsonObjects {
                    
                    guard let countryObj = jsonObject as? NSDictionary, let code = countryObj["code"] as? String, let phoneCode = countryObj["dial_code"] as? String, let name = countryObj["name"] as? String else {
              //          alertMessage = "No Data found"
                        return
                    }
                    
                    let country = CountryModel(code: code, name: name, phoneCode: phoneCode)
                    countries.append(country)
                }
                if countries.count>0{
                    
                    let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", name)
                    
                    countries = countries.filter { searchPredicate.evaluate(with: ($0).name) }
                    
                    let filterArray = countries.map {($0 ).code}
                    
                    
                    
                    //                    let predicate = NSPredicate(format: "name contains %@", name)
                    //                    let searchDataSource = countries.filter { predicate.evaluate(with: $0) }
                    
                    
                  
                    OnCompletion()
                }
            }
        } catch {
           // alertMessage = error.localizedDescription
        }
    }
}
extension CountryCodeViewModel{
    func numberOfRow()->Int{
        return self.countries.count
    }
    func cellForItem(at indexPath:IndexPath)->CountryModel?{
        return self.countries[indexPath.row]
    }
    
    func search(_ name:String) -> Void {
        print("THE SEARCH------>",name)
    }
}
