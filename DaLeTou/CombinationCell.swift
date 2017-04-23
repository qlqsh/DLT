//
//  CombinationCell.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/4/9.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit

class CombinationCell: UITableViewCell {
    let ballView = BallView(frame: CGRect(x: 2, y: 2, width: 40, height: 40))
    let titleLabel = UILabel(frame: CGRect(x: 44, y: 2, width: 100, height: 40))
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        ballView.setState(state: 2)
        titleLabel.textColor = Common.redColor
        
        self.contentView.addSubview(ballView)
        self.contentView.addSubview(titleLabel)
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
