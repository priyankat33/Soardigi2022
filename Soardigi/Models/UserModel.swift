//
//  UserModel.swift
//  ReNourish
//
//  Created by Chandan on 09/11/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation


struct UserModel:Mappable{
   
    var authKey,name,email,image:String?
   
    var id,loginType,isSocialLogin:Int?
   
    enum CodingKeys: String, CodingKey {
       
        case authKey = "authKey"
        case isSocialLogin = "isSociallogin"
        case id = "id"
        case loginType = "loginType"
        case name = "username"
        case email = "email"
        case image = "image"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
       
        authKey = try values.decodeIfPresent(String.self, forKey: .authKey) ?? ""
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        email = try values.decodeIfPresent(String.self, forKey: .email) ?? ""
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
        isSocialLogin = try values.decodeIfPresent(Int.self, forKey: .isSocialLogin) ?? 0
        id  = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        loginType = try values.decodeIfPresent(Int.self, forKey: .loginType) ?? 0
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
       
        try container.encode(authKey, forKey: .authKey)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(image, forKey: .image)
        
        
        try container.encode(id, forKey: .id)
        
        try container.encode(isSocialLogin, forKey: .isSocialLogin)
        try container.encode(loginType, forKey: .loginType)
        
        
    }
}




struct PaymentModel:Mappable{
   
    var description:String?
   
  
   
    enum CodingKeys: String, CodingKey {
       
        case description = "description"
       
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
       
        description = try values.decodeIfPresent(String.self, forKey: .description) ?? ""
        
    }
    
}

struct PaymentPolicyModel:Mappable{
   
    var paymentPolicy:String?
   
  
   
    enum CodingKeys: String, CodingKey {
       
        case paymentPolicy = "content"
       
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
       
        paymentPolicy = try values.decodeIfPresent(String.self, forKey: .paymentPolicy) ?? ""
        
    }
    
}
