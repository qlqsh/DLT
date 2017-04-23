//
//  TrendData.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/17.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit

struct Ball {
    var value = ""      // 数字值、可能是统计数字、可能是获奖号码。
    var isBall = false  // true: 中奖号码。 false: 统计数字。
}

class TrendData: NSObject {
    private var ballsAndMissings = [[Ball]]()
    var statistics = [[Ball]]()
    var terms = [String]()
    
    /// 初始化。把获奖数据转换为走势数组（获奖号码+遗漏值的组合）。
    override init() {
        super.init()
        
        let winnings = DataManager().readAllWinningsInFileUseReverse()
        // 红球35个
        for i in 1...35 {
            var redsAndMissings = [Ball]()  // 红球和遗漏值的一列（数组）
            var missingValue = 0
            for winning in winnings {
                var red = String(i)
                if i < 10 {
                    red = "0" + String(i)
                }
                if winning.reds.contains(red) {
                    redsAndMissings.append(Ball(value: red, isBall: true))
                    missingValue = 0
                } else {
                    missingValue += 1
                    redsAndMissings.append(Ball(value: String(missingValue), isBall: false))
                }
            }
            self.ballsAndMissings.append(redsAndMissings)
        }
        // 蓝球12个
        for i in 1...12 {
            var bluesAndMissings = [Ball]() // 蓝球和遗漏值的一列（数组）
            var missingValue = 0
            for winning in winnings {
                var blue = String(i)
                if i < 10 {
                    blue = "0" + String(i)
                }
                if winning.blues.contains(blue) {
                    bluesAndMissings.append(Ball(value: blue, isBall: true))
                    missingValue = 0
                } else {
                    missingValue += 1
                    bluesAndMissings.append(Ball(value: String(missingValue), isBall: false))
                }
            }
            self.ballsAndMissings.append(bluesAndMissings)
        }
        
        // 需要把综合数组（ballsAndMissings）列变行、行变列。
        for i in 0...winnings.count-1 {
            var anRow = [Ball]()
            for j in 0...46 {
                let ballAndMissing = self.ballsAndMissings[j]
                anRow.append(ballAndMissing[i])
            }
            statistics.append(anRow)
        }
        
        // 期号放入另一个数组，走势需要。
        for winning in winnings {
            terms.append(winning.term)
        }
    }
    
    // MARK: - 4个统计（出现次数、最大连出、最大遗漏、平均遗漏）
    /// 出现次数
    var numberOfOccurrences: [Int] {
        get {
            var showArray = [Int]()
            for ballAndMissing in ballsAndMissings {
                var show = 0
                for ball in ballAndMissing {
                    if ball.isBall {
                        show += 1
                    }
                }
                showArray.append(show)
            }
            return showArray
        }
    }
    
    /// 最大连出
    var maxContinuousOccurrences: [Int] {
        get {
            var maxArray = [Int]()
            for ballAndMissing in ballsAndMissings {
                var max = 0
                var show = 0
                for ball in ballAndMissing {
                    if ball.isBall {
                        show += 1
                    } else {
                        if show > max {
                            max = show
                        }
                        show = 0
                    }
                }
                maxArray.append(max)
            }
            return maxArray
        }
    }
    
    // 最大遗漏
    var maxMissing: [Int] {
        get {
            var maxMissingArray = [Int]()
            for ballAndMissing in ballsAndMissings {
                var max = 0
                var show = 0
                for ball in ballAndMissing {
                    if !ball.isBall {
                        show += 1
                    } else {
                        if show > max {
                            max = show
                        }
                        show = 0
                    }
                }
                maxMissingArray.append(max)
            }
            return maxMissingArray
        }
    }
    
    // 平均遗漏
    var averageMissing: [Int] {
        get {
            var averageMissingArray = [Int]()
            for ballAndMissing in ballsAndMissings {
                var total = 0
                var show = 0
                var count = 0
                for ball in ballAndMissing {
                    if !ball.isBall {
                        show += 1
                    } else {
                        count += 1
                        total += show
                        show = 0
                    }
                }
                
                averageMissingArray.append(total/count)
            }
            return averageMissingArray
        }
    }
}
