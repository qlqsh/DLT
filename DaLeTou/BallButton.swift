//
//  BallButton.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/13.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit

class BallButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(setSelect), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setSelect() {
        self.isSelected = !self.isSelected
    }
    
    func setBall(isRed: Bool) {
        if isRed {
            self.setTitleColor(Common.redColor, for: .normal)
            self.setBackgroundImage(UIImage(named: "WhiteBallBackground"), for: .normal)
            self.setTitleColor(UIColor.white, for: .selected)
            self.setBackgroundImage(UIImage(named: "RedBallBackground"), for: .selected)
            self.setTitleColor(UIColor.white, for: .highlighted)
            self.setBackgroundImage(UIImage(named: "RedBallBackground"), for: .highlighted)
            self.adjustsImageWhenHighlighted = false // 高亮模式下按钮不会变灰
        } else {
            self.setTitleColor(Common.blueColor, for: .normal)
            self.setBackgroundImage(UIImage(named: "WhiteBallBackground"), for: .normal)
            self.setTitleColor(UIColor.white, for: .selected)
            self.setBackgroundImage(UIImage(named: "BlueBallBackground"), for: .selected)
            self.setTitleColor(UIColor.white, for: .highlighted)
            self.setBackgroundImage(UIImage(named: "BlueBallBackground"), for: .highlighted)
            self.adjustsImageWhenHighlighted = false // 高亮模式下按钮不会变灰
        }
    }
    
    func setText(text: String) {
        self.setTitle(text, for: .normal)
        self.setTitle(text, for: .selected)
        self.setTitle(text, for: .highlighted)
    }
}
