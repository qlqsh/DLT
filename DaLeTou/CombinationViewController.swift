//
//  RedCombinationViewController.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/4/7.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit

class CombinationViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var numbersCombination : [NumbersCombin]?
    var number : Int!
    var isRed = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let text = isRed ? "红球" : "蓝球"
        if number > 5 {
            number = number - 5
        }
        self.title = "\(String(number))个\(text)组合"
        createCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionView 初始化
    private var collectionViewFlowLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        var width = 40.0 * Double(number)
        if number > 5 {
            width = 40.0 * Double(number-5)
        }
        layout.estimatedItemSize = CGSize(width: width, height: 60.0)
        layout.itemSize = CGSize(width: width, height: 40.0)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        return layout
    }

    private var collectionView: UICollectionView!
    private func createCollectionView() {
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: collectionViewFlowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let backgroundImage = UIImage(named: "Background")
        collectionView.layer.contents = backgroundImage?.cgImage
    
        // 注册
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "combinationCell")
    
        self.view.addSubview(collectionView)
    }

    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbersCombination!.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "combinationCell", for: indexPath)
        
        // 如果重影，使用下面方法消除重影
        while cell.contentView.subviews.last != nil {
            cell.contentView.subviews.last?.removeFromSuperview()
        }
        
        // 数字组合
        let numbersCombination = self.numbersCombination![indexPath.row]
        let numberArray = numbersCombination.numbers.components(separatedBy: " ")
        var i = 0
        for number in numberArray {
            let ballView = BallView(frame: CGRect(x: i*40, y: 0, width: 40, height: 40))
            isRed ? ballView.setState(state: 2) : ballView.setState(state: 3)
            ballView.titleLabel.text = number
            i += 1
            cell.contentView.addSubview(ballView)
        }
        
        // 数字标签
        let showLabel = UILabel(frame: CGRect(x: 0, y:40, width:40*i, height:20))
        showLabel.text = "[\(String(numbersCombination.show))]"
        showLabel.textColor = UIColor.darkGray
        showLabel.textAlignment = .center
        showLabel.font = UIFont.systemFont(ofSize: 12.0)
        cell.contentView.addSubview(showLabel)
        
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = Common.grayColor.cgColor
        cell.layer.cornerRadius = 5.0
    
        return cell
    }
}
