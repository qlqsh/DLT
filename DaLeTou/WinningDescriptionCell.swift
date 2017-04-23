//
//  WinningDescriptionCell.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/15.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit

class WinningDescriptionCell: UITableViewCell {
    static let heightOfCell: CGFloat = 30 * 8
    let winningDescription = UITextView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        winningDescription.frame = CGRect(x: 0, y: 0, width: Common.screenWidth, height: WinningDescriptionCell.heightOfCell)
        winningDescription.textAlignment = .center
        winningDescription.textColor = Common.redColor
        winningDescription.font = UIFont.systemFont(ofSize: 24.0)
        self.contentView.addSubview(winningDescription)
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
