//
//  WinningDetailCell1.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/7.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit

class WinningDetailCell1: UITableViewCell {
    static let heightOfCell: CGFloat = 60
    
    let poolLabel = UILabel()
    let poolMoneyLabel = UILabel()
    let salesLabel = UILabel()
    let salesMoneyLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let screenWidth = Common.screenWidth
        
        poolLabel.frame = CGRect(x: 0, y: 5, width: screenWidth*0.5, height: 25)
        poolLabel.text = "奖池滚存"
        poolLabel.textAlignment = NSTextAlignment.center
        poolLabel.font = UIFont.systemFont(ofSize: 16)
        self.contentView.addSubview(poolLabel)
        
        poolMoneyLabel.frame = CGRect(x: 0, y: 30, width: screenWidth*0.5, height: 25)
        poolMoneyLabel.textAlignment = NSTextAlignment.center
        poolMoneyLabel.font = UIFont.systemFont(ofSize: 16)
        self.contentView.addSubview(poolMoneyLabel)
        
        salesLabel.frame = CGRect(x: screenWidth*0.5, y: 5, width: screenWidth*0.5, height: 25)
        salesLabel.text = "全国销量"
        salesLabel.textAlignment = NSTextAlignment.center
        salesLabel.font = UIFont.systemFont(ofSize: 16)
        self.contentView.addSubview(salesLabel)
        
        salesMoneyLabel.frame = CGRect(x: screenWidth*0.5, y: 30, width: screenWidth*0.5, height: 25)
        salesMoneyLabel.textAlignment = NSTextAlignment.center
        salesMoneyLabel.font = UIFont.systemFont(ofSize: 16)
        self.contentView.addSubview(salesMoneyLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setTextContent(poolMoney: String, salesMoney: String) {
        poolMoneyLabel.text = poolMoney + "元"
        salesMoneyLabel.text = salesMoney + "元"
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
