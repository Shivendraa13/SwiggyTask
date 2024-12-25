//
//  UiView+Extension.swift
//  Swiggy Project
//
//  Created by Shivendra on 25/12/24.
//

import UIKit

//    MARK: Add Corner Radius in Inspector
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return self.borderColor
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var shaddowColor: UIColor {
        get {
            guard let shadowColor = self.layer.shadowColor else { return UIColor.clear }
            return UIColor(cgColor: shadowColor)
        }
        set {
            let colorWithAlpha = newValue.withAlphaComponent(0.5)
            self.layer.shadowColor = colorWithAlpha.cgColor
        }
    }
    
    @IBInspectable var shaddowOpacity: Float {
        get {
            return self.shaddowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return self.shadowOffset
        }
        set{
            self.layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return self.shadowRadius
        }
        set {
            self.layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var masksToBounds: Bool {
        get {
            return self.masksToBounds
        }
        set {
            self.layer.masksToBounds = newValue
        }
    }
    
    func findFirstResponder() -> UIResponder? {
           if self.isFirstResponder {
               return self
           }
           for subview in self.subviews {
               if let firstResponder = subview.findFirstResponder() {
                   return firstResponder
               }
           }
           return nil
       }
}



//    MARK: Add hex color property
extension UIColor {
    convenience init(hex: String) {
        var hexString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }

        if hexString.count != 6 {
            self.init(white: 0.5, alpha: 1.0)
            return
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
