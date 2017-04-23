//
//  ConditionTrendBaseViewController.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/16.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit
import MBProgressHUD

/// 数字组合
struct CombinStatsicts {
    var combin = ""             // 数字组合
    var result = [Winning]()    // 符合条件的结果
}

class ConditionTrendBaseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "基础统计"
        createTableView()
        baseStatisitcs()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - 统计数据
    func baseStatisitcs() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async {
            for i in 1...self.latestWinning.reds.count {
                for combinString in self.combining(number: i) {
                    let results = StatisticsData().nextWinningDataOfConformCondition(multipleCondition: [combinString])
                    if results.count >= 2 {
                        if results.count > 5 {
                            let begin = results.count - 5
                            let subResults = Array(results[begin...results.count-1])
                            self.statistics.append(CombinStatsicts(combin: combinString + " [\(results.count)]", result: subResults))
                        } else {
                            self.statistics.append(CombinStatsicts(combin: combinString + " [\(results.count)]", result: results))
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                // 主线程中
                self.tableView.reloadData()
                hud.hide(animated: true)
            }
        }
    }
    
    // MARK: - 数据
    private let latestWinning = DataManager().readLatestWinningInFile()     // 最新一期获奖数据
    private var statistics = [CombinStatsicts]() // 统计
    
    /// 求出一个数组内指定（组合数字）个数的所有数字组合
    private func combining(number: Int) -> [String] {
        let baseArray = latestWinning.reds
        
        if number == 1 {
            return baseArray
        }
        if number >= baseArray.count {
            return [baseArray.joined(separator: " ")]
        }
        
        switch number {
        case 2:
            return newCombinWithArray(oldCombinArray: combining(number: 1))
        case 3:
            return newCombinWithArray(oldCombinArray: combining(number: 2))
        case 4:
            return newCombinWithArray(oldCombinArray: combining(number: 3))
        default:
            return baseArray
        }
    }
    
    private func newCombinWithArray(oldCombinArray: [String]) -> [String] {
        let baseArray = latestWinning.reds
        var newCombin = [String]()
        for base in baseArray {
            for oldCombin in oldCombinArray {
                if oldCombin.contains(base) == false {
                    if Int(base)! < Int(oldCombin.components(separatedBy: " ").first!)! {
                        newCombin.append(base + " " + oldCombin)
                    }
                }
            }
        }
        return newCombin
    }
    
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
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return statistics.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if statistics[section].result.count > 5 {
            return 5
        }
        return statistics[section].result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WinningSimpleCell = tableView.dequeueReusableCell(withIdentifier: "winningSimpleCell", for: indexPath) as! WinningSimpleCell
        let winning = statistics[indexPath.section].result[indexPath.row]
        cell.termLabel.text = winning.term
        var balls = winning.reds
        balls.append(contentsOf: winning.blues)
        cell.winningBallView.setTextContent(textArray: balls)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WinningSimpleCell.heightOfCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let combinLabel = UILabel(frame: CGRect(x: 0, y: 0, width: Common.screenWidth, height: 20))
        combinLabel.backgroundColor = UIColor.groupTableViewBackground
        combinLabel.textAlignment = .center
        combinLabel.font = UIFont.systemFont(ofSize: 9.0)
        combinLabel.text = statistics[section].combin
        
        return combinLabel
    }
}
