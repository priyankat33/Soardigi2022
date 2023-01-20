//
//  CustomLabel.swift
//  Sqimey
//
//  Created by apple on 27/06/19.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
@IBDesignable
class CustomLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 4.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 4.0
    @IBInspectable public var shadowColor1: UIColor = UIColor.black {
        didSet {
            
            layer.shadowColor = shadowColor1.cgColor
        }
    }
    
    @IBInspectable public var shadowOpacity: Float = 0.5 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    @IBInspectable public var shadowOffset1: CGSize = CGSize(width: 0, height: 3) {
        didSet {
            layer.shadowOffset = shadowOffset1
        }
    }
    @IBInspectable public var shadowRadius : CGFloat = 3
        {
        didSet
        {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 2.5 {
        didSet {
            layer.cornerRadius = cornerRadius
            
        }
    }
    @IBInspectable public var boarderColor: UIColor = UIColor.clear
        {
        didSet{
            layer.borderColor = boarderColor.cgColor
            
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat =  0 {
        didSet {
            layer.borderWidth = borderWidth
            
        }
    }
    @IBInspectable public var masksToBounds : Bool = false
        {
        didSet
        {
            layer.masksToBounds = masksToBounds
        }
    }
    
    
    @IBInspectable public var clipsToBound : Bool = false
        {
        didSet
        {
            self.clipsToBounds = clipsToBound
        }
    }
    var insets: UIEdgeInsets {
        get {
            return UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        }
        set {
            topInset = newValue.top
            leftInset = newValue.left
            bottomInset = newValue.bottom
            rightInset = newValue.right
        }
    }
    
    @IBInspectable var shadowBlur: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue / 2.0
        }
    }
    
    @IBInspectable var shadowSpread: CGFloat = 0 {
        didSet {
            if shadowSpread == 0 {
                layer.shadowPath = nil
            } else {
                let dx = -shadowSpread
                let rect = bounds.insetBy(dx: dx, dy: dx)
                layer.shadowPath = UIBezierPath(rect: rect).cgPath
            }
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var adjSize = super.sizeThatFits(size)
        adjSize.width += leftInset + rightInset
        adjSize.height += topInset + bottomInset
        return adjSize
    }
    
    override var intrinsicContentSize: CGSize {
        let systemContentSize = super.intrinsicContentSize
        let adjustSize = CGSize(width: systemContentSize.width + leftInset + rightInset, height: systemContentSize.height + topInset +  bottomInset)
        if adjustSize.width > preferredMaxLayoutWidth && preferredMaxLayoutWidth != 0 {
            let constraintSize = CGSize(width: bounds.width - (leftInset + rightInset), height: .greatestFiniteMagnitude)
            let newSize = super.sizeThatFits(constraintSize)
            return CGSize(width: systemContentSize.width, height: ceil(newSize.height) + topInset + bottomInset)
        } else {
            return adjustSize
        }
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
}
