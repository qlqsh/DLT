//
//  ButtonCell.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/11.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {
    static let heightOfCell = 30 + Common.screenWidth*0.04
    
    var addButton: UIButton!
    var clearButton: UIButton!
    var calculateButton: UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let screenWidth = Common.screenWidth
        let space = screenWidth*0.02
        let buttonWidth = screenWidth/3 - space*2
        
        addButton = UIButton()
        addButton.frame = CGRect(x: space, y: space, width: buttonWidth, height: 30)
        addButton.layer.borderWidth = 0.5
        addButton.layer.borderColor = Common.grayColor.cgColor
        addButton.layer.cornerRadius = 15.0
        addButton.setTitle("添加条件", for: .normal)
        addButton.setTitleColor(Common.redColor, for: .normal)
        self.contentView.addSubview(addButton)
        
        clearButton = UIButton()
        clearButton.frame = CGRect(x: space*3 + buttonWidth, y: space, width: buttonWidth, height: 30)
        clearButton.layer.borderWidth = 0.5
        clearButton.layer.borderColor = Common.grayColor.cgColor
        clearButton.layer.cornerRadius = 15.0
        clearButton.setTitle("清除", for: .normal)
        clearButton.setTitleColor(Common.redColor, for: .normal)
        self.contentView.addSubview(clearButton)
        
        calculateButton = UIButton()
        calculateButton.frame = CGRect(x: space*5 + buttonWidth*2, y: space, width: buttonWidth, height: 30)
        calculateButton.layer.borderWidth = 0.5
        calculateButton.layer.borderColor = Common.grayColor.cgColor
        calculateButton.layer.cornerRadius = 15.0
        calculateButton.setTitle("计算", for: .normal)
        calculateButton.setTitleColor(Common.redColor, for: .normal)
        self.contentView.addSubview(calculateButton)
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
