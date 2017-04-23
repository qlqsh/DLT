//
//  StatisticsData.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/8.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit

/// 数字组合
struct NumbersCombin {
    var numbers = ""    // 数字组合
    var show = 0        // 显示次数
    
    var description: String {
        return numbers + ":" + String(show)
    }
    
    /// 数字组合是否包含字符串。比如："06 08 10" 包含 "06 10"
    func contains(numbersString: String) -> Bool {
        let numberArray = numbersString.components(separatedBy: " ")
        for number in numberArray {
            if !numbers.contains(number) {
                return false
            }
        }
        return true
    }
    
    /// 剩余数字组合（不包含的那个数字）。比如："06 08 10"，numbersString是"06 10"，剩余就是"08"
    func differentNumbers(numbersString: String) -> String {
        var numbersArray = numbers.components(separatedBy: " ")
        numbersArray.append(contentsOf: numbersString.components(separatedBy: " "))
        let numbersSet = NSCountedSet(array: numbersArray)
        
        for item in numbersSet.enumerated() {
            if numbersSet.count(for: item.1) == 1 { // 出现次数是1的那个就是
                return String(describing: item.1)
            }
        }
        return "0"
    }
}

class StatisticsData: NSObject {
    private let winnings = DataManager().readAllWinningsInFileUseReverse()
    private let latestWinning = DataManager().readLatestWinningInFile()
    
    // MARK: - 统计（红、蓝、头、尾、和值范围、连号概率、红球组合）
    /// 排序
    func sortCountedSet(countedSet: NSCountedSet) -> [NumbersCombin] {
        let sorted = countedSet.allObjects.sorted {
            return countedSet.count(for: $0.0) > countedSet.count(for: $0.1)
        }
        
        var redsStatistics = [NumbersCombin]()
        for item in sorted.enumerated() {
            let numbersCombin = NumbersCombin(numbers: String(describing: item.1), show: countedSet.count(for: item.1))
            redsStatistics.append(numbersCombin)
        }
        
        return redsStatistics
    }
    
    /// 红球出现情况
    func redCount() -> [NumbersCombin] {
        var reds = [String]()
        for winning in winnings {
            reds.append(contentsOf: winning.reds)
        }
        let countedSet = NSCountedSet(array: reds)
        
        return sortCountedSet(countedSet: countedSet)
    }
    
    /// 蓝球出现情况
    func blueCount() -> [NumbersCombin] {
        var blues = [String]()
        for winning in winnings {
            blues.append(contentsOf: winning.blues)
        }
        let countedSet = NSCountedSet(array: blues)
        
        return sortCountedSet(countedSet: countedSet)
    }
    
    /// 头号出现情况
    func headCount() -> [NumbersCombin] {
        var heads = [String]()
        for winning in winnings {
            heads.append(winning.reds.first!)
        }
        let countedSet = NSCountedSet(array: heads)
        
        let headArray = sortCountedSet(countedSet: countedSet)
        
        var other = 0
        var filterArray = [NumbersCombin]()
        filterArray.append(contentsOf: headArray[0..<7])
        for head in headArray[7..<headArray.count] {
            other += head.show
        }
        filterArray.append(NumbersCombin(numbers: "other", show: other))
        
        return filterArray
    }
    
    /// 尾号出现情况
    func tailCount() -> [NumbersCombin] {
        var tails = [String]()
        for winning in winnings {
            tails.append(winning.reds.last!)
        }
        let countedSet = NSCountedSet(array: tails)
        
        let tailArray = sortCountedSet(countedSet: countedSet)
        
        var other = 0
        var filterArray = [NumbersCombin]()
        filterArray.append(contentsOf: tailArray[0..<7])
        for tail in tailArray[7..<tailArray.count] {
            other += tail.show
        }
        filterArray.append(NumbersCombin(numbers: "other", show: other))
        
        return filterArray
    }
    
