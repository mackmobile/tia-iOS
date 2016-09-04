//
//  extension.swift
//  MackTIA
//
//  Created by joaquim on 21/08/15.
//  Copyright (c) 2015 Mackenzie. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

// MARK: String
extension String  {
    var md5: String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.dealloc(digestLen)
        
        return String(format: hash as String)
    }
}


// MARK: UIColor
extension UIColor {
    convenience init (hex:String) {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        if (cString.characters.count != 6) {
            self.init()
            return
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
}

extension CLLocation {
    convenience init(location: CLLocationCoordinate2D) {
        self.init(latitude: location.latitude, longitude: location.longitude)
    }
}

extension UIImage {
    func insertText(text text: String, size: CGFloat, offset: CGFloat, color: UIColor) -> UIImage {
        let img = self.tintPhoto(color)
        let label = UILabel(frame: CGRect(origin: CGPoint.zero, size: img.size))
        label.text = text
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.boldSystemFontOfSize(size)
        label.textAlignment = NSTextAlignment.Center
        UIGraphicsBeginImageContextWithOptions(img.size, false, 0.0)
        img.drawInRect(CGRect(origin: CGPoint.zero, size: img.size))
        label.drawTextInRect(CGRect(origin: CGPoint(x: 0, y: -img.size.height*offset), size: img.size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /**
     Tint, Colorize image with given tint color<br><br>
     This is similar to Photoshop's "Color" layer blend mode<br><br>
     This is perfect for non-greyscale source images, and images that have both highlights and shadows that should be preserved<br><br>
     white will stay white and black will stay black as the lightness of the image is preserved<br><br>
     
     <img src="http://yannickstephan.com/easyhelper/tint1.png" height="70" width="120"/>
     
     **To**
     
     <img src="http://yannickstephan.com/easyhelper/tint2.png" height="70" width="120"/>
     
     - parameter tintColor: UIColor
     
     - returns: UIImage
     */
    public func tintPhoto(tintColor: UIColor) -> UIImage {
        
        return modifiedImage { context, rect in
            // draw black background - workaround to preserve color of partially transparent pixels
            CGContextSetBlendMode(context, .Normal)
            UIColor.blackColor().setFill()
            CGContextFillRect(context, rect)
            
            // draw original image
            CGContextSetBlendMode(context, .Normal)
            CGContextDrawImage(context, rect, self.CGImage)
            
            // tint image (loosing alpha) - the luminosity of the original image is preserved
            CGContextSetBlendMode(context, .Color)
            tintColor.setFill()
            CGContextFillRect(context, rect)
            
            // mask by alpha values of original image
            CGContextSetBlendMode(context, .DestinationIn)
            CGContextDrawImage(context, rect, self.CGImage)
        }
    }
    /**
     Tint Picto to color
     
     - parameter fillColor: UIColor
     
     - returns: UIImage
     */
    public func tintPicto(fillColor: UIColor) -> UIImage {
        
        return modifiedImage { context, rect in
            // draw tint color
            CGContextSetBlendMode(context, .Normal)
            fillColor.setFill()
            CGContextFillRect(context, rect)
            
            // mask by alpha values of original image
            CGContextSetBlendMode(context, .DestinationIn)
            CGContextDrawImage(context, rect, self.CGImage)
        }
    }
    /**
     Modified Image Context, apply modification on image
     
     - parameter draw: (CGContext, CGRect) -> ())
     
     - returns: UIImage
     */
    private func modifiedImage(@noescape draw: (CGContext, CGRect) -> ()) -> UIImage {
        
        // using scale correctly preserves retina images
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context: CGContext! = UIGraphicsGetCurrentContext()
        assert(context != nil)
        
        // correctly rotate image
        CGContextTranslateCTM(context, 0, size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        let rect = CGRectMake(0.0, 0.0, size.width, size.height)
        
        draw(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

@IBDesignable
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = newValue > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    @IBInspectable var borderColor: UIColor? {
        get {
            if let layerColor = self.layer.borderColor {
                return UIColor(CGColor: layerColor)
            }
            else {
                return nil
            }
        }
        set {
            self.layer.borderColor = newValue?.CGColor
        }
    }
}

extension Array {
    func contains<T where T : Equatable>(obj: T) -> Bool {
        return self.filter({$0 as? T == obj}).count > 0
    }
}