//
//  CompatibilityViewController.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/4/9.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit
import PNChart
import MBProgressHUD

class CompatibilityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "号码契合度"
        createTableView()
        updateData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - 数据初始化
    private var allCombination = [Int: [NumbersCombin]]()   // 所有数字组合
    private func updateData() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async {
            // 后台操作
            self.allCombination = StatisticsData().combination()
            DispatchQueue.main.async {
                // 回到主线程
                self.tableView.reloadData()
                hud.hide(animated: true)
            }
        }
    }
    
    // MARK: - UITableView 初始化
    private var tableView: UITableView!
    private func createTableView() {
        tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.plain)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.allowsSelection = false
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // 注册Cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "compatibilityCell")
        
        self.view.addSubview(tableView)
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        if items.isEmpty { // 没有数据
            return 1
        }
        if !perfectData() { // 数据不完美
            return 2
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1 // 条件按钮，就1行
        case 1:
            return perfectData() ? 1 : results.count // 可能是雷达图、也可能只是结果列表（数据不完美）
        case 2:
            return results.count // 完美数据，结果列表
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "compatibilityCell", for: indexPath)
        // 如果重影，使用下面方法消除重影
        while cell.contentView.subviews.last != nil {
            cell.contentView.subviews.last?.removeFromSuperview()
        }
        
        switch indexPath.section {
        case 0:
            let screenWidth = Common.screenWidth
            let buttonWidth = screenWidth/2 - 20
            let redButton = UIButton()
            redButton.frame = CGRect(x: 10, y: 5, width: buttonWidth, height: 34)
            redButton.layer.borderWidth = 0.5
            redButton.layer.borderColor = Common.grayColor.cgColor
            redButton.layer.cornerRadius = 17.0
            redButton.setTitle("红球", for: .normal)
            redButton.setTitleColor(Common.redColor, for: .normal)
            redButton.addTarget(self, action: #selector(addRedAction), for: .touchUpInside)
            cell.contentView.addSubview(redButton)
            let blueButton = UIButton()
            blueButton.frame = CGRect(x: 30 + buttonWidth, y: 5, width: buttonWidth, height: 34)
            blueButton.layer.borderWidth = 0.5
            blueButton.layer.borderColor = Common.grayColor.cgColor
            blueButton.layer.cornerRadius = 17.0
            blueButton.setTitle("蓝球", for: .normal)
            blueButton.setTitleColor(Common.blueColor, for: .normal)
            blueButton.addTarget(self, action: #selector(addBlueAction), for: .touchUpInside)
            cell.contentView.addSubview(blueButton)
        case 1:
            if !items.isEmpty {
                if perfectData() {
                    let frame = CGRect(x: 15, y: 0, width: Common.screenWidth - 30, height: Common.screenWidth - 30)
                    let firstRadarChart = items.first!
                    let radarChart = PNRadarChart(frame: frame, items: items, valueDivider: CGFloat(firstRadarChart.value))!
                    cell.contentView.addSubview(radarChart)
                
                    let numberArray = selected.numbers.components(separatedBy: " ")
                    let positionX = Common.screenWidth/2 - CGFloat(numberArray.count*40/2)
                    let positionY = Common.screenWidth/2 - 20 - 15
                    var i = 0
                    for number in numberArray {
                        let ballView = BallView(frame: CGRect(x: positionX+CGFloat(40*i), y: positionY, width: 40, height: 40))
                        showRed ? ballView.setState(state: 2) : ballView.setState(state: 3)
                        ballView.titleLabel.text = number
                        cell.contentView.addSubview(ballView)
                        i += 1
                    }
                } else {
                    // 数字组合
                    let numbersCombination = results[indexPath.row]
                    let numberArray = numbersCombination.numbers.components(separatedBy: " ")
                    let positionX = (Common.screenWidth - CGFloat(numberArray.count+1)*40)/2
                    var i = 0
                    for number in numberArray {
                        let ballView = BallView(frame: CGRect(x: positionX + CGFloat(i*40), y: 0, width: 40, height: 40))
                        ballView.titleLabel.text = number
                        showRed ? ballView.setState(state: 2) : ballView.setState(state: 3)
                        i += 1
                        cell.contentView.addSubview(ballView)
                    }
                
                    // 数字标签
                    let showLabel = UILabel(frame: CGRect(x: positionX + CGFloat(40*i), y:20, width:40, height:20))
                    showLabel.text = "[\(Int(numbersCombination.show))]"
                    showLabel.textColor = UIColor.darkGray
                    showLabel.textAlignment = .left
                    showLabel.font = UIFont.systemFont(ofSize: 12.0)
                    cell.contentView.addSubview(showLabel)
                }
            }
        case 2:
            if !results.isEmpty {
                // 数字组合
                let numbersCombination = results[indexPath.row]
                let numberArray = numbersCombination.numbers.components(separatedBy: " ")
                let positionX = (Common.screenWidth - CGFloat(numberArray.count+1)*40)/2
                var i = 0
                for number in numberArray {
                    let ballView = BallView(frame: CGRect(x: positionX + CGFloat(i*40), y: 0, width: 40, height: 40))
                    ballView.titleLabel.text = number
                    showRed ? ballView.setState(state: 2) : ballView.setState(state: 3)
                    i += 1
                    cell.contentView.addSubview(ballView)
                }
                
                // 数字标签
                let showLabel = UILabel(frame: CGRect(x: positionX + CGFloat(40*i), y:20, width:40, height:20))
                showLabel.text = "[\(Int(numbersCombination.show))]"
                showLabel.textColor = UIColor.darkGray
                showLabel.textAlignment = .left
                showLabel.font = UIFont.systemFont(ofSize: 12.0)
                cell.contentView.addSubview(showLabel)
            }
        default: break
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return perfectData() ? Common.screenWidth - 30 : 44.0
        }
        return 44.0
    }
    
    // MARK: - 雷达图数据处理
    private var results = [NumbersCombin]()
    private var items = [PNRadarChartDataItem]()
    private var selected = NumbersCombin(numbers: "", show: 0)
    private var showRed = true
    private let maxShow = 6
    
    /// 数据不完美，不适合雷达图
    private func perfectData() -> Bool {
        // 第一个数字组合出现次数低于3，不显示雷达图，清理数据
        let show: CGFloat = 3
        if !items.isEmpty {
            if (items.first?.value)! < show {
                return false
            }
        }
        // 数字组合数量低于6个，不显示雷达图，清理数据
        if items.count < maxShow {
            return false
        }
        return true
    }
    
    /// 数据清理
    private func clearData() {
        items.removeAll()
        results.removeAll()
        selected = NumbersCombin(numbers: "", show: 0)
        showRed = true
    }
    
    /// 条件过滤数据
    private func filterData(with selected: [String], isRed: Bool) {
        let selectedString = selected.joined(separator: " ")
        // 通过选择的号码数量，找到2个数组（选择的号码数量的数字组合数组、选择的号码数量+1的数字组合数组）
        // 比如：选择号码"06"，需要找到（1、2）个数字组合数组。"06 08 10"，需要找到（3、4）个数字组合数组。
        var selectedNumbers = self.allCombination[selected.count]!
        var selectedCombinationNumbers = self.allCombination[selected.count+1]!
        showRed = true
        if !isRed {
            selectedNumbers = self.allCombination[selected.count+5]!
            selectedCombinationNumbers = self.allCombination[selected.count+5+1]!
            showRed = false
        }
        // 更新数据
        for numbersCombin in selectedNumbers {
            if numbersCombin.numbers == selectedString {
                self.selected = numbersCombin
            }
        }
        var i = 0
        for numbersCombin in selectedCombinationNumbers {
            if numbersCombin.contains(numbersString: selectedString) {
                if i < maxShow {
                    let item = PNRadarChartDataItem(value:CGFloat(numbersCombin.show), description: numbersCombin.differentNumbers(numbersString: selectedString))!
                    self.items.append(item)
                    i += 1
                }
                results.append(numbersCombin)
            }
        }
    }
    
    // MARK: - 按钮动作
    /// 选择“红球”
    func addRedAction() {
        let alert = UIAlertController(title: "最多选择3个红球",
                                      message: "\n\n\n\n\n\n\n\n\n\n\n\n\n\n",
                                      preferredStyle: .alert)
        var ballArray = [BallButton]()
        var j = 0
        let width = 36
        for i in 1...35 {
            if (i - 1) % 6 == 0 {
                j += 1
            }
            
            let positionX = 15 + ((i - 1) % 6) * (width + 4)
            let positionY = 50 + (j - 1) * (width + 4)
            
            let ballButton = BallButton(frame: CGRect(x: positionX, y: positionY, width: width, height: width))
            ballButton.setBall(isRed: true)
            if i < 10 {
                ballButton.setText(text: "0" + String(i))
            } else {
                ballButton.setText(text: String(i))
            }
            alert.view.addSubview(ballButton)
            ballArray.append(ballButton)
        }
        
        let okAction = UIAlertAction(title: "确认", style: .default) { (UIAlertAction) in
            var selectedBallArray = [String]()
            for ballButton in ballArray {
                if (ballButton.isSelected) {
                    selectedBallArray.append(ballButton.title(for: .normal)!)
                }
            }
            self.clearData()
            if selectedBallArray.count < 1 {
                self.messageHUD(text: "最少选择1个红球！")
            } else if selectedBallArray.count > 3 {
                self.messageHUD(text: "最多选择3个红球！")
            } else {
                self.filterData(with: selectedBallArray, isRed: true)
                if self.items.isEmpty {
                    self.messageHUD(text: "条件太多，数据没有参考价值。")
                } else {
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        hud.hide(animated: true)
                        self.tableView.reloadData()
                    }
                }
            }
        }
        okAction.setValue(Common.redColor, forKey: "titleTextColor")
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (UIAlertAction) in
        }
        cancelAction.setValue(Common.redColor, forKey: "titleTextColor")
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /// 选择“蓝球”
    func addBlueAction() {
        let alert = UIAlertController(title: "最多选择1个蓝球",
                                      message: "\n\n\n\n\n",
                                      preferredStyle: .alert)
        var ballArray = [BallButton]()
        var j = 0
        let width = 36
        for i in 1...12 {
            if (i - 1) % 6 == 0 {
                j += 1
            }
            
            let positionX = 15 + ((i - 1) % 6) * (width + 4)
            let positionY = 50 + (j - 1) * (width + 4)
            
            let ballButton = BallButton(frame: CGRect(x: positionX, y: positionY, width: width, height: width))
            ballButton.setBall(isRed: false)
            if i < 10 {
                ballButton.setText(text: "0" + String(i))
            } else {
                ballButton.setText(text: String(i))
            }
            alert.view.addSubview(ballButton)
            ballArray.append(ballButton)
        }
        
        let okAction = UIAlertAction(title: "确认", style: .default) { (UIAlertAction) in
            var selectedBallArray = [String]()
            for ballButton in ballArray {
                if (ballButton.isSelected) {
                    selectedBallArray.append(ballButton.title(for: .normal)!)
                }
            }
            self.clearData()
            if selectedBallArray.count == 0 {
                self.messageHUD(text: "至少选择1个蓝球！")
            } else if selectedBallArray.count == 1 {
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.filterData(with: selectedBallArray, isRed: false)
                    hud.hide(animated: true)
                    self.tableView.reloadData()
                }
            } else {
                self.messageHUD(text: "只能选择1个蓝球！")
            }
        }
        
        okAction.setValue(Common.blueColor, forKey: "titleTextColor")
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (UIAlertAction) in
        }
        cancelAction.setValue(Common.blueColor, forKey: "titleTextColor")
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - HUD
    /// 提醒消息
    private func messageHUD(text: String) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.label.text = text
        hud.hide(animated: true, afterDelay: 2.0)
    }
}
