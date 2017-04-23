//
//  MyNumberCell.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/14.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit

class MyNumberCell: UITableViewCell {
    static func heightOfCell(count: Int) -> CGFloat {
        // 一行最大容纳球数量
        let ballCount = Int(Common.screenWidth) / 40
        
        if (count % ballCount == 0) {
            return 40.0 + CGFloat(count / ballCount - 1) * 40.0 + 10.0
        } else {
            return 40.0 + CGFloat(count / ballCount) * 40.0 + 10.0
        }
    }
    
    func setBalls(reds: [String], blues: [String]) {
        let ballCount = Int(Common.screenWidth) / 40
        let space = (Common.screenWidth - CGFloat(ballCount) * 40.0)/2

        var j = 0
        var i = 0
        for red in reds {
            if i % ballCount == 0 {
                j += 1
            }
            let positionX: CGFloat = space + CGFloat(i % ballCount * 40)
            let positionY: CGFloat = 5 + CGFloat((j - 1) * 40)
            let ballView = BallView(frame: CGRect(x: positionX,
                                                  y: positionY,
                                                  width: 40.0,
                                                  height: 40.0))
            ballView.setState(state: 2)
            ballView.titleLabel.text = red
            self.contentView.addSubview(ballView)
            i += 1
        }
        
        for blue in blues {
            if i % ballCount == 0 {
                j += 1
            }
            let positionX: CGFloat = space + CGFloat(i % ballCount * 40)
            let positionY: CGFloat = 5 + CGFloat((j - 1) * 40)
            let ballView = BallView(frame: CGRect(x: positionX,
                                                  y: positionY,
                                                  width: 40.0,
                                                  height: 40.0))
            ballView.setState(state: 3)
            ballView.titleLabel.text = blue
            self.contentView.addSubview(ballView)
            i += 1
        }
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
