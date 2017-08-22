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
    var arcColor:UIColor = UIColor.yellow
    @IBInspectable
    var maxArcColor:UIColor = UIColor.green
    @IBInspectable
    var arcBackgroundColor:UIColor = UIColor.black
    
    
    
    override func draw(_ rect: CGRect) {
        //Important constants for circle
        let fullCircle = 2.0 * CGFloat(M_PI)
        let start:CGFloat = -0.25 * fullCircle
        let end:CGFloat = endArc * fullCircle + start
//        let maxStart:CGFloat = start
//        let maxEnd:CGFloat = maxArc * fullCircle + start
        
        //find the centerpoint of the rect
        let centerPoint = CGPoint(x: rect.midX, y: rect.midY)
        
        //define the radius by the smallest side of the view
        var radius:CGFloat = 0.0
        if rect.width > rect.height{
            radius = (rect.width - arcWidth) / 2.0
        }else{
            radius = (rect.height - arcWidth) / 2.0
        }
        
        
        
        
        //starting point for all drawing code is getting the context.
        let context = UIGraphicsGetCurrentContext()
        
        //set colorspace
//        let colorspace = CGColorSpaceCreateDeviceRGB()
        
        
        
        //set line attributes
        context?.setLineWidth(arcWidth)
        context?.setLineCap(CGLineCap.round)
        
        //make the circle background
        context?.setStrokeColor(arcBackgroundColor.cgColor)
        context?.addArc(center: centerPoint, radius: radius, startAngle: 0, endAngle: fullCircle, clockwise: false)
//        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, 0, fullCircle, 0)
        context?.strokePath()
        
//        //make the circle max
//        CGContextSetStrokeColorWithColor(context, maxArcColor.CGColor)
//        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, maxStart, maxEnd, 0)
//        CGContextStrokePath(context)
        
        //make the main circle
        context?.setStrokeColor(arcColor.cgColor)
        context?.addArc(center: centerPoint, radius: radius, startAngle: start, endAngle: end, clockwise: false)
//        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, start, end, 0)
        context?.strokePath()
        
        
        
//        let backgroundTrackColor = UIColor(white: 0.15, alpha: 1.0)
//        circleGraph.arcBackgroundColor = backgroundTrackColor
        
//        CGContextSetLineWidth(context, arcWidth * 0.8)
    }
    
}
