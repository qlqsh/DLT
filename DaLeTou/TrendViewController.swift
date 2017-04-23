//
//  TrendViewController.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/17.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit
import MBProgressHUD

class TrendViewController: UIViewController {
    private let userDefault = UserDefaults.standard
    private let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    private var trendData: TrendData!
    private var termAmount: Int {
        get {
            if userDefault.object(forKey: "termAmount") != nil {
                return userDefault.object(forKey: "termAmount") as! Int
            }
            return 0
        }
    }
    private var missing: Int {
        get {
            if userDefault.object(forKey: "missing") != nil {
                return userDefault.object(forKey: "missing") as! Int
            }
            return 0
        }
    }
    private var statistics: Int {
        get {
            if userDefault.object(forKey: "statistics") != nil {
                return userDefault.object(forKey: "statistics") as! Int
            }
            return 0
        }
    }
    private var selectedBall: Int {
        get {
            if userDefault.object(forKey: "selectedBall") != nil {
                return userDefault.object(forKey: "selectedBall") as! Int
            }
            return 0
        }
    }
    // 数字标签（第一行，必出）
    private var titleView: UIView {
        get {
            let height = Int(statusBarHeight + (self.navigationController?.navigationBar.frame.size.height)!)
            let customView = UIView(frame: CGRect(x: 0,
                                                  y: height,
                                                  width: 65 + 25 * 47,
                                                  height: 25))
            let numIssue = UIImageView(image: UIImage(named: "NumIssue"))
            customView.addSubview(numIssue)
            for i in 1...47 {
                let label = UILabel(frame: CGRect(x: Int(numIssue.frame.width) + (i - 1) * 25 ,
                                                  y: 0,
                                                  width: 25,
                                                  height: 25))
                label.backgroundColor = UIColor.red
                label.layer.borderWidth = 0.5
                label.layer.borderColor = Common.grayColor.cgColor
                if i <= 35 {
                    label.text = String(i)
                    if i < 10 {
                        label.text = "0" + String(i)
                    }
                } else {
                    label.text = String(i - 35)
                    if (i - 35) < 10 {
                        label.text = "0" + String(i - 35)
                    }
                }
                label.textColor = UIColor(colorLiteralRed: 123.0/255.0, green: 114.0/255.0, blue: 108.0/255.0, alpha: 1.0)
                label.textAlignment = .center
                label.font = UIFont.systemFont(ofSize: 16)
                label.backgroundColor = UIColor(colorLiteralRed: 236.0/255.0, green: 231.0/255.0, blue: 219.0/255.0, alpha: 1.0)
                customView.addSubview(label)
            }
            return customView
        }
    }
    // 走势（部分出）
    private func trendView(trendData: TrendData) -> UIView {
        let height = Int(statusBarHeight + (self.navigationController?.navigationBar.frame.size.height)!) + 25
        let customView = UIView(frame: CGRect(x: 0, y: height, width: 65+25*47, height: 25*100))
        let count = trendData.statistics.count
        let termIndex = self.termAmount
        var begin = count - 30
        if termIndex == 0 {
            begin = count - 30
        } else if termIndex == 1 {
            begin = count - 50
        } else if termIndex == 2 {
            begin = count - 100
        }
        let trendArray = Array(trendData.statistics[begin...count-1])
        let termArray = Array(trendData.terms[begin...count-1])
        var hasMissing = false
        if missing == 1 {
            hasMissing = true
        }
        var i = 0
        for anRowTrend in trendArray {
            let anRowTrendView = TrendAnRowView(frame: CGRect(x: 65, y: i*25, width: 65+25*47, height: 25))
            anRowTrendView.setTrendBalls(balls: anRowTrend, hasMissing: hasMissing)
            if i % 2 == 1 {
                anRowTrendView.changeBackground()
            }
            customView.addSubview(anRowTrendView)
            
            let titleLabel = UILabel(frame: CGRect(x: 0, y: i*25, width: 65, height: 25))
            titleLabel.text = termArray[i]
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: 11.0)
            titleLabel.layer.borderWidth = 0.5
            titleLabel.layer.borderColor = Common.grayColor.cgColor
            if i % 2 == 1 {
                titleLabel.backgroundColor = UIColor.groupTableViewBackground
            }
            customView.addSubview(titleLabel)
            i += 1
        }
        return customView
    }
    // 统计视图（可能出）
    private func statisticsView(trendData: TrendData) -> UIView {
        var height = Int(statusBarHeight + (self.navigationController?.navigationBar.frame.size.height)!) + 25
        if self.termAmount == 1 {
            height += 25 * 50
        } else if self.termAmount == 2 {
            height += 25 * 100
        } else {
            height += 25 * 30
        }
        let viewWidth = 65 + 25 * 47
        let customView = UIView(frame: CGRect(x: 0,
                                              y: height,
                                              width: viewWidth,
                                              height: 100))
        // 数据
        let numberOfOccurrences = trendData.numberOfOccurrences
        let maxContinuous = trendData.maxContinuousOccurrences
        let maxMissings = trendData.maxMissing
        let averageMissings = trendData.averageMissing
        // 出现次数
        let numberOfOccurrencesView = TrendAnRowStatisticsView(frame: CGRect(x: 0,
                                                                             y: 0,
                                                                             width: viewWidth,
                                                                             height: 25))
        numberOfOccurrencesView.setStatisticsData(data: numberOfOccurrences)
        numberOfOccurrencesView.setState(state: 0)
        numberOfOccurrencesView.titleLabel.text = "出现次数"
        customView.addSubview(numberOfOccurrencesView)
        let maxContinuousView = TrendAnRowStatisticsView(frame: CGRect(x: 0,
                                                                       y: 25,
                                                                       width: viewWidth,
                                                                       height: 25))
        maxContinuousView.setStatisticsData(data: maxContinuous)
        maxContinuousView.setState(state: 1)
        maxContinuousView.titleLabel.text = "最大连出"
        customView.addSubview(maxContinuousView)
        let maxMissingsView = TrendAnRowStatisticsView(frame: CGRect(x: 0,
                                                                     y: 50,
                                                                     width: viewWidth,
                                                                     height: 25))
        maxMissingsView.setStatisticsData(data: maxMissings)
        maxMissingsView.setState(state: 2)
        maxMissingsView.titleLabel.text = "最大遗漏"
        customView.addSubview(maxMissingsView)
        let averageMissingsView = TrendAnRowStatisticsView(frame: CGRect(x: 0,
                                                                         y: 75,
                                                                         width: viewWidth,
                                                                         height: 25))
        averageMissingsView.setStatisticsData(data: averageMissings)
        averageMissingsView.setState(state: 3)
        averageMissingsView.titleLabel.text = "平均遗漏"
        customView.addSubview(averageMissingsView)
        return customView
    }
    private var ballButtonView: UIView {
        get {
            var height = Int(statusBarHeight + (self.navigationController?.navigationBar.frame.size.height)!) + 25
            if self.termAmount == 1 {
                height += 25 * 50
            } else if self.termAmount == 2 {
                height += 25 * 100
            } else {
                height += 25 * 30
            }
            if self.statistics == 1 {
                height += 25 * 4
            }
            let customView = UIView(frame: CGRect(x: 0,
                                                  y: height,
                                                  width: 65 + 25 * 47,
                                                  height: 25))
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 65, height: 25))
            titleLabel.text = "选号"
            titleLabel.textColor = UIColor.magenta
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: 11.0)
            titleLabel.layer.borderWidth = 0.5
            titleLabel.layer.borderColor = Common.grayColor.cgColor
            customView.addSubview(titleLabel)
            for i in 1...47 {
                let button = BallButton(frame: CGRect(x: 65 + (i - 1) * 25 + 1 ,
                                                      y: 1,
                                                      width: 23,
                                                      height: 23))
                button.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
                if i <= 35 {
                    button.setText(text: String(i))
                    if i < 10 {
                        button.setText(text: "0" + String(i))
                    }
                    button.setBall(isRed: true)
                } else {
                    button.setText(text: String(i - 35))
                    if (i - 35) < 10 {
                        button.setText(text: "0" + String(i - 35))
                    }
                    button.setBall(isRed: false)
                }
                customView.addSubview(button)
            }
            customView.layer.borderWidth = 0.5
            customView.layer.borderColor = Common.grayColor.cgColor
            return customView
        }
    }
    
    private func createScrollView(trendData: TrendData) -> UIScrollView {
        var height = 25
        if self.termAmount == 1 {
            height += 25 * 50
        } else if self.termAmount == 2 {
            height += 25 * 100
        } else {
            height += 25 * 30
        }
        if self.statistics == 1 {
            height += 25 * 4
        }
        if self.selectedBall == 1 {
            height += 25
        }
        let scrollView = UIScrollView(frame: self.view.bounds)
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.isDirectionalLockEnabled = true
        
        scrollView.addSubview(self.titleView)
        scrollView.addSubview(trendView(trendData: trendData))
        if self.statistics == 1 {
            scrollView.addSubview(statisticsView(trendData: trendData))
        }
        if self.selectedBall == 1 {
            scrollView.addSubview(self.ballButtonView)
        }
        
        scrollView.contentSize = CGSize(width: 65 + 25*47, height: height + Int(statusBarHeight + (self.navigationController?.navigationBar.frame.size.height)!))
        
        return scrollView
    }
    
    // 设置（行数、是否显示遗漏、是否显示统计、是否显示按钮行）
    func setAction() {
        let alert = UIAlertController(title: "走势图设置",
                                      message: "\n\n\n\n\n\n\n\n\n\n",
                                      preferredStyle: .alert)
        
        let termAmountSegmented = UISegmentedControl(items: ["近30期", "近50期", "近100期"])
        termAmountSegmented.frame = CGRect(x: 10, y: 60, width: 250, height: 30)
        termAmountSegmented.tintColor = Common.redColor
        termAmountSegmented.selectedSegmentIndex = self.termAmount
        alert.view.addSubview(termAmountSegmented)
        
        let missingSegmented = UISegmentedControl(items: ["隐藏遗漏", "显示遗漏"])
        missingSegmented.frame = CGRect(x: 10, y: 100, width: 250, height: 30)
        missingSegmented.tintColor = Common.redColor
        missingSegmented.selectedSegmentIndex = self.missing
        alert.view.addSubview(missingSegmented)
        
        let statisticsSegmented = UISegmentedControl(items: ["隐藏统计", "显示统计"])
        statisticsSegmented.frame = CGRect(x: 10, y: 140, width: 250, height: 30)
        statisticsSegmented.tintColor = Common.redColor
        statisticsSegmented.selectedSegmentIndex = self.statistics
        alert.view.addSubview(statisticsSegmented)
        
        let selectedBallSegmented = UISegmentedControl(items: ["隐藏选号", "显示选号"])
        selectedBallSegmented.frame = CGRect(x: 10, y: 180, width: 250, height: 30)
        selectedBallSegmented.tintColor = Common.redColor
        selectedBallSegmented.selectedSegmentIndex = self.selectedBall
        alert.view.addSubview(selectedBallSegmented)
        
        let okAction = UIAlertAction(title: "确认", style: .default) { (UIAlertAction) in
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.userDefault.set(termAmountSegmented.selectedSegmentIndex, forKey: "termAmount")
                self.userDefault.set(missingSegmented.selectedSegmentIndex, forKey: "missing")
                self.userDefault.set(statisticsSegmented.selectedSegmentIndex, forKey: "statistics")
                self.userDefault.set(selectedBallSegmented.selectedSegmentIndex, forKey: "selectedBall")
                self.userDefault.synchronize()
                
                for view in self.view.subviews {
                    if view.isKind(of: UIScrollView.self) {
                        view.removeFromSuperview()
                    }
                }
                hud.hide(animated: true)
                self.view.addSubview(self.createScrollView(trendData: self.trendData))
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async {
            self.trendData = TrendData()
            DispatchQueue.main.async {
                hud.hide(animated: true)
                self.view.addSubview(self.createScrollView(trendData: self.trendData))
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "走势图"
        // 设置视图
        let settingButtonItem = UIBarButtonItem(image: UIImage(named: "Setting"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(setAction))
        settingButtonItem.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = settingButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
