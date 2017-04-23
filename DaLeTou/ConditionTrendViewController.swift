//
//  ConditionTrendViewController.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/11.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit
import MBProgressHUD

/// 条件走势视图
class ConditionTrendViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let recentTwoTermWinnings = Array(DataManager().readAllWinningsInFile()[0...1].reversed()) // 最近2期获奖数据
    var conditionArray = [Array<String>]() // 条件数组
    var resultArray = [Winning]()   // 结果数组
    
    var tableView: UITableView!
    func createTableView() {
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.allowsSelection = false
        tableView.separatorInset = .zero
        
        self.view.addSubview(tableView)
        
        // 注册Cell
        tableView.register(WinningSimpleCell.self, forCellReuseIdentifier: "winningSimpleCell")
        tableView.register(ConditionCell.self, forCellReuseIdentifier: "conditionCell")
        tableView.register(ButtonCell.self, forCellReuseIdentifier: "buttonCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "相似走势"
        
        createTableView()
        
        // 基础统计
        let pushButton = UIBarButtonItem(title: "基础统计",
                                         style: .plain,
                                         target: self,
                                         action: #selector(pushBaseStatisticsViewController))
        self.navigationItem.rightBarButtonItem = pushButton
    }
    
    func pushBaseStatisticsViewController() {
        self.navigationController?.pushViewController(ConditionTrendBaseViewController(), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // 最近获奖2行
            return recentTwoTermWinnings.count
        case 1: // 条件行
            return conditionArray.count
        case 2: // 按钮行
            return 1
        case 3: // 结果行
            return resultArray.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: WinningSimpleCell = tableView.dequeueReusableCell(withIdentifier: "winningSimpleCell", for: indexPath) as! WinningSimpleCell
            let winning = recentTwoTermWinnings[indexPath.row]
            var balls = [String]()
            balls.append(contentsOf: winning.reds)
            balls.append(contentsOf: winning.blues)
            cell.termLabel.text = winning.term
            cell.winningBallView.setTextContent(textArray: balls)
            return cell
        case 1:
            let cell: ConditionCell = tableView.dequeueReusableCell(withIdentifier: "conditionCell", for: indexPath) as! ConditionCell
            // 删除重影
            while cell.contentView.subviews.last != nil {
                cell.contentView.subviews.last?.removeFromSuperview()
            }
            cell.setVerticalViewState(state: indexPath.row)
            cell.setConditionBalls(conditionBalls: conditionArray[indexPath.row])
            return cell
        case 2:
            let cell: ButtonCell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as! ButtonCell
            cell.addButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
            cell.clearButton.addTarget(self, action: #selector(clearAction), for: .touchUpInside)
            cell.calculateButton.addTarget(self, action: #selector(calculateAction), for: .touchUpInside)
            return cell
        case 3:
            let cell: WinningSimpleCell = tableView.dequeueReusableCell(withIdentifier: "winningSimpleCell", for: indexPath) as! WinningSimpleCell
            let winning = resultArray[indexPath.row]
            var balls = [String]()
            balls.append(contentsOf: winning.reds)
            balls.append(contentsOf: winning.blues)
            cell.termLabel.text = winning.term
            cell.winningBallView.setTextContent(textArray: balls)
            return cell
        default:
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return WinningSimpleCell.heightOfCell
        case 1:
            return ConditionCell.heightOfCell
        case 2:
            return ButtonCell.heightOfCell
        case 3:
            return WinningSimpleCell.heightOfCell
        default:
            return 40.0
        }
    }
    
    // MARK: - 按钮动作
    /// “清除”动作
    func clearAction() {
        conditionArray.removeAll()
        resultArray.removeAll()
        tableView.reloadData()
    }
    
    /// “计算”动作
    func calculateAction() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async {
            var conditions = [String]()
            for condition in self.conditionArray {
                conditions.append(condition.joined(separator: " "))
            }
            self.resultArray = StatisticsData().nextWinningDataOfConformCondition(multipleCondition: conditions)
            DispatchQueue.main.async {
                // 主线程中
                if self.resultArray.count == 0 {
                    hud.mode = MBProgressHUDMode.text
                    hud.label.text = "没有符合条件的数据"
                    hud.hide(animated: true, afterDelay: 2.0)
                } else {
                    self.tableView.reloadData()
                    hud.hide(animated: true)
                }
            }
        }
    }
    
    /// ”添加条件“动作
    func addAction() {
        let alert = UIAlertController(title: "条件",
                                      message: "\n\n\n\n\n\n\n\n\n\n\n\n\n\n",
                                      preferredStyle: .alert)
        var ballArray = [BallButton]()
        var j = 0
        let width = 36
        for i in 1...36 {
            if (i - 1) % 6 == 0 {
                j += 1
            }
            
            let positionX = 15 + ((i - 1) % 6) * (width + 4)
            let positionY = 50 + (j - 1) * (width + 4)
            
            let ballButton = BallButton(frame: CGRect(x: positionX, y: positionY, width: width, height: width))
            ballButton.setBall(isRed: true)
            if i == 36 {
                ballButton.setText(text: "空")
            } else {
                if i < 10 {
                    ballButton.setText(text: "0" + String(i))
                } else {
                    ballButton.setText(text: String(i))
                }
            }
            alert.view.addSubview(ballButton)
            ballArray.append(ballButton)
        }
        
        let okAction = UIAlertAction(title: "确认", style: .default) { (UIAlertAction) in
            if self.conditionArray.count > 5 {
                // 条件太多
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.mode = MBProgressHUDMode.text
                hud.label.text = "您的条件太多了！"
                hud.hide(animated: true, afterDelay: 2.0)
            } else {
                var selectedBallArray = [String]()
                for ballButton in ballArray {
                    if (ballButton.isSelected) {
                        selectedBallArray.append(ballButton.title(for: .normal)!)
                    }
                }
                
                if selectedBallArray.count > 4 {
                    // 最多只能选择5个红球
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud.mode = MBProgressHUDMode.text
                    hud.label.text = "最多只能选择4个红球"
                    hud.hide(animated: true, afterDelay: 2.0)
                } else {
                    // 选择了"空"
                    if selectedBallArray.last == "空" {
                        self.conditionArray.append([String]())
                    } else {
                        self.conditionArray.append(selectedBallArray)
                    }
                    self.tableView.reloadData()
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
}
