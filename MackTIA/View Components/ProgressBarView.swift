//
//  ProgressBarView.swift
//  MackTIA
//
//  Created by joaquim on 02/11/15.
//  Copyright © 2015 Mackenzie. All rights reserved.
//

import UIKit

@IBDesignable
class ProgressBarView: UIView {
    @IBInspectable
    var endPercent:CGFloat = 0.0{   // in range of 0.0 to 1.0
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var maxPercent:CGFloat = 0.25{   // in range of 0.0 to 1.0
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var progressWidth:CGFloat = 10.0
    @IBInspectable
    var progressColor:UIColor = UIColor.yellow
    @IBInspectable
    var progressBackgroundColor:UIColor = UIColor.black
    
    
    
    override func draw(_ rect: CGRect) {
        //Important constants for circle
        let start:CGPoint   = CGPoint(x: rect.minX, y: rect.midY)
        let end:CGPoint     = CGPoint(x: rect.maxX, y: rect.midY)
        
        var aux:CGFloat = endPercent
        if endPercent > maxPercent {
            aux = maxPercent
        }
        
        //Calculating end point of progress bar
        let space:CGFloat   = end.x - start.x
        let endProgress = CGPoint(x: (space * aux)/maxPercent, y: end.y)
        
        //starting point for all drawing code is getting the context.
        let context = UIGraphicsGetCurrentContext()
        
        //set line attributes
        context?.setLineWidth(progressWidth)
        context?.setLineCap(CGLineCap.round)
        
        //make the line background
        context?.setStrokeColor(progressBackgroundColor.cgColor)
        context?.move(to: CGPoint(x: start.x, y: start.y))
        context?.addLine(to: CGPoint(x: end.x, y: end.y))
        context?.strokePath()
        
        //make the progress
        context?.setStrokeColor(progressColor.cgColor)
        context?.move(to: CGPoint(x: start.x, y: start.y))
        context?.addLine(to: CGPoint(x: endProgress.x, y: endProgress.y))
        context?.strokePath()
    }
    
}

