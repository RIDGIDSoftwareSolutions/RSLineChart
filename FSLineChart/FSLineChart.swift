//
//  FSLineChart.swift
//  FSLineChart
//
//  Created by Grant Hughes on 11/7/14.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

import QuartzCore
import Foundation
import UIKit

enum ValueLabelPositionType {
    case Left, Right
}

class FSLineChart: UIView {
    
    var color: UIColor!
    var fillColor: UIColor?
    var verticalGridStep: Int!
    var horizontalGridStep: Int!
    var margin: CGFloat!
    var axisWidth: CGFloat!
    var axisHeight: CGFloat!
    var axisLineWidth: CGFloat!
    var axisColor: UIColor!
    var innerGridColor: UIColor!
    var drawInnerGrid: Bool!
    var bezierSmoothing: Bool!
    var bezierSmoothingTension: CGFloat!
    var lineWidth: CGFloat!
    var innerGridLineWidth: CGFloat!
    var animationDuration: CGFloat!
    
    var indexLabelBackgroundColor: UIColor!
    var indexLabelTextColor: UIColor!
    var indexLabelFont: UIFont!
    
    var valueLabelBackgroundColor: UIColor!
    var valueLabelTextColor: UIColor!
    var valueLabelFont: UIFont!
    var valueLabelPosition: ValueLabelPositionType!
    
    var labelForValue: ((CGFloat) -> String?)?
    var labelForIndex: ((Int) -> String?)?
    
    var minimum: CGFloat!
    var maximum: CGFloat!
    var initialPath: CGMutablePathRef?
    var newPath: CGMutablePathRef!
    
    var data: [CGFloat]!
    
    override init() {
        super.init()
        setDefaultParameters()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDefaultParameters()
    }
    
