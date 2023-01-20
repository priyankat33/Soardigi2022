//
//  Mappable.swift
//  Sqimey
//
//  Created by apple on 01/07/19.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation

extension Encodable {
    
    func encoder() -> Data? {
        return JSN.encoder(self)
    }
    var jsonObject:Any?{
        return self.encoder()?.jsonObject
    }
    var jsonString:String?{
        return self.encoder()?.jsonString
    }
}

extension Data{
    
    func decoder<T>(_ type:T.Type) ->T? where T:Decodable{
        return JSN.decoder(T.self, from: self)
    }
    var jsonString:String?{
        return String(bytes: self, encoding: .utf8)
    }
    var jsonObject:Any?{
        do{
            return try JSONSerialization.jsonObject(with: self, options: .allowFragments)
        }catch let error{
            print("json object conversion error%@",error.localizedDescription)
            return nil
        }
        
    }
    
}
struct JSN{
    static func decoder<T>(_ type:T.Type,from data:Data)  ->T? where T:Decodable{
        let obj  = try? JSONDecoder().decode(T.self, from: data)
        return obj
    }
    static func encoder<T>(_ value: T)  -> Data? where T : Encodable{
        let encodeData  = try? JSONEncoder().encode(value)
        return encodeData
    }
}


typealias Mappable = Codable
