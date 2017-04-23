//
//  CalculateMoneyViewController.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/14.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit
import MBProgressHUD

class CalculateMoneyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    private var latestWinning = DataManager().readLatestWinningInFile()
    private let recentlyWinnings = Array(DataManager().readAllWinningsInFile()[0...10])
    private var myNumbers = [Winning]() // 我选择的号码数组
    private var winningDescription = ""
    
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
        tableView.register(WinningCell.self, forCellReuseIdentifier: "winningCell")
        tableView.register(MyNumberCell.self, forCellReuseIdentifier: "myNumberCell")
        tableView.register(ButtonCell.self, forCellReuseIdentifier: "buttonCell")
        tableView.register(WinningDescriptionCell.self, forCellReuseIdentifier: "winningDescriptionCell")
    }
    
    var pickerView: UIPickerView!
    func createPickerView() {
        pickerView = UIPickerView(frame: CGRect.zero)
        pickerView.frame = CGRect(x: 0, y: 40, width: 270, height: 162)
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.selectRow(0, inComponent: 0, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "中奖计算"
        
        createTableView()
        createPickerView()
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
        case 0: // 最近获奖
            return 1
        case 1: // 条件行
            return myNumbers.count
        case 2: // 按钮行
            return 1
        case 3: // 结果行
            if winningDescription == "" {
                return 0
            }
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: WinningCell = tableView.dequeueReusableCell(withIdentifier: "winningCell", for: indexPath) as! WinningCell
            cell.termLabel.text = "第"+latestWinning.term+"期"
            let dateString = latestWinning.date
            cell.dateLabel.text = dateString+"（"+Common.calculateWeekday(dateString: dateString)+"）"
            
            var balls = [String]()
            balls.append(contentsOf: latestWinning.reds)
            balls.append(contentsOf: latestWinning.blues)
            cell.winningBallView.setTextContent(textArray: balls)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectedWinningTermAction))
            cell.addGestureRecognizer(tapGestureRecognizer)
            
            return cell
        case 1:
            let cell: MyNumberCell = tableView.dequeueReusableCell(withIdentifier: "myNumberCell", for: indexPath) as! MyNumberCell
            // 删除重影
            while cell.contentView.subviews.last != nil {
                cell.contentView.subviews.last?.removeFromSuperview()
            }
            let winning = myNumbers[indexPath.row]
            cell.setBalls(reds: winning.reds, blues: winning.blues)
            return cell
        case 2:
            let cell: ButtonCell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as! ButtonCell
            cell.addButton.setTitle("我的号码", for: .normal)
            cell.addButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
            cell.clearButton.addTarget(self, action: #selector(clearAction), for: .touchUpInside)
            cell.calculateButton.addTarget(self, action: #selector(calculateAction), for: .touchUpInside)
            return cell
        case 3:
            let cell: WinningDescriptionCell = tableView.dequeueReusableCell(withIdentifier: "winningDescriptionCell", for: indexPath) as! WinningDescriptionCell
            cell.winningDescription.text = winningDescription
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
            return WinningCell.heightOfCell
        case 1:
            let winning = myNumbers[indexPath.row]
            return MyNumberCell.heightOfCell(count: winning.reds.count+winning.blues.count)
        case 2:
            return ButtonCell.heightOfCell
        case 3:
            return WinningDescriptionCell.heightOfCell
        default:
            return 40.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 20.0
        case 1:
            return 20.0
        default:
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: Common.screenWidth, height: 20))
        headerLabel.backgroundColor = Common.redColor
        headerLabel.textAlignment = .center
        headerLabel.textColor = .white
        
        switch section {
        case 0:
            headerLabel.text = "开奖号码"
            break
        case 1:
            headerLabel.text = "我的号码"
            break
        default:
            break
        }
        
        return headerLabel
    }
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return recentlyWinnings.count
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let winning = recentlyWinnings[row]
        let dateString = winning.date
        return winning.term + "期（"+Common.calculateWeekday(dateString: dateString)+"）"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        latestWinning = recentlyWinnings[row]
    }
    
    // MARK: - 动作
    func selectedWinningTermAction() {
        let alert = UIAlertController(title: "期号",
                                      message: "\n\n\n\n\n\n\n\n\n",
                                      preferredStyle: .alert)
        alert.view.addSubview(pickerView)
        
        let okAction = UIAlertAction(title: "确认", style: .default) { (UIAlertAction) in
            self.tableView.reloadData()
        }
        okAction.setValue(Common.redColor, forKey: "titleTextColor")
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /// “清除”动作
    func clearAction() {
        myNumbers.removeAll()
        winningDescription = ""
        tableView.reloadData()
    }
    
    /// “计算”动作
    func calculateAction() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async {
            self.winningDescription = StatisticsData().calculateMoney(currentWinning: self.latestWinning, myNumbers: self.myNumbers)
            DispatchQueue.main.async {
                // 主线程中
                self.tableView.reloadData()
                hud.hide(animated: true)
            }
        }
    }
    
    /// ”添加我的号码“动作
    func addAction() {
        let alert = UIAlertController(title: "条件",
                                      message: "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n",
                                      preferredStyle: .alert)
        let width = 30
        let redsView = UIView(frame: CGRect(x: 16,
                                            y: 50,
                                            width: (width + 4) * 7,
                                            height: (width + 4) * 5))
        var redsArray = [BallButton]()
        var j = 0
        for i in 1...35 {
            if (i - 1) % 7 == 0 {
                j += 1
            }
            let positionX = 2 + ((i - 1) % 7) * (width + 4)
            let positionY = 2 + (j - 1) * (width + 4)
            let ballButton = BallButton(frame: CGRect(x: positionX, y: positionY, width: width, height: width))
            ballButton.setBall(isRed: true)
            if i < 10 {
                ballButton.setText(text: "0" + String(i))
            } else {
                ballButton.setText(text: String(i))
            }
            redsView.addSubview(ballButton)
            redsArray.append(ballButton)
        }
        redsView.layer.borderWidth = 0.5
        redsView.layer.borderColor = Common.redColor.cgColor
        redsView.layer.cornerRadius = 5
        alert.view.addSubview(redsView)
        
        let bluesView = UIView(frame: CGRect(x: 16,
                                             y: Int(50 + redsView.frame.size.height + 10),
                                             width: (width + 4) * 7,
                                             height: (width + 4) * 2))
        var bluesArray = [BallButton]()
        j = 0
        for i in 1...12 {
            if (i - 1) % 7 == 0 {
                j += 1
            }
            let positionX = 2 + ((i - 1) % 7) * (width + 4)
            let positionY = 2 + (j - 1) * (width + 4)
            let ballButton = BallButton(frame: CGRect(x: positionX, y: positionY, width: width, height: width))
            ballButton.setBall(isRed: false)
            if i < 10 {
                ballButton.setText(text: "0" + String(i))
            } else {
                ballButton.setText(text: String(i))
            }
            bluesView.addSubview(ballButton)
            bluesArray.append(ballButton)
        }
        bluesView.layer.borderWidth = 0.5
        bluesView.layer.borderColor = Common.blueColor.cgColor
        bluesView.layer.cornerRadius = 5
        alert.view.addSubview(bluesView)
        
        let okAction = UIAlertAction(title: "确认", style: .default) { (UIAlertAction) in
            if self.myNumbers.count > 20 {
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.mode = MBProgressHUDMode.text
                hud.label.text = "您的获奖号码太多了！"
                hud.hide(animated: true, afterDelay: 2.0)
            } else {
                var selectedRedBalls = [String]()
                for redBall in redsArray {
                    if redBall.isSelected {
                        selectedRedBalls.append(redBall.title(for: .normal)!)
                    }
                }
                var selectedBlueBalls = [String]()
                for blueBall in bluesArray {
                    if blueBall.isSelected {
                        selectedBlueBalls.append(blueBall.title(for: .normal)!)
                    }
                }
                let selectedBall = Winning(redString: selectedRedBalls.joined(separator: " "),
                                           blueString: selectedBlueBalls.joined(separator: " "))
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.mode = MBProgressHUDMode.text
                if selectedRedBalls.count < 5 {
                    hud.label.text = "最少需要选择5个红球！"
                    hud.hide(animated: true, afterDelay: 2.0)
                } else if selectedBlueBalls.count < 2 {
                    hud.label.text = "最少需要选择2个蓝球！"
                    hud.hide(animated: true, afterDelay: 2.0)
                } else if selectedRedBalls.count > 15 {
                    hud.label.text = "最多只能选择15个红球！"
                    hud.hide(animated: true, afterDelay: 2.0)
                } else {
                    hud.hide(animated: true)
                    self.myNumbers.append(selectedBall)
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
