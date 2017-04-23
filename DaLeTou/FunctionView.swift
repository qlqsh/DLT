//
//  FunctionCell.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/20.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit

class FunctionView: UIView {
    // MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = Common.grayColor.cgColor
        self.layer.masksToBounds = true
        
        let width = self.bounds.size.width
        let height = self.bounds.size.height * 0.2
        let locationY = self.bounds.size.height * 0.8
        descriptionLabel.frame = CGRect(x: 0, y: locationY, width: width, height: height)
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = UIColor(colorLiteralRed: 69/255.0, green: 69/255.0, blue: 69/255.0, alpha: 1.0)
        
        iconViewInit()
        descriptionLabelInit()
        
        self.addSubview(iconView)
        self.addSubview(descriptionLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - 属性设置
    private let iconView = UIView()
    private func iconViewInit() {
        let height = self.bounds.size.height * 0.8
        let space = height * 0.1
        let width = height - space * 2
        iconView.frame = CGRect(x: space, y: space, width: width, height: width)
        iconView.backgroundColor = UIColor.gray
        iconView.layer.cornerRadius = width / 2
    }
    
    private let descriptionLabel = UILabel()
    private func descriptionLabelInit() {
        let width = self.bounds.size.width
        let height = self.bounds.size.height * 0.2
        let locationY = self.bounds.size.height * 0.8
        descriptionLabel.frame = CGRect(x: 0, y: locationY, width: width, height: height)
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = UIColor(colorLiteralRed: 69/255.0, green: 69/255.0, blue: 69/255.0, alpha: 1.0)
    }
    
    // MARK: - 公开方法（改变文字描述和不同的图标）
    func setState(state: Int) {
        switch state {
        case 0:
            descriptionLabel.text = "开奖公告"
            iconView.backgroundColor = Common.redColor
            drawWinningIconView()
            break
        case 1:
            descriptionLabel.text = "走势图"
            iconView.backgroundColor = Common.blueColor
            drawTrendIconView()
            break
        case 2:
            descriptionLabel.text = "历史同期"
            iconView.backgroundColor = Common.greenColor
            drawHistorySameIconView()
            break
        case 3:
            descriptionLabel.text = "统计"
            iconView.backgroundColor = Common.orangeColor
            drawStatisticsIconView()
            break
        case 4:
            descriptionLabel.text = "相似走势"
            iconView.backgroundColor = Common.yellowColor
            drawConditionTrendIconView()
            break
        case 5:
            descriptionLabel.text = "奖金计算"
            iconView.backgroundColor = Common.cyanColor
            drawCalculateMoneyIconView()
            break
        case 6:
            descriptionLabel.text = "号码组合"
            iconView.backgroundColor = UIColor.magenta
            drawRedCombiningIconView()
            break
        case 7:
            descriptionLabel.text = "号码契合度"
            iconView.backgroundColor = UIColor.brown
            drawCompatibilityIconView()
            break
        default:
            break
        }
    }
    
    // MARK: - 不同绘图，用于图标
    /// 添加到视图层
    ///
    /// - Parameter path: 绘制的图像
    private func addToLayer(path: UIBezierPath, fill: Bool) {
        let lineLayer = CAShapeLayer()
        lineLayer.frame = iconView.bounds
        lineLayer.path = path.cgPath
        lineLayer.strokeColor = UIColor.white.cgColor
        if fill {
            lineLayer.fillColor = UIColor.white.cgColor
        } else {
            lineLayer.fillColor = UIColor.clear.cgColor
        }
        lineLayer.lineWidth = 2.0
        lineLayer.lineCap = kCALineCapRound
        iconView.layer.addSublayer(lineLayer)
    }
    
    /// 开奖公告图像（奖杯）
    private func drawWinningIconView() {
        let centerX = iconView.frame.size.width / 2
        let centerY = iconView.frame.size.height / 2
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: centerX, y: centerY))
        bezierPath.addQuadCurve(to: CGPoint(x: centerX * 0.5, y: centerY * 0.5),
                                controlPoint: CGPoint(x: centerX * 1/3, y: centerY * 2/3))
        bezierPath.addLine(to: CGPoint(x: centerX * 1.5, y: centerY * 0.5))
        bezierPath.addQuadCurve(to: CGPoint(x: centerX, y: centerY),
                                controlPoint: CGPoint(x: centerX * 2 - centerX * 1/3, y: centerX * 2/3))
        bezierPath.addLine(to: CGPoint(x: centerX, y: centerY * 1.5))
        bezierPath.addLine(to: CGPoint(x: centerX * 1.5, y: centerY * 1.5))
        bezierPath.addLine(to: CGPoint(x: centerX * 0.5, y: centerY * 1.5))
        bezierPath.addLine(to: CGPoint(x: centerX, y: centerY * 1.5))
        bezierPath.addLine(to: CGPoint(x: centerX, y: centerY))
        bezierPath.close()
        addToLayer(path: bezierPath, fill: false)
    }
    
    /// 走势图像
    private func drawTrendIconView() {
        let radius = iconView.frame.size.height/10  // 半径
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: radius*2 + radius/2, y: radius*6.5 + radius/2))
        bezierPath.addLine(to: CGPoint(x: radius*3.5 + radius/2, y: radius*3.5 + radius/2))
        bezierPath.addLine(to: CGPoint(x: radius*5.5 + radius/2, y: radius*5.5 + radius/2))
        bezierPath.addLine(to: CGPoint(x: radius*7 + radius/2, y: radius*2.5 + radius/2))
        addToLayer(path: bezierPath, fill: false)
        
        let circle1 = UIBezierPath(ovalIn: CGRect(x: radius*2, y: radius*6.5, width: radius, height: radius))
        addToLayer(path: circle1, fill: true)

        let circle2 = UIBezierPath(ovalIn: CGRect(x: radius*3.5, y: radius*3.5, width: radius, height: radius))
        addToLayer(path: circle2, fill: true)
        
        let circle3 = UIBezierPath(ovalIn: CGRect(x: radius*5.5, y: radius*5.5, width: radius, height: radius))
        addToLayer(path: circle3, fill: true)
        
        let circle4 = UIBezierPath(ovalIn: CGRect(x: radius*7, y: radius*2.5, width: radius, height: radius))
        addToLayer(path: circle4, fill: true)
    }
    
    private let pi = 3.14159265358979323846
    /// 历史同期图像
    private func drawHistorySameIconView() {
        let radius = iconView.frame.size.height/2 - iconView.frame.size.height/5
        let centerX = iconView.frame.size.height/2
        let centerY = centerX
        let arcPath = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY),
                                   radius: radius,
                                   startAngle: CGFloat((55.0*pi)/180.0),
                                   endAngle: CGFloat((395.0*pi)/180.0),
                                   clockwise: true)
        addToLayer(path: arcPath, fill: false)
        
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: centerX, y: centerY*5/8))
        linePath.addLine(to: CGPoint(x: centerX, y: centerY))
        linePath.addLine(to: CGPoint(x: centerX + centerX*1/4, y: centerY + centerY*1/4))
        addToLayer(path: linePath, fill: false)
    }
    
    /// 统计图像
    private func drawStatisticsIconView() {
        let radius = iconView.frame.size.height/2 - iconView.frame.size.height/5
        let centerX = iconView.frame.size.height/2
        let centerY = centerX
        let solidCirclePath = UIBezierPath()
        solidCirclePath.move(to: CGPoint(x: centerX, y: centerY))
        solidCirclePath.addArc(withCenter: CGPoint(x: centerX, y: centerY),
                               radius: radius,
                               startAngle: CGFloat(360*pi/180),
                               endAngle: CGFloat(270*pi/180),
                               clockwise: true)
        solidCirclePath.close()
        addToLayer(path: solidCirclePath, fill: true)
        
        let hollowCirclePath = UIBezierPath()
        hollowCirclePath.move(to: CGPoint(x: centerX*1.1, y: centerY*0.9))
        hollowCirclePath.addArc(withCenter: CGPoint(x: centerX*1.1, y: centerY*0.9),
                                radius: radius,
                                startAngle: CGFloat(270*pi/180),
                                endAngle: CGFloat(360*pi/180),
                                clockwise: true)
        hollowCirclePath.close()
        addToLayer(path: hollowCirclePath, fill: false)
    }
    
    /// 相似走势图像（九宫格样式，几个圆球）
    private func drawConditionTrendIconView() {
        let width = iconView.bounds.size.width/2/3
        let positionX = (iconView.bounds.size.width - width*3)/2
        let positionY = positionX
        let circle1 = UIBezierPath(ovalIn: CGRect(x: positionX, y: positionY, width: width, height: width))
        addToLayer(path: circle1, fill: true)
        
        let circle2 = UIBezierPath(ovalIn: CGRect(x: positionX + width, y: positionY + width, width: width, height: width))
        addToLayer(path: circle2, fill: true)
        
        let circle3 = UIBezierPath(ovalIn: CGRect(x: positionX, y: positionY + width*2, width: width, height: width))
        addToLayer(path: circle3, fill: true)
        
        let circle4 = UIBezierPath(ovalIn: CGRect(x: positionX + width*2, y: positionY + width*2, width: width, height: width))
        addToLayer(path: circle4, fill: true)
    }
    
    /// 计算奖金图像（一个放大镜🔍，里面是软妹币¥符号）
    private func drawCalculateMoneyIconView() {
        // 1、放大镜
        let radius = iconView.frame.size.width*3/5*4/5/2
        let centerX = iconView.frame.size.width*1/5 + radius
        let centerY = centerX
        let magnifierPath = UIBezierPath()
        magnifierPath.move(to: CGPoint(x: centerX, y: centerY))
        magnifierPath.addArc(withCenter: CGPoint(x: centerX, y: centerY),
                             radius: radius,
                             startAngle: CGFloat(45*pi/180),
                             endAngle: CGFloat(405*pi/180),
                             clockwise: true)
        magnifierPath.addLine(to: CGPoint(x: iconView.frame.size.width*4/5,
                                          y: iconView.frame.size.width*4/5))
        addToLayer(path: magnifierPath, fill: true)
        
        let line1 = UIBezierPath()
        line1.move(to: CGPoint(x: centerX + 1, y: centerY - 1))
        line1.addLine(to: CGPoint(x: iconView.frame.size.width*4/5 + 1,
                                  y: iconView.frame.size.width*4/5 - 1))
        addToLayer(path: line1, fill: false)
        
        let line2 = UIBezierPath()
        line2.move(to: CGPoint(x: centerX - 1, y: centerY + 1))
        line2.addLine(to: CGPoint(x: iconView.frame.size.width*4/5 - 1,
                                  y: iconView.frame.size.width*4/5 + 1))
        addToLayer(path: line2, fill: false)
        
        let moneyLabel = UILabel(frame: CGRect(x: centerX - radius, y: centerY - radius, width: radius*2, height: radius*2))
        moneyLabel.text = "¥"
        moneyLabel.textAlignment = .center
        moneyLabel.textColor = Common.cyanColor
        moneyLabel.font = UIFont.systemFont(ofSize: 45*Common.screenWidth/320)
        iconView.addSubview(moneyLabel)
    }
    
    /// 红球组合状况图像（一个方括号）
    private func drawRedCombiningIconView() {
        let space: CGFloat = 5.0
        let width = iconView.bounds.size.width/2
        let positionX = iconView.bounds.size.width/2 - width/2
        let positionY = positionX
        let circle1 = UIBezierPath(ovalIn: CGRect(x: positionX, y: positionY, width: width, height: width))
        addToLayer(path: circle1, fill: true)
        
        let circle2 = UIBezierPath(ovalIn: CGRect(x: positionX-space, y: positionY-space, width: width+space*2, height: width+space*2))
        addToLayer(path: circle2, fill: false)
    }
    
    /// 号码契合度（雷达图）
    private func drawCompatibilityIconView() {
        // 一个6边形
        let width = iconView.frame.size.width
        let bezierPath = UIBezierPath(polygonIn: CGRect(x: width*0.2, y: width*0.2, width: width*0.6, height: width*0.6), sides: 6)
        
        bezierPath.lineWidth = 5.0
        bezierPath.lineCapStyle = .round
        bezierPath.lineJoinStyle = .round
        
        addToLayer(path: bezierPath, fill: false)
    }
}
