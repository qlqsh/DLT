//
//  WinningRuleViewController.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/7.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit

/// 获奖规则
class WinningRuleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var tableView: UITableView!
    private func createTableView() {
        tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.plain)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // 注册Cell
        tableView.register(WinningRuleCell.self, forCellReuseIdentifier: "winningRuleCell")
        
        self.view.addSubview(tableView)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "中奖规则"
        createTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WinningRuleCell = tableView.dequeueReusableCell(withIdentifier: "winningRuleCell", for: indexPath) as! WinningRuleCell
        
        // Configure the cell...
        switch indexPath.row {
        case 0:
            cell.setRuleContent(award: "一等奖",
                                money: "浮动",
                                winningRules: [ [2, 2, 2, 2, 2, 3, 3] ])
            break
        case 1:
            cell.setRuleContent(award: "二等奖",
                                money: "浮动",
                                winningRules: [ [2, 2, 2, 2, 2, 3, 0] ])
            break
        case 2:
            cell.setRuleContent(award: "三等奖",
                                money: "浮动",
                                winningRules: [ [2, 2, 2, 2, 2, 0, 0],
                                                [2, 2, 2, 2, 0, 3, 3] ])
            break
        case 3:
            cell.setRuleContent(award: "四等奖",
                                money: "200元",
                                winningRules: [ [2, 2, 2, 2, 0, 3, 0],
                                                [2, 2, 2, 0, 0, 3, 3] ])
            break
        case 4:
            cell.setRuleContent(award: "五等奖",
                                money: "10元",
                                winningRules: [ [2, 2, 2, 2, 0, 0, 0],
                                                [2, 2, 2, 0, 0, 3, 0],
                                                [2, 2, 0, 0, 0, 3, 3] ])
            break
        case 5:
            cell.setRuleContent(award: "六等奖",
                                money: "5元",
                                winningRules: [ [2, 2, 2, 0, 0, 0, 0],
                                                [2, 0, 0, 0, 0, 3, 3],
                                                [2, 2, 0, 0, 0, 3, 0],
                                                [0, 0, 0, 0, 0, 3, 3] ])
            break
        default:
            break
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return WinningRuleCell.heightOfCell
        case 1:
            return WinningRuleCell.heightOfCell
        case 2:
            return WinningRuleCell.heightOfCell*2
        case 3:
            return WinningRuleCell.heightOfCell*2
        case 4:
            return WinningRuleCell.heightOfCell*3
        case 5:
            return WinningRuleCell.heightOfCell*4
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let width = Common.screenWidth
        
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: width, height: 40)
        headerView.backgroundColor = Common.redColor
        
        let awardLevel = UILabel()
        awardLevel.frame = CGRect(x: 0, y: 0, width: width*0.2, height: 40)
        awardLevel.text = "奖等"
        awardLevel.textColor = UIColor.white
        awardLevel.textAlignment = NSTextAlignment.center
        awardLevel.font = UIFont.boldSystemFont(ofSize: 20)
        headerView.addSubview(awardLevel)
        
        let awardMoney = UILabel()
        awardMoney.frame = CGRect(x: width*0.2, y: 0, width: width*0.2, height: 40)
        awardMoney.text = "奖金"
        awardMoney.textColor = UIColor.white
        awardMoney.textAlignment = NSTextAlignment.center
        awardMoney.font = UIFont.boldSystemFont(ofSize: 20)
        headerView.addSubview(awardMoney)
        
        let winningConditions = UILabel()
        winningConditions.frame = CGRect(x: width*0.4, y: 0, width: width*0.6, height: 40)
        winningConditions.text = "中奖条件"
        winningConditions.textColor = UIColor.white
        winningConditions.textAlignment = NSTextAlignment.center
        winningConditions.font = UIFont.boldSystemFont(ofSize: 20)
        headerView.addSubview(winningConditions)
        
        return headerView
    }
}
