//
//  FunctionListViewController.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/20.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit
import Alamofire
import ReachabilitySwift
import MBProgressHUD

class FunctionListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startReachabilityMonitor()
                
        self.title = "功能列表"
        // 视图加载
        createCollectionView()
        updateDataUseNetworking()
        
        // 更新
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(updateDataUseNetworking))
        refreshButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = refreshButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        stopReachabilityMonitor()
    }
    
    // MARK: - 网络更新
    private var combination = [Int: [NumbersCombin]]()
    /// 通过网络更新获奖数据
    func updateDataUseNetworking() {
        if reachability.isReachable { // 网络可用
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            DispatchQueue.global().async {
                DataManager().updateWinningsUseNetworking()
                DispatchQueue.main.async {
                    hud.hide(animated: true)
                }
            }
        } else {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = MBProgressHUDMode.text
            hud.label.text = "网络无法访问"
            hud.hide(animated: true, afterDelay: 2.0)
        }
    }
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "functionCell", for: indexPath)
        cell.selectedBackgroundView = UIView(frame: cell.frame)
        cell.selectedBackgroundView?.backgroundColor = UIColor.groupTableViewBackground
        
        // 删除重影
        while cell.contentView.subviews.last != nil {
            cell.contentView.subviews.last?.removeFromSuperview()
        }
        
        let functionView = FunctionView(frame: cell.bounds)
        functionView.setState(state: indexPath.row)
        cell.contentView.addSubview(functionView)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: // 获奖列表
            performSegue(withIdentifier: "Winnings", sender: nil)
        case 1: // 走势图
            performSegue(withIdentifier: "Trend", sender: nil)
        case 2: // 历史同期
            performSegue(withIdentifier: "HistorySame", sender: nil)
        case 3: // 统计
            performSegue(withIdentifier: "Statistics", sender: nil)
        case 4: // 相似走势
            performSegue(withIdentifier: "ConditionTrend", sender: nil)
        case 5: // 计算奖金
            performSegue(withIdentifier: "CalculateMoney", sender: nil)
        case 6: // 号码组合
            performSegue(withIdentifier: "CombinationAll", sender: nil)
        case 7: // 号码契合度
            performSegue(withIdentifier: "Compatibility", sender: nil)
        default:
            break
        }
    }
    
    // MARK: - UICollectionView 属性设置
    private var collectionViewFlowLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let cellWidth = Common.screenWidth/2
        let cellHeight = cellWidth * 1.25
        layout.estimatedItemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }
    
    private var collectionView: UICollectionView!
    private func createCollectionView() {
        let collectionView = UICollectionView(frame: self.view.bounds,
                                              collectionViewLayout: collectionViewFlowLayout)
        
        let backgroundImage = UIImage(named: "Background")
        collectionView.layer.contents = backgroundImage?.cgImage
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // 注册
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "functionCell")
        
        self.view.addSubview(collectionView)
    }
    
    // MARK: - 网络监控
    let reachability = Reachability()!
    /// 开始网络监控
    func startReachabilityMonitor() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reachabilityChanged),
                                               name: ReachabilityChangedNotification,
                                               object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
//            print("无法开始网络状态监控")
        }
    }
    
    /// 停止网络监控
    func stopReachabilityMonitor() {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self,
                                                  name: ReachabilityChangedNotification,
                                                  object: reachability)
    }
    
    /// 网络状况改变
    func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable {
            if reachability.isReachableViaWiFi { // WiFi
//                print("WiFi可用")
            } else { // 移动网络
//                print("4G可用")
            }
        } else {
//            print("网络无法访问")
        }
    }
}
