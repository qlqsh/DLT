//
//  RedCombinationAllViewController.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/4/7.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit
import MBProgressHUD

class CombinationAllViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "数字组合"
        createTableView()
        updateData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - 数据初始化
    private var combination = [Int: [NumbersCombin]]()
    private func updateData() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async {
            // 后台操作
            self.combination = StatisticsData().combination()
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
        
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // 注册Cell
        tableView.register(CombinationCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(tableView)
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return combination.isEmpty ? 0 : 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CombinationCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CombinationCell
        
        var text = ""
        switch indexPath.row {
        case 0:
            text = "1红球组合"
            break
        case 1:
            text = "2红球组合"
            break
        case 2:
            text = "3红球组合"
            break
        case 3:
            text = "4红球组合"
            break
        case 4:
            text = "5红球组合"
            break
        case 5:
            text = "1蓝球组合"
            break
        case 6:
            text = "2蓝球组合"
            break
        default:
            break
        }
        
        if indexPath.row > 4 {
            cell.ballView.setState(state: 3)
            cell.titleLabel.textColor = Common.blueColor
        }
        cell.titleLabel.text = text
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Combination", sender: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! CombinationViewController
        
        let indexPath = tableView.indexPathForSelectedRow
        destination.numbersCombination = combination[indexPath!.row+1]
        destination.number = indexPath!.row+1
        if indexPath!.row > 4 {
            destination.isRed = false
        }
    }
}
