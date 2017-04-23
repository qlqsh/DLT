//
//  ConditionCell.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/12.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit

class ConditionCell: UITableViewCell {
    static let heightOfCell: CGFloat = 50
    private let verticalView = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    /// 绘制一个前缀视图。一条不同颜色的竖杠。
    func setVerticalViewState(state: Int) {
        verticalView.frame = CGRect(x: 4, y: 1, width: 2, height: 48)
        switch state {
        case 0:
            verticalView.backgroundColor = Common.redColor
            break
        case 1:
            verticalView.backgroundColor = Common.blueColor
            break
        case 2:
            verticalView.backgroundColor = Common.greenColor
            break
        case 3:
            verticalView.backgroundColor = Common.orangeColor
            break
        case 4:
            verticalView.backgroundColor = Common.yellowColor
            break
        case 5:
            verticalView.backgroundColor = Common.cyanColor
            break
        default:
            verticalView.backgroundColor = Common.grayColor
            break
        }
        
    }
    
    /// 一行条件（规则）。
    ///
    /// - Parameter conditionBalls: 条件（规则）球字符串。比如："06 08"，指必须过滤的获奖号码包含"06 08"。
    func setConditionBalls(conditionBalls: [String]) {
        self.contentView.addSubview(verticalView)
        
        let ballsView = UIView()
        if conditionBalls.count == 0 { // 空行
            ballsView.frame = CGRect(x: 10, y: 5, width: 40*2, height: 40)
            let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
            textLabel.text = "空行"
            textLabel.textAlignment = .center
            textLabel.textColor = Common.grayColor
            textLabel.font = UIFont.systemFont(ofSize: 20.0)
            ballsView.addSubview(textLabel)
        } else { // 非空行
            ballsView.frame = CGRect(x: 10, y: 5, width: 40*conditionBalls.count, height: 40)
            var i = 0
            for ball in conditionBalls {
                let ballView = BallView(frame: CGRect(x: 40*i, y: 0, width: 40, height: 40))
                ballView.setState(state: 2)
                ballView.titleLabel.text = ball
                ballsView.addSubview(ballView)
                i += 1
            }
        }
        
        ballsView.layer.borderWidth = 0.5
        ballsView.layer.borderColor = Common.grayColor.cgColor
        ballsView.layer.cornerRadius = 5
        
        self.contentView.addSubview(ballsView)
    }

}
