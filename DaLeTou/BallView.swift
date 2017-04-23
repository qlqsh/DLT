//
//  BallView.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/6.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit

/// 一个球视图
class BallView: UIView {
    static let defaultWidth = 36    
    private let backgroundView = UIImageView()
    let titleLabel = UILabel()
    
    /// 默认40*40大小的球视图
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundView.frame = CGRect(x: 2, y: 2, width: BallView.defaultWidth, height: BallView.defaultWidth)
        backgroundView.contentMode = .scaleToFill
        self.addSubview(backgroundView)
        
        titleLabel.frame = CGRect(x: 2, y: 2, width: BallView.defaultWidth, height: BallView.defaultWidth)
        titleLabel.font = UIFont.systemFont(ofSize: 18*frame.size.width/40.0)
        titleLabel.textAlignment = NSTextAlignment.center
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    /// 设置文字颜色、背景
    ///
    /// - Parameter state: 状态
    ///     - 0 红字白底
    ///     - 1 蓝字白底
    ///     - 2 白字红底
    ///     - 3 白字蓝底
    func setState(state: Int) {
        switch state {
        case 0:
            titleLabel.textColor = Common.redColor
            backgroundView.image = UIImage(named: "WhiteBallBackground")
            break
        case 1:
            titleLabel.textColor = Common.blueColor
            backgroundView.image = UIImage(named: "WhiteBallBackground")
            break
        case 2:
            titleLabel.textColor = UIColor.white
            backgroundView.image = UIImage(named: "RedBallBackground")
            break
        case 3:
            titleLabel.textColor = UIColor.white
            backgroundView.image = UIImage(named: "BlueBallBackground")
            break
        default:
            break
        }
    }
}
