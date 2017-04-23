//
//  HistorySameViewController.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/8.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit
import MBProgressHUD

/// 历史同期
class HistorySameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var historySame = [Winning]()
    private var tableView: UITableView!
    private func createTableView() {
        tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.plain)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // 注册Cell
        tableView.register(WinningSimpleCell.self, forCellReuseIdentifier: "historySameCell")
        
        self.view.addSubview(tableView)
    }
    
    private func updateDataUseFile() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async {
            self.historySame = StatisticsData().historySame()
            DispatchQueue.main.async {
                hud.hide(animated: true)
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.title = "历史同期"
        updateDataUseFile()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
        return historySame.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WinningSimpleCell = tableView.dequeueReusableCell(withIdentifier: "historySameCell", for: indexPath) as! WinningSimpleCell
        
        let winning = historySame[indexPath.row]
        cell.termLabel.text = winning.term
        var balls = [String]()
        balls.append(contentsOf: winning.reds)
        balls.append(contentsOf: winning.blues)
        cell.winningBallView.setTextContent(textArray: balls)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WinningSimpleCell.heightOfCell
    }
}
