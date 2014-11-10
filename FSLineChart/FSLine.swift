//
//  FSLine.swift
//  FSLineChart
//
//  Created by Grant Hughes on 11/7/14.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

import Foundation
import UIKit

@objc class FSLine : NSObject {
    var lineColor: UIColor!
    var fillColor: UIColor?
    var dataPoints: [(Double, Double)]!
        
    init(lineColor: UIColor!, fillColor: UIColor?, dataPoints: [(Double, Double)]) {
        self.lineColor = lineColor
        self.dataPoints = dataPoints
        self.fillColor = fillColor
    }
}