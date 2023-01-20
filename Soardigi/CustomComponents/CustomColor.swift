//
//  CustomColor.swift
//  Sqimey
//
//  Created by apple on 27/06/19.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation
import UIKit
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
    convenience public init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    convenience public init(hexString colorString: String!, alpha:CGFloat = 1.0) {
        // Convert hex string to an integer
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: colorString)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        let hexint = Int(hexInt)
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    convenience public init (ColorRGB r:CGFloat ,Grean g: CGFloat ,Blue b: CGFloat,alpha:CGFloat = 1.0){
        self.init(red:r/255.0, green:g/255.0, blue:b/255.0, alpha:alpha)
    }
    
}
public struct CustomColor {
    public static let appThemeColor = UIColor(hexString: "#00B1FB")
    
   
       
    
      public static let customOrangeColor = UIColor(hexString: "#EA383B")
    
    public static let customnonOrangeColor = UIColor(hexString: "#EE9984")
    public static let customYellowColor = UIColor(hexString: "#F4B43E")
    
      public static let customRedColor = UIColor(hexString: "#EA383B")
    
    public static let customGreenColor = UIColor(hexString: "#0A9830")
    
    
    public static let appDarkGrayColor = UIColor(hexString: "#707070")
    public static let tweeterThemeColor = UIColor(hexString: "#55ACEE")
    
    public static let Red = UIColor(hex: 0xF44336)
    public static let Pink = UIColor(hex: 0xE91E63)
    public static let Purple = UIColor(hex: 0x9C27B0)
    public static let DeepPurple = UIColor(hex: 0x67AB7)
    public static let Indigo = UIColor(hex: 0x3F51B5)
    public static let Blue = UIColor(hex: 0x2196F3)
    public static let LightBlue = UIColor(hex: 0x03A9F4)
    public static let Cyan = UIColor(hex: 0x00BCD4)
    public static let Teal = UIColor(hex: 0x009688)
    public static let Green = UIColor(hex: 0x4CAF50)
    public static let LightGreen = UIColor(hex: 0x8BC34A)
    public static let Lime = UIColor(hex: 0xCDDC39)
    public static let Yellow = UIColor(hex: 0xFFEB3B)
    public static let Amber = UIColor(hex: 0xFFC107)
    public static let Orange = UIColor(hex: 0xFF9800)
    public static let DeepOrange = UIColor(hex: 0xFF5722)
    public static let Brown = UIColor(hex: 0x795548)
    public static let Grey = UIColor(hex: 0x9E9E9E)
    public static let BlueGrey = UIColor(hex: 0x607D8B)
    
    public static let skyBlue = UIColor(hexString: "#8DCDFD")
    public static let CornflowerBlue = UIColor(hexString: "#6495ED")
    public static let MountainMeadow = UIColor(hexString: "#22D05F")
    public static let DarkBlue = UIColor(hexString: "#0279C2")
    public static let extraLightGrey  = UIColor(hexString: "#EBEBF1")
    public static let placeHolderColor = UIColor(ColorRGB: 161.0, Grean: 161.0, Blue: 162.0)
    public static let navigationBarColor =  UIColor(hexString: "#ECECEC")
    public static let Downy = UIColor(hexString: "#5DCAC4")
    public static let ACRed = UIColor(hexString: "#ED1F29")
    public static let DarkYellow  = UIColor(hexString:"#F6B632")
    
    
    public static let DeepGreen  = UIColor(hexString:"#01C097")
    public static let deepRed = UIColor(hexString: "#D84132")
    public static let redColor  = UIColor(hexString:"#EC2329")
    public static let yellowColor  = UIColor(hexString:"#F7B532")
    public static let blueColor  = UIColor(hexString:"#3283E7")
    public static let unassignedColor  = UIColor(hexString:"#72818D")
    public static let deepRedColor  = UIColor(hexString:"#7a170f")
    public static let lightRedColor  = UIColor(hexString:"#b72d23")
    public static let deepGreenColor  = UIColor(hexString:"#396a07")
    public static let deepBlueColor  = UIColor(hexString:"#482eae")
    public static let lightBlueColor  = UIColor(hexString:"#9c53c7")
    public static let deepYellowColor  = UIColor(hexString:"#f49b20")
    public static let textRedColor  = UIColor(hexString:"#BD3327")
    
    
    
    
    
}

