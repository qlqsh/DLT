//
//  TrendAnRowView.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/19.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit

class TrendAnRowView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setTrendBalls(balls: [Ball], hasMissing: Bool) {
        var i = 0
        var redCount = 0
        for ball in balls {
            if ball.isBall {
                let ballView = BallView(frame: CGRect(x: 2, y: 2, width: 36, height: 36))
                ballView.titleLabel.text = ball.value
                if redCount >= 5 {
                    ballView.setState(state: 3)
                } else {
                    ballView.setState(state: 2)
                }
                redCount += 1
                ballView.layer.borderWidth = 0.5
                ballView.layer.borderColor = Common.grayColor.cgColor
                let scale: CGFloat = 25/40
                ballView.transform = CGAffineTransform(scaleX: scale, y: scale)
                ballView.frame = CGRect(x: i*25, y: 0, width: 25, height: 25)
                self.addSubview(ballView)
            } else {
                let numberLabel = UILabel(frame: CGRect(x: i*25, y: 0, width: 25, height: 25))
                numberLabel.font = UIFont.systemFont(ofSize: 11.0)
                numberLabel.layer.borderWidth = 0.5
                numberLabel.layer.borderColor = Common.grayColor.cgColor
                if hasMissing {
                    numberLabel.text = ball.value
                    numberLabel.textAlignment = .center
                    numberLabel.textColor = Common.grayColor
                }
                self.addSubview(numberLabel)
            }
            i += 1
        }
    }
    
    func changeBackground() {
        self.backgroundColor = UIColor.groupTableViewBackground
    }
}
