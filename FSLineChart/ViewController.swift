//
//  ViewController.m
//  FSLineChart
//
//  Created by Arthur GUIBERT on 30/09/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

import UIKit

class ViewController : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(chart1())
        self.view.addSubview(chart2())
        //self.view.addSubview(chart3())
        self.view.addSubview(chart4())
    }
    
    private func chart1() -> FSLineChart {
    
        // Creating the line chart
        let lineChart = FSLineChart(frame: CGRect(x: 20, y: 60, width: UIScreen.mainScreen().bounds.size.width - 40, height: 166))
    
        lineChart.verticalGridStep = 5;
        lineChart.horizontalGridStep = 9;
        lineChart.valueLabelPosition = ValueLabelPositionType.Right
        
        lineChart.labelForIndex = { number in "\(number)" }
        lineChart.labelForValue = { number in "\(number)" }
    
        // Generating some dummy data
        var dataPoints: [CGPoint] = []
        
        for i in 0...9 {
            let r = CGFloat((arc4random()) % 1000)
            dataPoints.append(CGPoint(x: CGFloat(i), y: CGFloat(r - 400.0)))
        }

        let line = FSLine(lineColor: UIColor.blueColor(), fillColor: UIColor.blueColor().colorWithAlphaComponent(0.25), dataPoints: dataPoints)
        lineChart.setLines([line])
    
        return lineChart;
    }
    
    private func chart2() -> FSLineChart {
    
        // Creating the line chart
        let lineChart = FSLineChart(frame: CGRect(x: 20, y: 260, width: UIScreen.mainScreen().bounds.size.width - 40, height: 166))
    
        lineChart.verticalGridStep = 3
        lineChart.horizontalGridStep = 2
        lineChart.valueLabelPosition = ValueLabelPositionType.Right
        lineChart.bezierSmoothing = false

        lineChart.labelForIndex = { number in "\(number)%"}
        lineChart.labelForValue = { number in String.localizedStringWithFormat("%.02f €", Double(number)) }
    
        // Generating some dummy data
        var dataPoints: [CGPoint] = []

        for i in 0...100 {
            let value = CGFloat(i) / 30.0 + CGFloat(arc4random() % 100) / 200.0
            dataPoints.append(CGPoint(x: CGFloat(i), y: value))
        }
        
        
        let line = FSLine(lineColor: UIColor.orangeColor(), fillColor: nil, dataPoints: dataPoints)
        lineChart.setLines([line])
        
        return lineChart;
    }
    
    private func chart3() -> FSLineChart {

        let months: [String] = ["January", "February", "March", "April", "May", "June", "July"]
    
        // Creating the line chart
        let lineChart = FSLineChart(frame: CGRect(x: 20, y: 460, width: UIScreen.mainScreen().bounds.size.width - 40, height: 166))
    
        lineChart.verticalGridStep = 6;
        lineChart.horizontalGridStep = 3; // 151,187,205,0.2
        lineChart.valueLabelPosition = ValueLabelPositionType.Right
        lineChart.bezierSmoothing = false
        
        lineChart.labelForIndex = { number in months[Int(ceil(number))] }
        lineChart.labelForValue = { number in String.localizedStringWithFormat("%.02f €", Double(number)) }
    
    
        // Generating some dummy data
        var dataPoints: [CGPoint] = []
        
        for i in 0...6 {
            let value = CGFloat(i) / 30.0 + CGFloat(arc4random() % 100) / 500.0
            dataPoints.append(CGPoint(x: CGFloat(i), y: value))
        }
        
        let lineColor = UIColor(red: 151.0/255.0, green: 187.0/255.0, blue: 205.0/255.0, alpha: 1.0)
        let line = FSLine(lineColor: lineColor, fillColor: lineColor.colorWithAlphaComponent(0.3), dataPoints: dataPoints)
        lineChart.setLines([line])
        
        return lineChart;
    }
    
    private func chart4() -> FSLineChart {
        let chart = FSLineChart(frame: CGRect(x: 45, y: 460, width: UIScreen.mainScreen().bounds.size.width - 65, height: 200))
        chart.verticalGridStep = 3
        chart.horizontalGridStep = 4
        chart.bezierSmoothing = false
        
        chart.labelForIndex = { number in return "\(number)$" }
        chart.labelForValue = { number in return "\(number)%" }
        
        var line1Data: [CGPoint] = []
        line1Data.append(CGPoint(x: 0, y: 2.5))
        line1Data.append(CGPoint(x: 1, y: 4.6))
        line1Data.append(CGPoint(x: 2, y: 1.8))
        line1Data.append(CGPoint(x: 3, y: 2.8))
        let line1 = FSLine(lineColor: UIColor.orangeColor(), fillColor: nil, dataPoints: line1Data)
        
        var line2Data: [CGPoint] = []
        line2Data.append(CGPoint(x: 0, y: 4.3))
        line2Data.append(CGPoint(x: 1, y: 2.6))
        line2Data.append(CGPoint(x: 3, y: 4.6))
        let line2 = FSLine(lineColor: UIColor.blueColor(), fillColor: nil, dataPoints: line2Data)

        chart.setLines([line1, line2])
        
        return chart
    }
}