    /// 和值范围（15 —— 165）
    func valueOfSum() -> [NumbersCombin] {
        var range_135_165 = 0
        var range_115_135 = 0
        var range_95_115 = 0
        var range_75_95 = 0
        var range_55_75 = 0
        var range_15_55 = 0
        
        var statisticsArray = [NumbersCombin]()
        for winning in winnings {
            var total = 0
            for red in winning.reds {
                total += Int(red)!
            }
            
            if total >= 135 {
                range_135_165 += 1
            } else if total >= 115 {
                range_115_135 += 1
            } else if total >= 95 {
                range_95_115 += 1
            } else if total >= 75 {
                range_75_95 += 1
            } else if total >= 55 {
                range_55_75 += 1
            } else {
                range_15_55 += 1
            }
        }
        
//        statisticsArray.append(NumbersCombin(numbers: "和值（135~165）", show: range_135_165))
        statisticsArray.append(NumbersCombin(numbers: "和值（115~135）", show: range_115_135))
        statisticsArray.append(NumbersCombin(numbers: "和值（95~115）", show: range_95_115))
        statisticsArray.append(NumbersCombin(numbers: "和值（75~95）", show: range_75_95))
        statisticsArray.append(NumbersCombin(numbers: "和值（55~75）", show: range_55_75))
        statisticsArray.append(NumbersCombin(numbers: "其它", show: range_15_55+range_135_165))
        
        return statisticsArray
    }
    
    /// 连号情况
    func continuousCount() -> [NumbersCombin] {
        var continuous_0 = 0 // 没有连号
        var continuous_1 = 0 // 1个连号
        var continuous_2 = 0
        var continuous_3 = 0
        var continuous_4 = 0
        var continuous_5 = 0 // 最多5连号，6个球
        for winning in winnings {
            var previous = -1
            var continuous = 0
            for red in winning.reds {
                if Int(red)! - previous == 1 { // 连号
                    continuous += 1
                }
                previous = Int(red)!
            }
            switch continuous {
            case 0:
                continuous_0 += 1
                break
            case 1:
                continuous_1 += 1
                break
            case 2:
                continuous_2 += 1
                break
            case 3:
                continuous_3 += 1
                break
            case 4:
                continuous_4 += 1
                break
            case 5:
                continuous_5 += 1
                break
            default:
                break
            }
        }
        
        var statisticsArray = [NumbersCombin]()
        statisticsArray.append(NumbersCombin(numbers: "没有连号", show: continuous_0))
        statisticsArray.append(NumbersCombin(numbers: "有1个连号", show: continuous_1))
        statisticsArray.append(NumbersCombin(numbers: "有2个连号", show: continuous_2))
        statisticsArray.append(NumbersCombin(numbers: "其它",
                                             show: continuous_3+continuous_4+continuous_5))
        
        return statisticsArray
    }
    
    /// 红球组合字典（1个红球、2个红球 ... 5个红球）
    func combination() -> [Int: [NumbersCombin]] {
        var numbersDictionary = [Int: [NumbersCombin]]()
        // 5个红球
        for i in 1...5 {
            var redsCombination = [String]()
            for winning in winnings {
                redsCombination.append(contentsOf: winning.redCombination(number: i))
            }
            let countedSet = NSCountedSet(array: redsCombination)
            let result = sortCountedSet(countedSet: countedSet)
            numbersDictionary[i] = result
        }
        // 2个蓝球
        for i in 1...2 {
            var bluesCombination = [String]()
            for winning in winnings {
                bluesCombination.append(contentsOf: winning.blueCombination(number: i))
            }
            let countedSet = NSCountedSet(array: bluesCombination)
            let result = sortCountedSet(countedSet: countedSet)
            numbersDictionary[i+5] = result
        }
        
        return numbersDictionary
    }
    
