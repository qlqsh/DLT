//
//  WinningDetailViewController.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/7.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit

/// 本期开奖细节
class WinningDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var tableView: UITableView!
    private func createTableView() {
        tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.plain)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // 注册Cell
        tableView.register(WinningCell.self, forCellReuseIdentifier: "winningCell")
        tableView.register(WinningDetailCell1.self, forCellReuseIdentifier: "winningDetailCell1")
        tableView.register(WinningDetailCell2.self, forCellReuseIdentifier: "winningDetailCell2")
        
        self.view.addSubview(tableView)
    }
    
    var winning: Winning!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "本期开奖"
        
        createTableView()
        let ruleButton = UIBarButtonItem(title: "获奖规则",
                                         style: .plain,
                                         target: self,
                                         action: #selector(pushRuleViewController))
        self.navigationItem.rightBarButtonItem = ruleButton
    }
    
    /// 载入规则视图
    func pushRuleViewController() {
        let winningRuleViewController = WinningRuleViewController()
        self.navigationController?.pushViewController(winningRuleViewController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: WinningCell = tableView.dequeueReusableCell(withIdentifier: "winningCell", for: indexPath) as! WinningCell
            cell.termLabel.text = "第"+winning.term+"期"
            cell.dateLabel.text = winning.date+"（"+Common.calculateWeekday(dateString: winning.date)+"）"
            var balls = [String]()
            balls.append(contentsOf: winning.reds)
            balls.append(contentsOf: winning.blues)
            cell.winningBallView.setTextContent(textArray: balls)
            return cell
        case 1:
            let cell: WinningDetailCell1 = tableView.dequeueReusableCell(withIdentifier: "winningDetailCell1", for: indexPath) as! WinningDetailCell1
            cell.setTextContent(poolMoney: winning.prizePool, salesMoney: winning.sales)
            return cell
        case 2:
            let cell: WinningDetailCell2 = tableView.dequeueReusableCell(withIdentifier: "winningDetailCell2", for: indexPath) as! WinningDetailCell2
            switch indexPath.row {
            case 0:
                cell.setTextContent(awards: "奖项", winningAmount: "中奖人数", winningMoney: "中奖金额")
                break
            case 1:
                cell.setTextContent(awards: "一等奖", winningAmount: winning.prizeDictionary["onePrizeNumber"]!, winningMoney: winning.prizeDictionary["onePrizeMoney"]!+"元")
                cell.backgroundColor = UIColor.groupTableViewBackground
                break
            case 2:
                cell.setTextContent(awards: "二等奖", winningAmount: winning.prizeDictionary["twoPrizeNumber"]!, winningMoney: winning.prizeDictionary["twoPrizeMoney"]!+"元")
                break
            default:
                break
            }
            return cell
        default:
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "winningCell", for: indexPath)            
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return WinningCell.heightOfCell
        case 1:
            return WinningDetailCell1.heightOfCell
        case 2:
            return WinningDetailCell2.heightOfCell
        default:
            return 40
        }
    }
}
