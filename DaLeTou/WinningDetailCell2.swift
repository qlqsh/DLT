//
//  WinningDetailCell2.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/7.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit

class WinningDetailCell2: UITableViewCell {
    static let heightOfCell: CGFloat = 25
    
    let awardsLabel = UILabel()
    let winningAmountLabel = UILabel()
    let winningMoneyLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let screenWidth = Common.screenWidth
        
        awardsLabel.frame = CGRect(x: 0, y: 0, width: screenWidth*0.3, height: 25)
        awardsLabel.textAlignment = NSTextAlignment.center
        awardsLabel.font = UIFont.systemFont(ofSize: 16)
        self.contentView.addSubview(awardsLabel)
        
        winningAmountLabel.frame = CGRect(x: screenWidth*0.3, y: 0, width: screenWidth*0.3, height: 25)
        winningAmountLabel.textAlignment = NSTextAlignment.center
        winningAmountLabel.font = UIFont.systemFont(ofSize: 16)
        self.contentView.addSubview(winningAmountLabel)
        
        winningMoneyLabel.frame = CGRect(x: screenWidth*0.6, y: 0, width: screenWidth*0.4, height: 25)
        winningMoneyLabel.textAlignment = NSTextAlignment.center
        winningMoneyLabel.font = UIFont.systemFont(ofSize: 16)
        self.contentView.addSubview(winningMoneyLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setTextContent(awards: String, winningAmount: String, winningMoney: String) {
        awardsLabel.text = awards
        winningAmountLabel.text = winningAmount
        winningMoneyLabel.text = winningMoney
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
