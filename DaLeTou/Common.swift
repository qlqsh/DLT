//
//  Common.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/6.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit

extension UIBezierPath {
    /// Create UIBezierPath for regular polygon with rounded corners
    ///
    /// - parameter rect:            The CGRect of the square in which the path should be created.
    /// - parameter sides:           How many sides to the polygon (e.g. 6=hexagon; 8=octagon, etc.).
    /// - parameter lineWidth:       The width of the stroke around the polygon. The polygon will be inset such that the stroke stays within the above square. Default value 1.
    /// - parameter cornerRadius:    The radius to be applied when rounding the corners. Default value 0.
    convenience init(polygonIn rect: CGRect, sides: Int, lineWidth: CGFloat = 1, cornerRadius: CGFloat = 0) {
        self.init()
        
        let theta = 2 * CGFloat.pi / CGFloat(sides)                 // how much to turn at every corner
        let offset = cornerRadius * tan(theta / 2)                  // offset from which to start rounding corners
        let squareWidth = min(rect.size.width, rect.size.height)    // width of the square
        
        // calculate the length of the sides of the polygon
        
        var length = squareWidth - lineWidth
        if sides % 4 != 0 {                                         // if not dealing with polygon which will be square with all sides ...
            length = length * cos(theta / 2) + offset / 2           // ... offset it inside a circle inside the square
        }
        let sideLength = length * tan(theta / 2)
        
        // start drawing at `point` in lower right corner, but center it
        var point = CGPoint(x: rect.origin.x + rect.size.width / 2 + sideLength / 2 - offset, y: rect.origin.y + rect.size.height / 2 + length / 2)
        var angle = CGFloat.pi
        move(to: point)
        
        // draw the sides and rounded corners of the polygon
        for _ in 0 ..< sides {
            point = CGPoint(x: point.x + (sideLength - offset * 2) * cos(angle), y: point.y + (sideLength - offset * 2) * sin(angle))
            addLine(to: point)
            
            let center = CGPoint(x: point.x + cornerRadius * cos(angle + .pi / 2), y: point.y + cornerRadius * sin(angle + .pi / 2))
            addArc(withCenter: center, radius: cornerRadius, startAngle: angle - .pi / 2, endAngle: angle + theta - .pi / 2, clockwise: true)
            
            point = currentPoint
            angle += theta
        }
        
        close()
        
        self.lineWidth = lineWidth           // in case we're going to use CoreGraphics to stroke path, rather than CAShapeLayer
        lineJoinStyle = .round
    }
}

class Common: NSObject {
    // MARK: - 颜色相关
    static let redColor = UIColor(colorLiteralRed: 230.0/255.0, green: 83.0/255.0, blue: 75.0/255.0, alpha: 1.0)
    static let blueColor = UIColor(colorLiteralRed: 2.0/255.0, green: 170.0/255.0, blue: 238.0/255.0, alpha: 1.0)
    static let greenColor = UIColor(colorLiteralRed: 10.0/255.0, green: 197.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    static let orangeColor = UIColor(colorLiteralRed: 255.0/255.0, green: 150.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    static let yellowColor = UIColor(colorLiteralRed: 253.0/255.0, green: 199.0/255.0, blue: 30.0/255.0, alpha: 1.0)
    static let cyanColor = UIColor(colorLiteralRed: 126.0/255.0, green: 212.0/255.0, blue: 228.0/255.0, alpha: 1.0)
    static let grayColor = UIColor(colorLiteralRed: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    
    
    // MARK: - 屏幕相关
    static let screenWidth = UIScreen.main.bounds.size.width
    static let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    
    // MARK: - 时间相关
    static func calculateWeekday(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month, .day, .weekday], from: date!)
        switch Int(components.weekday!) {
        case 7:
            return "周六"
        case 4:
            return "周三"
        case 2:
            return "周一"
        default:
            return "周一"
        }
    }
}