    // MARK: - 历史同期    
    /// 历史同期。逆序（新->旧）。根据最近一期的期号，找出历年同期获奖号码。
    ///
    /// - Returns: 历年同期获奖号码
    func historySame() -> Array<Winning> {
        let term = latestWinning.term
        let startIndex = term.index(term.startIndex, offsetBy: 2)
        var termNumber: Int! = Int(term.substring(from: startIndex))
        
        // 判断下一期是否新的开始（新年的第1期）。新年期号归1，旧年+1。
        if termNumber >= 152 {
            let day: Int! = Int(latestWinning.date.components(separatedBy: "-").last!)
            if day + 2 > 31 { // 新的1年
                termNumber = 1
            } else { // 依然在旧年里
                if day + 3 > 31 && Common.calculateWeekday(dateString: latestWinning.term) == "周六" { // 新的1年
                    termNumber = 1
                } else {
                    termNumber = termNumber + 1
                }
            }
        } else {
            termNumber = termNumber + 1
        }
        
        var termString = ""
        if termNumber >= 100 {
            termString = String(termNumber)
        } else if termNumber >= 10 {
            termString = "0" + String(termNumber)
        } else {
            termString = "00" + String(termNumber)
        }
        
        // 历史同期
        var historySame = [Winning]()
        for winning in winnings {
            let winningTerm = winning.term
            let winningStartIndex = winningTerm.index(winningTerm.startIndex, offsetBy: 2)
            let subTerm = winningTerm.substring(from: winningStartIndex)
            if subTerm == termString {
                historySame.append(winning)
            }
        }
        
        return historySame
    }
    
    
    // MARK: - 历史相似走势
    /// 包含（多重）指定数字的下一期获奖数据。可以说是从以往的走势图形中寻找与当前走势类似的图形，这个是立体的。
    ///     比如：条件是["06", "06 08"]，就是需要第一个获奖数据里面包含"06"、下一期（第二个）获奖数据里面同时包含"06 08"，符合这2个条件的下下一期（第三个）获奖数据。
    /// - Parameter multipleCondition: 多个条件
    /// - Returns: 符合条件的下一期获奖数组的数组。
    func nextWinningDataOfConformCondition(multipleCondition: [String]) -> [Winning] {
        // 1、根据坐标建立一个获奖字典、一个坐标数组
        var allWinningDictionary = [Int: Winning]()
        var locationArray = [Int]()
        var location = 0
        for winning in winnings {
            allWinningDictionary[location] = winning
            locationArray.append(location)
            location += 1
        }
        
        // 2、遍历条件，寻找符合条件的获奖号码
        for condition in multipleCondition {
            locationArray = winningDataLocation(containNumberCombin: condition,
                                                locationArray: locationArray,
                                                allWinningDictionary: allWinningDictionary)
        }
        
        // 3、遍历符合条件的获奖数据的下标，找到获奖数据，存入数组
        var winningDataOfConformCondition = [Winning]()
        for location in locationArray {
            let winning = allWinningDictionary[location]
            winningDataOfConformCondition.append(winning!)
        }
        
        return winningDataOfConformCondition
    }
    
    /// 寻找符合条件的获奖数据的坐标。
    ///
    /// - Parameters:
    ///   - containNumberCombin: 条件字符串。比如："06"，指获奖号码中包含"06"的。"06 08"，指获奖号码中同时包含"06"和"08"的。
    ///   - locationArray: 需要对比的获奖数据的坐标数组。
    ///   - allWinningDictionary: 所有获奖数组字典。通过坐标来获取获奖数据
    /// - Returns: 符合条件的获奖数据的下一期（+1）坐标数组
    func winningDataLocation(containNumberCombin: String,
                             locationArray: [Int],
                             allWinningDictionary: [Int: Winning]) -> [Int] {
        let allCount = allWinningDictionary.count
        
        // 条件为空，说明是无条件隔1期。
        var unconditional = false
        if containNumberCombin == "" {
            unconditional = true
        }
        
        var winningDataLocation = [Int]()
        // 遍历坐标。根据坐标找到获奖数据。
        for location in locationArray {
            let winning = allWinningDictionary[location]
            if winning != nil {
                if winning!.containsReds(redString: containNumberCombin) || unconditional {
                    if allCount > location+1 {
                        winningDataLocation.append(location+1)
                    }
                }
            }
        }
        
        return winningDataLocation
    }
    
    
    // MARK: - 奖金计算
    func calculateMoney(currentWinning: Winning, myNumbers: [Winning]) -> String {
        var description = ["first": 0, "second": 0, "third": 0, "fourth": 0, "fifth": 0, "sixth": 0 ]
        let myWinnings = numbers(myNumbers: myNumbers)
        for myWinning in myWinnings {
            let awardValue = award(winningNumber: currentWinning, myNumber: myWinning)
            switch awardValue {
            case 0:
                break
            case 1:
                let newValue = description["first"]! + 1
                description["first"] = newValue
                break
            case 2:
                let newValue = description["second"]! + 1
                description["second"] = newValue
                break
            case 3:
                let newValue = description["third"]! + 1
                description["third"] = newValue
                break
            case 4:
                let newValue = description["fourth"]! + 1
                description["fourth"] = newValue
                break
            case 5:
                let newValue = description["fifth"]! + 1
                description["fifth"] = newValue
                break
            case 6:
                let newValue = description["sixth"]! + 1
                description["sixth"] = newValue
                break
            default:
                break
            }
        }
        var descriptionString = ""
        if description["first"]! > 0 {
            descriptionString.append("一等奖 \(description["first"]!) 注\n")
        }
        if description["second"]! > 0 {
            descriptionString.append("二等奖 \(description["second"]!) 注\n")
        }
        if description["third"]! > 0 {
            descriptionString.append("三等奖 \(description["third"]!) 注\n")
        }
        if description["fourth"]! > 0 {
            descriptionString.append("四等奖 \(description["fourth"]!) 注\n")
        }
        if description["fifth"]! > 0 {
            descriptionString.append("五等奖 \(description["fifth"]!) 注\n")
        }
        if description["sixth"]! > 0 {
            descriptionString.append("六等奖 \(description["sixth"]!) 注")
        }
        
        if descriptionString.isEmpty {
            return "很遗憾您没有中奖，再接再厉吧！"
        } else {
            return "恭喜中奖！！！\n" + descriptionString
        }
    }
    
