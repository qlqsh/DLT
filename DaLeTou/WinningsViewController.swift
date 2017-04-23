//
//  WinningsTableViewController.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/6.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit
import MBProgressHUD

/// 开奖历史
class WinningsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var winnings = [Winning]()
    private var tableView: UITableView!
    private func createTableView() {
        // 初始化
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        
        // 代理
        tableView.dataSource = self
        tableView.delegate = self
        
        // 表格视图整体设置
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // 注册Cell
        tableView.register(WinningCell.self, forCellReuseIdentifier: "winningCell")
        
        // 添加表格视图
        self.view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "开奖历史"
        createTableView()
        updateDataUseFile()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func updateDataUseFile() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async {
            self.winnings = Array(DataManager().readAllWinningsInFile()[0...20])
            DispatchQueue.main.async {
                hud.hide(animated: true)
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return winnings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WinningCell = tableView.dequeueReusableCell(withIdentifier: "winningCell", for: indexPath) as! WinningCell

        // Configure the cell...
        let winning = winnings[indexPath.row]
        cell.termLabel.text = "第"+winning.term+"期"
        
        let dateString = winning.date
        cell.dateLabel.text = dateString+"（"+Common.calculateWeekday(dateString: dateString)+"）"
        
        var balls = [String]()
        balls.append(contentsOf: winning.reds)
        balls.append(contentsOf: winning.blues)
        cell.winningBallView.setTextContent(textArray: balls)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WinningCell.heightOfCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "WinningDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WinningDetail" {
            let indexPath = tableView.indexPathForSelectedRow
            let winningDetailViewController = segue.destination as! WinningDetailViewController
            winningDetailViewController.winning = winnings[indexPath!.row]
        }
    }
}