    func setDefaultParameters() {
        self.backgroundColor = UIColor.whiteColor()

        color = UIColor(red: 0.18, green: 0.67, blue: 0.84, alpha: 1.0)
        fillColor = color.colorWithAlphaComponent(0.25)
        verticalGridStep = 3
        horizontalGridStep = 3
        margin = 5
        axisWidth = self.frame.size.width - 2 * margin
        axisHeight = self.frame.size.height - 2 * margin
        axisColor = UIColor(white: 0.7, alpha: 1.0)
        innerGridColor = UIColor(white: 0.9, alpha: 1.0)
        drawInnerGrid = true;
        bezierSmoothing = true;
        bezierSmoothingTension = 0.2;
        lineWidth = 1;
        innerGridLineWidth = 0.5;
        axisLineWidth = 1;
        animationDuration = 0.5;
        
        // Labels attributes
        indexLabelBackgroundColor = UIColor.clearColor()
        indexLabelTextColor = UIColor.grayColor()
        indexLabelFont = UIFont(name: "HelveticaNeue-Light", size: 10)
        
        valueLabelBackgroundColor = UIColor(white: 1, alpha: 0.75)
        valueLabelTextColor = UIColor.grayColor()
        valueLabelFont = UIFont(name: "HelveticaNeue-Light", size: 11)
        valueLabelPosition = ValueLabelPositionType.Left
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setChartData(chartData: [CGFloat]) {
        data = chartData
        
        computeBounds()
        
        let minBound = min(minimum, 0)
        let maxBound = max(maximum, 0)
        
        // No data
        if(isnan(maximum)) {
            maximum = 1;
        }
        
        strokeChart()
        
        if(nil != labelForValue) {
            for i in 0...verticalGridStep - 1 {
                var gridStep = CGFloat(verticalGridStep)
                var index = CGFloat(i)
                var xOffset: CGFloat = valueLabelPosition == ValueLabelPositionType.Right ? axisWidth : 0
                let point = CGPoint(x: margin + xOffset,
                    y: axisHeight + margin - (index + 1) * axisHeight / gridStep)
                
                let labelText: String? = labelForValue!(minBound + (maxBound - minBound) / gridStep * (index + 1))
                
                if(nil == labelText) {
                    continue
                }
                
                let rect = CGRect(x: margin,
                    y: point.y + 2,
                    width: self.frame.size.width - margin * 2 - 4,
                    height: 14)
                
                let width = labelText!.boundingRectWithSize(rect.size,
                    options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                    attributes: [NSFontAttributeName: valueLabelFont],
                    context: nil).size.width
                
                let label = UILabel(frame: CGRect(x: point.x - width - 6, y: point.y + 2, width: width + 2, height: 14))
                label.text = labelText!;
                label.font = valueLabelFont;
                label.textColor = valueLabelTextColor;
                label.textAlignment = NSTextAlignment.Center
                label.backgroundColor = valueLabelBackgroundColor;
                
                self.addSubview(label)
            }
        }
        
        if(nil != labelForIndex) {
            let gridStep = CGFloat(horizontalGridStep)
            var scale: CGFloat = 1
            let q = data.count / horizontalGridStep;
            scale = (CGFloat)(q * horizontalGridStep) / (CGFloat)(data.count - 1);
            
            for i in 0...horizontalGridStep {
                let index = CGFloat(i)
                var itemIndex = q * i
                if(itemIndex >= data.count)
                {
                    itemIndex = data.count - 1
                }
                
                let labelText = labelForIndex!(itemIndex)
                
                if(nil == labelText) {
                    continue
                }
                
                let point = CGPoint(x: margin + index * (axisWidth / gridStep) * scale,
                    y: axisHeight + margin)
                let rect = CGRect(x: margin,
                    y: point.y + 2,
                    width: self.frame.size.width - margin * 2 - 4,
                    height: 14)
                
                let width = labelText!.boundingRectWithSize(rect.size,
                    options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                    attributes: [NSFontAttributeName: indexLabelFont],
                    context: nil).size.width
                
                let label = UILabel(frame: CGRect(x: point.x - 4, y: point.y + 2, width: width + 2, height: 14))
                label.text = labelText!;
                label.font = indexLabelFont;
                label.textColor = indexLabelTextColor;
                label.backgroundColor = indexLabelBackgroundColor;
                
                self.addSubview(label)
            }
        }
        
        self.setNeedsDisplay()
    }
    
    private func computeBounds() {
        minimum = CGFloat.max
        maximum = -CGFloat.max
        
        for i in 0...data.count - 1 {
            minimum = min(minimum, data[i])
            maximum = max(maximum, data[i])
        }
        
        // The idea is to adjust the minimun and the maximum value to display the whole chart in the view, and if possible with nice "round" steps.
        maximum = getUpperRoundNumber(maximum, gridStep: verticalGridStep)
        
        if(minimum < 0) {
            // If the minimum is negative then we want to have one of the step to be zero so that the chart is displayed nicely and more comprehensively
            var step: CGFloat!
            
            if(verticalGridStep > 3) {
                let gridStep = CGFloat(verticalGridStep - 1)
                step = abs(maximum - minimum) / gridStep
            } else {
                step = max(abs(maximum - minimum) / 2, max(abs(minimum), abs(maximum)));
            }
            
            step = getUpperRoundNumber(step, gridStep: verticalGridStep)
            
            var newMin: CGFloat = 0
            var newMax: CGFloat = 0
            let gridStep = CGFloat(verticalGridStep)
            
            if(abs(minimum) > abs(maximum)) {
                let m = ceil(abs(minimum) / step);
                
                newMin = step * m * (minimum > 0 ? 1 : -1);
                newMax = step * (gridStep - m) * (maximum > 0 ? 1 : -1);
                
            } else {
                let m = ceil(abs(maximum) / step);
                
                newMax = step * m * (maximum > 0 ? 1 : -1);
                newMin = step * (gridStep - m) * (minimum > 0 ? 1 : -1);
            }
            
            if(minimum < newMin) {
                newMin -= step;
                newMax -=  step;
            }
            
            if(maximum > newMax + step) {
                newMin += step;
                newMax +=  step;
            }
            
            minimum = newMin;
            maximum = newMax;
        }
    }
    
    private func getUpperRoundNumber(value: CGFloat, gridStep: Int) -> CGFloat {
        if(value < 0) {
            return 0;
        }
        
        // We consider a round number the following by 0.5 step instead of true round number (with step of 1)
        let logValue = log10(value)
        let scale = pow(10, floor(logValue))
        var n: CGFloat = ceil(value / scale * 4)
        
        let tmp = Int(n) % gridStep
        
        if(tmp != 0) {
            let addition = CGFloat(gridStep - tmp)
            n += addition
        }
        
        return n * scale / 4.0
    }
    
    override func drawRect(rect: CGRect) {
        self.drawGrid()
    }
    
    private func drawGrid() {
        let context = UIGraphicsGetCurrentContext()
        UIGraphicsPushContext(context)
        CGContextSetLineWidth(context, axisLineWidth)
        CGContextSetStrokeColorWithColor(context, axisColor.CGColor)
        
        // draw coordinate axis
        CGContextMoveToPoint(context, margin, margin);
        CGContextAddLineToPoint(context, margin, axisHeight + margin + 3);
        CGContextStrokePath(context);
        
        var scale: CGFloat = 1.0;
        let q = data.count / horizontalGridStep;
        scale = (CGFloat)(q * horizontalGridStep) / (CGFloat)(data.count - 1);
        
        var minBound = min(minimum, 0);
        var maxBound = max(maximum, 0);
        
        if(drawInnerGrid!) {
            for i in 0...horizontalGridStep - 1 {
                CGContextSetStrokeColorWithColor(context, innerGridColor.CGColor)
                CGContextSetLineWidth(context, innerGridLineWidth)
                
                let offset: CGFloat = CGFloat(1+i)
                let gridStep = CGFloat(horizontalGridStep)
                let point = CGPoint(x: offset * axisWidth / gridStep * scale + margin,
                                    y: margin)
                
                CGContextMoveToPoint(context, point.x, point.y)
                CGContextAddLineToPoint(context, point.x, axisHeight + margin)
                CGContextStrokePath(context)
                
                CGContextSetStrokeColorWithColor(context, axisColor.CGColor)
                CGContextSetLineWidth(context, axisLineWidth)
                CGContextMoveToPoint(context, point.x - 0.5, axisHeight + margin)
                CGContextAddLineToPoint(context, point.x - 0.5, axisHeight + margin + 3)
                CGContextStrokePath(context)
            }
            
            for i in 0...verticalGridStep {
                // If the value is zero then we display the horizontal axis
                let index = CGFloat(i)
                let gridStep = CGFloat(verticalGridStep)
                let v = maxBound - (maxBound - minBound) / gridStep * index
                
                if(v == 0) {
                    CGContextSetLineWidth(context, axisLineWidth)
                    CGContextSetStrokeColorWithColor(context, axisColor.CGColor)
                } else {
                    CGContextSetStrokeColorWithColor(context, innerGridColor.CGColor)
                    CGContextSetLineWidth(context, innerGridLineWidth)
                }
                
                let height = CGFloat(axisHeight)
                let point = CGPoint(x: margin,
                                    y: index * height / gridStep + margin)
                
                CGContextMoveToPoint(context, point.x, point.y)
                CGContextAddLineToPoint(context, axisWidth + margin, point.y)
                CGContextStrokePath(context)
            }
        }
    }
    
    private func strokeChart() {
        let minBound = min(minimum, 0)
        let maxBound = max(maximum, 0)
    
        let height = CGFloat(axisHeight)
        let scale: CGFloat = height / (maxBound - minBound)
    
        let noPath = getLinePath(0, smoothed: bezierSmoothing, closed: false)
        let path = getLinePath(scale, smoothed: bezierSmoothing, closed: false)
        let noFill = getLinePath(0, smoothed: bezierSmoothing, closed: true)
        let fill = getLinePath(scale, smoothed: bezierSmoothing, closed: true)
    
        if(nil != fillColor) {
            let fillLayer = CAShapeLayer()
            fillLayer.frame = CGRect(x: self.bounds.origin.x,
                y: self.bounds.origin.y + minBound * scale,
                width: self.bounds.size.width,
                height: self.bounds.size.height)
            fillLayer.bounds = self.bounds
            fillLayer.path = fill.CGPath
            fillLayer.strokeColor = nil
            fillLayer.fillColor = fillColor!.CGColor
            fillLayer.lineWidth = 0
            fillLayer.lineJoin = kCALineJoinRound
    
            self.layer.addSublayer(fillLayer)
            
            let fillAnimation = CABasicAnimation(keyPath: "path")
            fillAnimation.duration = CFTimeInterval(animationDuration)
            fillAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            fillAnimation.fillMode = kCAFillModeForwards
            fillAnimation.fromValue = noFill.CGPath
            fillAnimation.toValue = fill.CGPath
            fillLayer.addAnimation(fillAnimation, forKey: "path")
        }
    
        let pathLayer = CAShapeLayer()
        pathLayer.frame = CGRect(x: self.bounds.origin.x,
            y: self.bounds.origin.y + minBound * scale,
            width: self.bounds.size.width,
            height: self.bounds.size.height)
        pathLayer.bounds = self.bounds
        pathLayer.path = path.CGPath
        pathLayer.strokeColor = color.CGColor
        pathLayer.fillColor = nil
        pathLayer.lineWidth = lineWidth
        pathLayer.lineJoin = kCALineJoinRound
    
        self.layer.addSublayer(pathLayer)
    
        if(nil != fillColor) {
            let pathAnimation = CABasicAnimation(keyPath: "path")
            pathAnimation.duration = CFTimeInterval(animationDuration)
            pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            pathAnimation.fromValue = noPath.CGPath
            pathAnimation.toValue = path.CGPath
            
            pathLayer.addAnimation(pathAnimation, forKey: "path")
        } else {
            
            let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
            pathAnimation.duration = CFTimeInterval(animationDuration)
            pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            pathAnimation.fromValue = 0
            pathAnimation.toValue = 1
            
            pathLayer.addAnimation(pathAnimation, forKey: "strokeEnd")
        }
    }
    
    private func getLinePath(scale: CGFloat, smoothed: Bool, closed: Bool) -> UIBezierPath {
        let path = UIBezierPath()
        
        if(smoothed) {
            for i in 0...data.count - 2 {
                var currentPoint = getPointForIndex(i, scale: scale)
                
                // Start the path drawing
                if(i == 0) {
                    path.moveToPoint(currentPoint)
                }
                
                // First control point
                var nextPoint = getPointForIndex(i + 1, scale: scale)
                var previousPoint = getPointForIndex(i - 1, scale: scale)
                var m = CGPointZero
                
                if(i > 0) {
                    m.x = (nextPoint.x - previousPoint.x) / 2;
                    m.y = (nextPoint.y - previousPoint.y) / 2;
                } else {
                    m.x = (nextPoint.x - currentPoint.x) / 2;
                    m.y = (nextPoint.y - currentPoint.y) / 2;
                }
                
                let controlPoint1 = CGPoint(x: currentPoint.x + m.y * bezierSmoothingTension,
                    y: currentPoint.y + m.y * bezierSmoothingTension)
                
                // Second control point
                nextPoint = getPointForIndex(i + 2, scale: scale)
                previousPoint = getPointForIndex(i, scale: scale)
                currentPoint = getPointForIndex(i + 1, scale: scale)
                m = CGPointZero;
                
                if(i < data.count - 2) {
                    m.x = (nextPoint.x - previousPoint.x) / 2;
                    m.y = (nextPoint.y - previousPoint.y) / 2;
                } else {
                    m.x = (currentPoint.x - previousPoint.x) / 2;
                    m.y = (currentPoint.y - previousPoint.y) / 2;
                }
                
                let controlPoint2 = CGPoint(x: currentPoint.x - m.x * bezierSmoothingTension,
                    y: currentPoint.y - m.y * bezierSmoothingTension)
                
                path.addCurveToPoint(currentPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            }
            
        } else {
            for i in 0...data.count - 1 {
                if(i > 0) {
                    path.addLineToPoint(getPointForIndex(i, scale: scale))
                } else {
                    path.moveToPoint(getPointForIndex(i, scale: scale))
                }
            }
        }
        
        if(closed) {
            // Closing the path for the fill drawing
            path.addLineToPoint(getPointForIndex(data.count - 1, scale: scale))
            path.addLineToPoint(getPointForIndex(data.count - 1, scale: 0))
            path.addLineToPoint(getPointForIndex(0, scale: 0))
            path.addLineToPoint(getPointForIndex(0, scale: scale))
        }
        
        return path;
    }
    
    private func getPointForIndex(index: Int, scale: CGFloat) -> CGPoint {
        if(index < 0 || index >= data.count) {
            return CGPointZero
        }
        
        let indexFloat = CGFloat(index)
        let size = CGFloat(data.count - 1)
        let number = data[index]
        return CGPoint(x: margin + indexFloat * (axisWidth / size),
            y: axisHeight + margin - number * scale)
    }
}