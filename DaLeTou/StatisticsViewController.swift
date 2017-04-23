//
//  StatisticsViewController.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/16.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit
import MBProgressHUD
import PNChart

/// 统计视图
class StatisticsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var reds = [NumbersCombin]()
    private var blues = [NumbersCombin]()
    private var heads = [NumbersCombin]()
    private var tails = [NumbersCombin]()
    private var valueOfSums = [NumbersCombin]()
    private var continuouses = [NumbersCombin]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async {
            let statisticsData = StatisticsData()
            self.reds = statisticsData.redCount()
            self.blues = statisticsData.blueCount()
            self.heads = statisticsData.headCount()
            self.tails = statisticsData.tailCount()
            self.valueOfSums = statisticsData.valueOfSum()
            self.continuouses = statisticsData.continuousCount()
            DispatchQueue.main.async {
                hud.hide(animated: true)
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - 建立界面
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "统计"
        createTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableView 初始化
    private var tableView: UITableView!
    private func createTableView() {
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.allowsSelection = false
        tableView.separatorInset = .zero
        
        self.view.addSubview(tableView)
        
        // 注册Cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "statisticsCell")
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "statisticsCell", for: indexPath)
        // 删除重影
        while cell.contentView.subviews.last != nil {
            cell.contentView.subviews.last?.removeFromSuperview()
        }
        switch indexPath.section {
        case 0:
            let pieChart = createChart(dataArray: reds)
            cell.contentView.addSubview(pieChart)
            break
        case 1:
            let pieChart = createChart(dataArray: blues)
            cell.contentView.addSubview(pieChart)
            break
        case 2:
            let pieChart = createChart(dataArray: heads)
            cell.contentView.addSubview(pieChart)
            break
        case 3:
            let pieChart = createChart(dataArray: tails)
            cell.contentView.addSubview(pieChart)
            break
        case 4:
            let pieChart = createChart(dataArray: valueOfSums)
            cell.contentView.addSubview(pieChart)
            break
        case 5:
            let pieChart = createChart(dataArray: continuouses)
            cell.contentView.addSubview(pieChart)
            break
        default:
            break
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Common.screenWidth
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: Common.screenWidth, height: 30))
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.backgroundColor = Common.redColor
        switch section {
        case 0:
            titleLabel.text = "红球"
            break
        case 1:
            titleLabel.text = "蓝球"
            break
        case 2:
            titleLabel.text = "头"
            break
        case 3:
            titleLabel.text = "尾"
            break
        case 4:
            titleLabel.text = "和值范围"
            break
        case 5:
            titleLabel.text = "连号概率"
            break
        default:
            break
        }
        
        return titleLabel
    }
    
    private func createChart(dataArray: [NumbersCombin]) -> UIView {
        let frame = CGRect(x: 10.0, y: 10.0, width: Common.screenWidth-20.0, height: Common.screenWidth-20.0)
        // 饼图数据设置
        var colors: [UIColor] = []
        let count = dataArray.count
        if count > 10 {
            for i in 0..<count {
                let color = UIColor(red: CGFloat(255 - i*2)/255.0,
                                    green: CGFloat(83 - i*1)/255.0,
                                    blue: CGFloat(75 - i*1)/255.0, alpha: 1.0)
                colors.append(color)
            }
        } else {
            colors = [Common.redColor, Common.blueColor, Common.greenColor,
                      Common.orangeColor, Common.yellowColor, Common.cyanColor,
                      UIColor.brown, UIColor.purple, UIColor.magenta,
                      Common.grayColor]
        }
        var items = [PNPieChartDataItem]()
        for i in 0..<count {
            let item = PNPieChartDataItem(value: CGFloat(dataArray[i].show),
                                          color: colors[i],
                                          description: dataArray[i].numbers)!
            items.append(item)
        }
        
        let pieChart = PNPieChart(frame: frame, items: items)!
        pieChart.descriptionTextColor = UIColor.white
        pieChart.descriptionTextFont = UIFont(name: "Avenir-Medium", size: 9.0)
        
        return pieChart
    }
}
