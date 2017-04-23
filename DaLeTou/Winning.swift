//
//  Winning.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/2.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit
import Fuzi

class Winning: NSObject, NSCoding {
    // MARK: - 主要属性
    var term = ""
    var reds = [String]()
    var blues = [String]()
    
    // MARK: - 次要属性
    var prizePool = ""
    var prizeDictionary = [String: String]() // 奖项（注数、奖金）字典
    var sales = ""
    var date = ""
    
    // MARK: - 初始化
    /// 初始化获奖信息（字符串）为数组
    ///
    /// - parameter winningHTML: 获奖信息HTML
    /**
        <tr class="t_tr1">
         <td class="t_tr1">17024</td>
         <td class="cfont2">21</td>
         <td class="cfont2">23</td>
         <td class="cfont2">29</td>
         <td class="cfont2">32</td>
         <td class="cfont2">35</td>
         <td class="cfont4">11</td>
         <td class="cfont4">12</td>
         <td class="t_tr1">3,471,058,022</td>
         <td class="t_tr1">3</td>
         <td class="t_tr1">10,000,000</td>
         <td class="t_tr1">73</td>
         <td class="t_tr1">131,828</td>
         <td class="t_tr1">206,593,265</td>
         <td class="t_tr1">2017-03-04</td>
        </tr>
     */
    init(winningHTML: String!) {
        do {
            let doc = try HTMLDocument(string: winningHTML)
            var winnings = [String]()
            for tdata in doc.xpath("//td") {
                winnings.append(tdata.stringValue)
            }
            if winnings.count == 15 {
                term = winnings[0]
                reds.append(contentsOf: winnings[1...5])
                blues.append(contentsOf: winnings[6...7])
                prizePool = winnings[8]
                prizeDictionary["onePrizeNumber"] = winnings[9]
                prizeDictionary["onePrizeMoney"] = winnings[10]
                prizeDictionary["twoPrizeNumber"] = winnings[11]
                prizeDictionary["twoPrizeMoney"] = winnings[12]
                sales = winnings[13]
                date = winnings[14]
            }
        } catch let error {
            print(error)
        }
    }
    
    init(redString: String!, blueString: String!) {
        term = "0"
        reds = redString.components(separatedBy: " ")
        blues = blueString.components(separatedBy: " ")
    }
    
    // MARK: - 包含处理
    /// 包含红球
    func containsReds(redString: String) -> Bool {
        return contains(ballString: redString, balls: reds)
    }
    
    /// 包含蓝球
    func containsBlues(blueString: String) -> Bool {
        return contains(ballString: blueString, balls: blues)
    }
    
    /// 特定数组里是否包含字符串
    private func contains(ballString: String, balls: Array<String>) -> Bool {
        let ballArray = ballString.components(separatedBy: " ")
        for ball in ballArray {
            if balls.contains(ball) == false {
                return false
            }
        }
        
        return true
    }
    
    /// 判断2个获奖信息是否同一期
    override func isEqual(_ object: Any?) -> Bool {
        let winning: Winning = object as! Winning
        return term == winning.term
    }
    
    // MARK: - 信息方法
    /// 获奖信息描述
    override var description: String {
        get {
            var description = term
            for red in reds {
                description += " " + red
            }
            for blue in blues {
                description += " " + blue
            }
            
            return description
        }
    }
    
    // MARK: - NSCoding
    /// 编码
    func encode(with aCoder: NSCoder) {
        aCoder.encode(term, forKey: "Term")
        aCoder.encode(reds, forKey: "Reds")
        aCoder.encode(blues, forKey: "Blues")
        aCoder.encode(prizePool, forKey: "PrizePool")
        aCoder.encode(prizeDictionary, forKey: "PrizeDictionary")
        aCoder.encode(sales, forKey: "Sales")
        aCoder.encode(date, forKey: "Date")
    }
    
    /// 解码
    required init?(coder aDecoder: NSCoder) {
        self.term = aDecoder.decodeObject(forKey: "Term") as! String
        self.reds = aDecoder.decodeObject(forKey: "Reds") as! Array
        self.blues = aDecoder.decodeObject(forKey: "Blues") as! Array
        self.prizePool = aDecoder.decodeObject(forKey: "PrizePool") as! String
        self.prizeDictionary = aDecoder.decodeObject(forKey: "PrizeDictionary") as! Dictionary
        self.sales = aDecoder.decodeObject(forKey: "Sales") as! String
        self.date = aDecoder.decodeObject(forKey: "Date") as! String
    }
    
    // MARK: - 其它
    /// 红球号码组合
    func redCombination(number: Int) -> [String] {
        switch number {
        case 1:
            var combinationArray = [String]()
            for red in reds {
                combinationArray.append(red)
            }
            return combinationArray
        case 2:
            return combination(with: redCombination(number: 1))
        case 3:
            return combination(with: redCombination(number: 2))
        case 4:
            return combination(with: redCombination(number: 3))
        default:
            return [reds.joined(separator: " ")]
        }
    }
    
    /// 蓝球号码组合
    func blueCombination(number: Int) -> [String] {
        if number == 1 {
            var combinationArray = [String]()
            for blue in blues {
                combinationArray.append(blue)
            }
            return combinationArray
        }
        return [blues.joined(separator: " ")]
    }
    
    /// 利用已有的数字组合和获奖号码组成新的组合。
    /**
        例如： 获奖号码 06 08 09 20 30
              1是：[06]、[08]、[09]、[20]、[30]
              2就是：[06 08]、[06 09]这样
     */
    private func combination(with numberArray: [String]) -> [String] {
        var numbersCombination = [String]()
        for numbers in numberArray {
            let lastRed = numbers.components(separatedBy: " ").last
            for red in reds {
                if Int(red)! > Int(lastRed!)! {
                    numbersCombination.append(numbers + " " + red)
                }
            }
        }
        return numbersCombination
    }
}
