//
//  WinningCell.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/6.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit

class WinningCell: UITableViewCell {
    static let heightOfCell = 20 + Common.screenWidth*0.9/WinningBallView.defaultWidth*WinningBallView.defaultHeight
    
    let termLabel = UILabel()
    let dateLabel = UILabel()
    let winningBallView = WinningBallView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let screenWidth = Common.screenWidth
        // 期号标签
        termLabel.frame = CGRect(x: screenWidth*0.05, y: 0, width: screenWidth*0.45, height: 20)
        termLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        termLabel.textAlignment = NSTextAlignment.left
        
        // 时间标签
        dateLabel.frame = CGRect(x: screenWidth*0.5, y: 0, width: screenWidth*0.45, height: 20)
        dateLabel.font = UIFont.systemFont(ofSize: 14.0)
        dateLabel.textAlignment = NSTextAlignment.right
        
        // 获奖号码视图
        let scale = Common.screenWidth*0.9/WinningBallView.defaultWidth
        winningBallView.setScale(scale: scale)
        winningBallView.frame = CGRect(x: screenWidth*0.05,
                                       y: 20,
                                       width: screenWidth*0.9,
                                       height: scale*WinningBallView.defaultHeight)
        
        self.contentView.addSubview(termLabel)
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(winningBallView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
