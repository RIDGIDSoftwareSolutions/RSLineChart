//
//  FSLine.swift
//  FSLineChart
//
//  Created by Grant Hughes on 11/7/14.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

import Foundation
import UIKit

class RSLine : NSObject {
    var lineColor: UIColor!
    var fillColor: UIColor?
    var dataPoints: [CGPoint]!
        
    init(lineColor: UIColor!, fillColor: UIColor?, dataPoints: [CGPoint]) {
        self.lineColor = lineColor
        self.dataPoints = dataPoints
        self.fillColor = fillColor
    }
    
    func maxValue() -> CGFloat {
        return self.dataPoints.reduce(CGFloat.min, combine: { max($0, $1.y) })
    }
    
    func minValue() -> CGFloat {
        return self.dataPoints.reduce(CGFloat.max, combine: { min($0, $1.y) })
    }
    
    func maxIndex() -> CGFloat {
        return self.dataPoints.reduce(CGFloat.min, combine: { max($0, $1.x) })
    }
}