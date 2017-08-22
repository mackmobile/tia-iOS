//
//  CircleGraphView.swift
//  MackTIA
//
//  Created by Joaquim Pessôa Filho on 9/5/15.
//  Copyright (c) 2015 Mackenzie. All rights reserved.
//

import UIKit

@IBDesignable
class CircleGraphView: UIView {
    @IBInspectable
    var endArc:CGFloat = 0.0{   // in range of 0.0 to 1.0
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var maxArc:CGFloat = 0.25{   // in range of 0.0 to 1.0
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var arcWidth:CGFloat = 10.0
    @IBInspectable
    var arcColor:UIColor = UIColor.yellowColor()
    @IBInspectable
    var maxArcColor:UIColor = UIColor.greenColor()
    @IBInspectable
    var arcBackgroundColor:UIColor = UIColor.blackColor()
    
    
    
    override func drawRect(rect: CGRect) {
        //Important constants for circle
        let fullCircle = 2.0 * CGFloat(M_PI)
        let start:CGFloat = -0.25 * fullCircle
        let end:CGFloat = endArc * fullCircle + start
//        let maxStart:CGFloat = start
//        let maxEnd:CGFloat = maxArc * fullCircle + start
        
        //find the centerpoint of the rect
        let centerPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
        
        //define the radius by the smallest side of the view
        var radius:CGFloat = 0.0
        if CGRectGetWidth(rect) > CGRectGetHeight(rect){
            radius = (CGRectGetWidth(rect) - arcWidth) / 2.0
        }else{
            radius = (CGRectGetHeight(rect) - arcWidth) / 2.0
        }
        
        
        
        
        //starting point for all drawing code is getting the context.
        let context = UIGraphicsGetCurrentContext()
        
        //set colorspace
//        let colorspace = CGColorSpaceCreateDeviceRGB()
        
        
        
        //set line attributes
        CGContextSetLineWidth(context, arcWidth)
        CGContextSetLineCap(context, CGLineCap.Round)
        
        //make the circle background
        CGContextSetStrokeColorWithColor(context, arcBackgroundColor.CGColor)
        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, 0, fullCircle, 0)
        CGContextStrokePath(context)
        
//        //make the circle max
//        CGContextSetStrokeColorWithColor(context, maxArcColor.CGColor)
//        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, maxStart, maxEnd, 0)
//        CGContextStrokePath(context)
        
        //make the main circle
        CGContextSetStrokeColorWithColor(context, arcColor.CGColor)
        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, start, end, 0)
        CGContextStrokePath(context)
        
        
        
//        let backgroundTrackColor = UIColor(white: 0.15, alpha: 1.0)
//        circleGraph.arcBackgroundColor = backgroundTrackColor
        
//        CGContextSetLineWidth(context, arcWidth * 0.8)
    }
    
}
