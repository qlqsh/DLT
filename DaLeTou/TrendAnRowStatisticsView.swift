//
//  TrendAnRowStatisticsView.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/18.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit

class TrendAnRowStatisticsView: UIView {
    let titleLabel = UILabel()
    var numberLabels = [UILabel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.frame = CGRect(x: 0, y: 0, width: 65, height: 25)
        titleLabel.font = UIFont.systemFont(ofSize: 11.0)
        titleLabel.textAlignment = .center
        titleLabel.layer.borderWidth = 0.5
        titleLabel.layer.borderColor = Common.grayColor.cgColor
        self.addSubview(titleLabel)
        
        for i in 1...47 {
            let numberLabel = UILabel(frame: CGRect(x: 65 + (i - 1) * 25,
                                                    y: 0,
                                                    width: 25,
                                                    height: 25))
            numberLabel.layer.borderWidth = 0.5
            numberLabel.layer.borderColor = Common.grayColor.cgColor
            numberLabel.textAlignment = .center
            numberLabel.font = UIFont.systemFont(ofSize: 11.0)
            self.addSubview(numberLabel)
            numberLabels.append(numberLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setStatisticsData(data: [Int]) {
        if data.count == numberLabels.count {
            var i = 0
            for numberLabel in numberLabels {
                numberLabel.text = String(data[i])
                i += 1
            }
        }
    }
    
    func setState(state: Int) {
        var textColor = UIColor.gray
        switch state {
        case 0:
            textColor = UIColor.purple
            break
        case 1:
            textColor = UIColor.cyan
            break
        case 2:
            textColor = UIColor.brown
            break
        case 3:
            textColor = UIColor.green
            break
        default:
            textColor = UIColor.gray
            break
        }
        titleLabel.backgroundColor = UIColor(colorLiteralRed: 235.0/255.0,
                                             green: 231.0/255.0,
                                             blue: 219.0/255.0,
                                             alpha: 1.0)
        titleLabel.textColor = textColor
        if state % 2 == 1 {
            titleLabel.backgroundColor = UIColor(colorLiteralRed: 246.0/255.0,
                                                 green: 240.0/255.0,
                                                 blue: 240.0/255.0,
                                                 alpha: 1.0)
        }
        for numberLabel in numberLabels {
            numberLabel.textColor = textColor
            numberLabel.backgroundColor = UIColor.white
            if state % 2 == 1 {
                numberLabel.backgroundColor = UIColor.groupTableViewBackground
            }
        }
    }
}