    /// 把我的号码（可能是复式）分解成（多个）单注号码
    private func numbers(myNumbers: [Winning]) -> [Winning] {
        var winnings = [Winning]()
        for myNumber in myNumbers {
            var redCombin = [String]()
            var blueCombin = [String]()
            let reds = myNumber.reds
            let blues = myNumber.blues
            var end = reds.count-1
            for one in reds {
                for two in reds[1...end] {
                    for three in reds[2...end] {
                        for four in reds[3...end] {
                            for five in reds[4...end] {
                                if Int(one)! < Int(two)! && Int(two)! < Int(three)! && Int(three)! < Int(four)! && Int(four)! < Int(five)! {
                                    redCombin.append(one + " " + two + " " + three + " " + four + " " + five)
                                }
                            }
                        }
                    }
                }
            }
            end = blues.count-1
            for one in blues {
                for two in blues[1...end] {
                    if Int(one)! < Int(two)! {
                        blueCombin.append(one + " " + two)
                    }
                }
            }
            for redString in redCombin {
                for blueString in blueCombin {
                    let winning = Winning(redString: redString, blueString: blueString)
                    winnings.append(winning)
                }
            }
        }
        
        return winnings
    }
    
    /// 判断一注号码（5+2）是获得几等奖
    private func award(winningNumber: Winning, myNumber: Winning) -> Int {
        var hasRed = 0  // 中的红球数量
        for red in myNumber.reds {
            if winningNumber.reds.contains(red) {
                hasRed += 1
            }
        }
        var hasBlue = 0 // 中的蓝球数量
        for blue in myNumber.blues {
            if winningNumber.blues.contains(blue) {
                hasBlue += 1
            }
        }
        
        // 1等奖
        if (hasRed == 5 && hasBlue == 2) {
            return 1
        }
        
        // 2等奖
        if (hasRed == 5 && hasBlue == 1) {
            return 2
        }
        
        // 3等奖
        if (hasRed == 5 && hasBlue == 0) {
            return 3
        }
        if (hasRed == 4 && hasBlue == 2) {
            return 3
        }
        
        // 4等奖
        if (hasRed == 4 && hasBlue == 1) {
            return 4
        }
        if (hasRed == 3 && hasBlue == 2) {
            return 4
        }
        
        // 5等奖
        if (hasRed == 4 && hasBlue == 0) {
            return 5
        }
        if (hasRed == 3 && hasBlue == 1) {
            return 5
        }
        if (hasRed == 2 && hasBlue == 2) {
            return 5
        }
        
        // 6等奖
        if (hasRed == 3 && hasBlue == 0) {
            return 6
        }
        if (hasRed == 1 && hasBlue == 2) {
            return 6
        }
        if (hasRed == 2 && hasBlue == 1) {
            return 6
        }
        if (hasRed == 0 && hasBlue == 2) {
            return 6
        }
        
        return 0 // 没有中奖
    }
}
