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
        self.view.addSubview(getChart())
    }
    
    private func getChart() -> FSLineChart {
        let chart = FSLineChart(frame: CGRect(x: 45, y: 260, width: UIScreen.mainScreen().bounds.size.width - 65, height: 200))
        chart.verticalGridStep = 3
        chart.horizontalGridStep = 2
        chart.fillColor = nil
        
        chart.labelForIndex = { number in return "\(number)$" }
        chart.labelForValue = { number in return "\(number)%" }
        
        var line1Data: [(CGFloat, CGFloat)] = []
        line1Data.append(1, 2.5)
        line1Data.append(2, 4.6)
        line1Data.append(3, 1.8)
        line1Data.append(4, 2.8)
        let line1 = FSLine(lineColor: UIColor.orangeColor(), fillColor: nil, dataPoints: line1Data)
        
        var chartData = [CGFloat]()
        
        for i in 0...100 {
            let index = CGFloat(i)
            let randomValue = CGFloat((rand() % 100)) / 200.0
            chartData.append(index / 30 + randomValue)
        }

        chart.setChartData(chartData)
        //chart.addLine(line1)
        
        return chart
    }
}
