//
//  WinningSimpleCell.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/8.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit

/// 获奖视图（期号+获奖号码）
class WinningSimpleCell: UITableViewCell {
    static let heightOfCell = Common.screenWidth/320.0*40
    
    let termLabel = UILabel()
    let winningBallView = WinningBallView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        termLabel.frame = CGRect(x: 0, y: 20, width: 40, height: 20)
        termLabel.textColor = UIColor.gray
        termLabel.textAlignment = NSTextAlignment.center
        termLabel.font = UIFont.systemFont(ofSize: 12.0)
        self.contentView.addSubview(termLabel)
        
        winningBallView.frame = CGRect(x: 40, y: 0, width: 280, height: 40)
        self.contentView.addSubview(winningBallView)
        
        let scale = Common.screenWidth/320.0
        self.transform = CGAffineTransform(scaleX: scale, y: scale)
        self.frame = CGRect(x: 0, y: 0, width: 320*scale, height: 40*scale)
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
