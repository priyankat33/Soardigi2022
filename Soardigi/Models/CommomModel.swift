//
//  CommomModel.swift
//  Netpune Security
//
//  Created by Developer on 12/04/21.
//

import Foundation

struct LanguageResponseMainModel:Mappable {
    let status : Bool?
    var languages:[LanguageResponseModel]?
    enum CodingKeys: String, CodingKey {
        case status  = "success"
        case languages = "languages"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
       status = try values.decodeIfPresent(Bool.self, forKey: .status)
        guard let languages =  try values.decodeIfPresent([LanguageResponseModel].self, forKey: .languages) else{ return }
        self.languages = languages
    }
}

struct GetUserResponseMainModel:Mappable {
    let status : Bool?
    var user:UserResponseModel?
    enum CodingKeys: String, CodingKey {
        case status  = "success"
        case user = "user"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
       status = try values.decodeIfPresent(Bool.self, forKey: .status)
        guard let user =  try values.decodeIfPresent(UserResponseModel.self, forKey: .user) else{ return }
        self.user = user
    }
}


struct BusinessCategoryModel:Mappable {
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case name  = "name"
     }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}


struct CategoryPickerMainModel:Mappable {
    let status : Bool?
    var businessModel:[BusinessModel]?
    enum CodingKeys: String, CodingKey {
        case status  = "success"
        case businessModel = "businesses"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
       status = try values.decodeIfPresent(Bool.self, forKey: .status)
        guard let businessModel =  try values.decodeIfPresent([BusinessModel].self, forKey: .businessModel) else{ return }
        self.businessModel = businessModel
    }
}

struct BusinessModel:Mappable {
    let name, thumbnail : String?
    var businessCategoryModel:BusinessCategoryModel?
    enum CodingKeys: String, CodingKey {
        case name  = "name"
        case thumbnail = "thumbnail"
        case businessCategoryModel = "category"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail)
        guard let businessCategoryModel =  try values.decodeIfPresent(BusinessCategoryModel.self, forKey: .businessCategoryModel) else{ return }
        self.businessCategoryModel = businessCategoryModel
    }
}


struct HomeResponseMainModel:Mappable {
    let status : Bool?
    var business:BusinessModel?
    var homeSliderResponseModel:[HomeSliderResponseModel]?
    var homeCategoryResponseModel:[HomeCategoryResponseModel]?
    enum CodingKeys: String, CodingKey {
        case status  = "success"
        case homeSliderResponseModel = "sliders"
        case homeCategoryResponseModel = "homeItem"
        case business = "business"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
       status = try values.decodeIfPresent(Bool.self, forKey: .status)
        
        guard let homeSliderResponseModel =  try values.decodeIfPresent([HomeSliderResponseModel].self, forKey: .homeSliderResponseModel)
        else{ return }
        
        self.homeSliderResponseModel = homeSliderResponseModel
        
        guard let businessModel =  try values.decodeIfPresent(BusinessModel.self, forKey: .business) else{ return }
        self.business = businessModel
        
        guard let homeCategoryResponseModel =  try values.decodeIfPresent([HomeCategoryResponseModel].self, forKey: .homeCategoryResponseModel) else{ return }
        self.homeCategoryResponseModel = homeCategoryResponseModel
    }
}


struct BusinessCategoryResponseMainModel:Mappable {
    let status : Bool?
    var businessCategoryResponseModel:[BusinessCategoryResponseModel]?
    enum CodingKeys: String, CodingKey {
        case status  = "success"
        case businessCategoryResponseModel = "categories"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        guard let businessCategoryResponseModel =  try values.decodeIfPresent([BusinessCategoryResponseModel].self, forKey: .businessCategoryResponseModel) else{ return }
        self.businessCategoryResponseModel = businessCategoryResponseModel
    }
}




struct BusinessFrameResponseMainModel:Mappable {
    let status : Bool?
    var frames:[ImageFrameResponseModel]?
    enum CodingKeys: String, CodingKey {
        case status  = "success"
        case frames = "frames"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
       status = try values.decodeIfPresent(Bool.self, forKey: .status)
        guard let frames =  try values.decodeIfPresent([ImageFrameResponseModel].self, forKey: .frames) else{ return }
        self.frames = frames
    }
}

struct BusinessCategoryResponseMainModel1:Mappable {
    let status : Bool?
    var businessCategoryResponseModel:[BusinessCategoryResponseModel1]?
    enum CodingKeys: String, CodingKey {
        case status  = "success"
        case businessCategoryResponseModel = "categories"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        guard let businessCategoryResponseModel =  try values.decodeIfPresent([BusinessCategoryResponseModel1].self, forKey: .businessCategoryResponseModel) else{ return }
        self.businessCategoryResponseModel = businessCategoryResponseModel
    }
}

struct HomeDetailResponseMainModel:Mappable {
    let status : Bool?
    var frames:[CategoryImagesResponseModel]?
    enum CodingKeys: String, CodingKey {
        case status  = "success"
        case frames = "images"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
       status = try values.decodeIfPresent(Bool.self, forKey: .status)
        guard let frames =  try values.decodeIfPresent([CategoryImagesResponseModel].self, forKey: .frames) else{ return }
        self.frames = frames
    }
}

struct HomeDetailFrameResponseMainModel:Mappable {
    let status : Bool?
    var frames:[FrameImagesResponseModel]?
    enum CodingKeys: String, CodingKey {
        case status  = "success"
        case frames = "bFrames"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
       status = try values.decodeIfPresent(Bool.self, forKey: .status)
        guard let frames =  try values.decodeIfPresent([FrameImagesResponseModel].self, forKey: .frames) else{ return }
        self.frames = frames
    }
}

