RSLineChart is a completey 'Swifted' fork of FSLineChart
===========

It's still A line chart library for iOS!

Screenshots
---
<img src="Screenshots/fslinechart.png" width="320px" />&nbsp;
<img src="Screenshots/fslinechart2.png" width="320px" />

Installing RSLineChart
---
Coming Soon!

How to use
---
RSLineChart is a subclass of UIView so it can be added as regular view. The block structure allows you to format the values displayed on the chart the way you want. Here is a simple example:

```swift
        let lineChart = RSLineChart(frame: CGRect(x: 20, y: 60, width: UIScreen.mainScreen().bounds.size.width - 40, height: 166))
    
        lineChart.verticalGridStep = 5;
        lineChart.horizontalGridStep = 9;
        lineChart.valueLabelPosition = ValueLabelPositionType.Right
        
        lineChart.labelForIndex = { number in "\(number)" }
        lineChart.labelForValue = { number in "\(number)" }
    
        var dataPoints: [CGPoint] = []
        for i in 0...9 {
            let r = CGFloat((arc4random()) % 1000)
            dataPoints.append(CGPoint(x: CGFloat(i), y: CGFloat(r - 400.0)))
        }

        let line = RSLine(lineColor: UIColor.blueColor(), fillColor: UIColor.blueColor().colorWithAlphaComponent(0.25), dataPoints: dataPoints)
        lineChart.setLines([line])
  ```
  
  
  Here is an example with 2 lines:
  
  ```swift
        let chart = RSLineChart(frame: CGRect(x: 45, y: 460, width: UIScreen.mainScreen().bounds.size.width - 65, height: 200))
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
        let line1 = RSLine(lineColor: UIColor.orangeColor(), fillColor: nil, dataPoints: line1Data)
        
        var line2Data: [CGPoint] = []
        line2Data.append(CGPoint(x: 0, y: 4.3))
        line2Data.append(CGPoint(x: 1, y: 2.6))
        line2Data.append(CGPoint(x: 3, y: 4.6))
        let line2 = RSLine(lineColor: UIColor.blueColor(), fillColor: nil, dataPoints: line2Data)

        chart.setLines([line1, line2])
```

You can also set several parameters:

```swift
    // Index label properties
    var indexLabelBackgroundColor: UIColor!
    var indexLabelTextColor: UIColor!
    var indexLabelFont: UIFont!
    
    // Value label properties
    var valueLabelBackgroundColor: UIColor!
    var valueLabelTextColor: UIColor!
    var valueLabelFont: UIFont!
    var valueLabelPosition: ValueLabelPositionType!
    
    // Number of visible step in the chart
    var verticalGridStep: Int!
    var horizontalGridStep: Int!
    
    // Margin of the chart
    var margin: CGFloat!
    
    // Let you change the axis color and the axis line width
    var axisWidth: CGFloat!
    var axisHeight: CGFloat!
    var axisLineWidth: CGFloat!
    var axisColor: UIColor!
    
    // Grid parameters
    var innerGridColor: UIColor!
    var drawInnerGrid: Bool!
    var innerGridLineWidth: CGFloat!
  
    // Animations
    var animationDuration: CGFloat!
    
    // Chart level settings that will become line level settings
    var bezierSmoothing: Bool!
    var bezierSmoothingTension: CGFloat!
    var lineWidth: CGFloat!
```

Examples
---
You can clone the repo to see a simple example. 
