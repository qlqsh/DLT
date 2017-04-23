//
//  WinningBallView.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/6.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit

/// 获奖号码视图（5个红球、2个蓝球）
/// - 默认大小：width:40*7 height:40
class WinningBallView: UIView {
    static let defaultWidth: CGFloat = 280
    static let defaultHeight: CGFloat = 40
    private var ballArray = [BallView]()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 280, height: 40))
        
        for i in 1...5 {
            let redBallView = BallView(frame: CGRect(x: (i-1)*40, y: 0, width: 40, height: 40))
            redBallView.setState(state: 2)
            ballArray.append(redBallView)
            self.addSubview(redBallView)
        }
        for i in 1...2 {
            let blueBallView = BallView(frame: CGRect(x: (i+5-1)*40, y: 0, width: 40, height: 40))
            blueBallView.setState(state: 3)
            ballArray.append(blueBallView)
            self.addSubview(blueBallView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// 缩放获奖视图
    ///
    /// - Parameter scale: 缩放比例
    func setScale(scale: CGFloat) {
        self.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
    
    /// 设定获奖号码
    func setTextContent(textArray: Array<String>) {
        if ballArray.count == textArray.count {
            var i = 0
            for text in textArray {
                ballArray[i].titleLabel.text = text
                i += 1
            }
        }
    }
    
    /// 设定背景状态
    func setStateContent(stateArray: Array<Int>) {
        if ballArray.count == stateArray.count {
            var i = 0
            for state in stateArray {
                ballArray[i].setState(state: state)
                i += 1
            }
        }
    }
}
