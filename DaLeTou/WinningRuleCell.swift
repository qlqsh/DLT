//
//  WinningRuleCell1.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/7.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit

class WinningRuleCell: UITableViewCell {
    let awardLabel = UILabel()
    let moneyLabel = UILabel()
    var winningRules = [WinningBallView]()
    
    static let heightOfCell = WinningBallView.defaultHeight * (Common.screenWidth/WinningBallView.defaultWidth) * 0.6
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let width = Common.screenWidth
        awardLabel.frame = CGRect(x: 0,
                                  y: 0,
                                  width: width * 0.2,
                                  height: WinningRuleCell.heightOfCell)
        awardLabel.textAlignment = NSTextAlignment.center
        awardLabel.font = UIFont.systemFont(ofSize: 10.0)
        self.addSubview(awardLabel)
        
        moneyLabel.frame = CGRect(x: width * 0.2,
                                  y: 0,
                                  width: width * 0.2,
                                  height: WinningRuleCell.heightOfCell)
        moneyLabel.textAlignment = NSTextAlignment.center
        moneyLabel.font = UIFont.systemFont(ofSize: 10.0)
        self.addSubview(moneyLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setRuleContent(award: String, money: String, winningRules: Array<Array<Int>>) {
        awardLabel.text = award
        moneyLabel.text = money
        
        let width = Common.screenWidth
        let scale = Common.screenWidth/WinningBallView.defaultWidth
        var i = 0
        for winningRule in winningRules {
            let winningBallView = WinningBallView()
            winningBallView.setScale(scale: 0.6 * scale)
            winningBallView.frame = CGRect(x: width * 0.4,
                                           y: CGFloat(i)*WinningRuleCell.heightOfCell,
                                           width: width * 0.6,
                                           height: WinningRuleCell.heightOfCell)
            winningBallView.setStateContent(stateArray: winningRule)
            self.addSubview(winningBallView)
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