struct HomeDetailVideoResponseMainModel:Mappable {
    let status : Bool?
    var frames:[CategoryImagesResponseModel]?
    enum CodingKeys: String, CodingKey {
        case status  = "success"
        case frames = "videos"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
       status = try values.decodeIfPresent(Bool.self, forKey: .status)
        guard let frames =  try values.decodeIfPresent([CategoryImagesResponseModel].self, forKey: .frames) else{ return }
        self.frames = frames
    }
}

struct SaveBusinessFrameResponseMainModel:Mappable {
    let status : Bool?
   
    enum CodingKeys: String, CodingKey {
        case status  = "success"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
       status = try values.decodeIfPresent(Bool.self, forKey: .status)
    }
}


struct BusinessSaveResponseMainModel:Mappable {
    let status : Bool?
    let message, token: String?
    enum CodingKeys: String, CodingKey {
        case status  = "success"
        case message = "message"
        case token = "token"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
       status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }
}

struct UserResponseModel1:Mappable {
   
    let message,token : String?
    var success:Bool = false
    enum CodingKeys: String, CodingKey {
       
        case message = "message"
        case token = "token"
        case success = "success"
        
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        message =   try values.decodeIfPresent(String.self, forKey: .message)
        token =   try values.decodeIfPresent(String.self, forKey: .token)
        success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? false
    }
}

struct HomeSliderResponseModel:Mappable {
   
    let image: String?
   
    enum CodingKeys: String, CodingKey {
        case image = "image"
      }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        image =   try values.decodeIfPresent(String.self, forKey: .image)
    }
}

struct HomeCategoryResponseModel:Mappable {
   
    let title,id: String?
    var categoryImagesResponseModel:[CategoryImagesResponseModel]?
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case categoryImagesResponseModel = "iTemplates"
        case id = "id"
      }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title =   try values.decodeIfPresent(String.self, forKey: .title)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        guard let categoryImagesResponseModel =  try values.decodeIfPresent([CategoryImagesResponseModel].self, forKey: .categoryImagesResponseModel) else{ return }
        self.categoryImagesResponseModel = categoryImagesResponseModel
    }
}

struct CategoryImagesResponseModel:Mappable {
   
    let image,id,videoUrl: String?
   
    enum CodingKeys: String, CodingKey {
        case image = "thumbnail"
        case id = "id"
        case videoUrl
      }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        image =   try values.decodeIfPresent(String.self, forKey: .image)
        id =   try values.decodeIfPresent(String.self, forKey: .id)
        videoUrl =   try values.decodeIfPresent(String.self, forKey: .videoUrl)
    }
}

struct FrameImagesResponseModel:Mappable {
   
    let image: String?
    let id:Int?
    enum CodingKeys: String, CodingKey {
        case image = "frame_url"
        case id = "id"
        
      }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        image =   try values.decodeIfPresent(String.self, forKey: .image)
        id =   try values.decodeIfPresent(Int.self, forKey: .id)
    }
}

struct LanguageResponseModel:Mappable {
   
    let name: String?
    let id,selected:Int?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
        case selected
      }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name =   try values.decodeIfPresent(String.self, forKey: .name)
        id =   try values.decodeIfPresent(Int.self, forKey: .id)
        selected =   try values.decodeIfPresent(Int.self, forKey: .selected)
    }
}

struct UserResponseModel:Mappable {
   
    let email,name,profile,mobile_no,code,ref_code: String?
    let points:Int?
    enum CodingKeys: String, CodingKey {
        case email,name,profile,mobile_no,code,ref_code
        case points
      }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        email =   try values.decodeIfPresent(String.self, forKey: .email)
        name =   try values.decodeIfPresent(String.self, forKey: .name)
        profile =   try values.decodeIfPresent(String.self, forKey: .profile)
        mobile_no =   try values.decodeIfPresent(String.self, forKey: .mobile_no)
        code =   try values.decodeIfPresent(String.self, forKey: .code)
        ref_code =   try values.decodeIfPresent(String.self, forKey: .ref_code)
        points =   try values.decodeIfPresent(Int.self, forKey: .points)
    }
}


struct BusinessCategoryResponseModel:Mappable {
   
    let name,thumbnail: String?
    let id:Int?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case thumbnail = "thumbnail"
        case id = "id"
      }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name =   try values.decodeIfPresent(String.self, forKey: .name)
        thumbnail =   try values.decodeIfPresent(String.self, forKey: .thumbnail)
        id =   try values.decodeIfPresent(Int.self, forKey: .id)
    }
}


struct BusinessCategoryResponseModel1:Mappable {
   
    let name,thumbnail: String?
    let id:String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case thumbnail = "thumbnail"
        case id = "id"
      }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name =   try values.decodeIfPresent(String.self, forKey: .name)
        thumbnail =   try values.decodeIfPresent(String.self, forKey: .thumbnail)
        id =   try values.decodeIfPresent(String.self, forKey: .id)
    }
}

struct ImageFrameResponseModel:Mappable {
   
    let img_url: String?
    let id:Int?
    var selected:Bool = false
    
    enum CodingKeys: String, CodingKey {
        case img_url = "img_url"
        case id = "id"
      }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        img_url =   try values.decodeIfPresent(String.self, forKey: .img_url)
       
        id =   try values.decodeIfPresent(Int.self, forKey: .id)
    }
}
