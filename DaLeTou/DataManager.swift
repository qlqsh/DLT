//
//  DataManager.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/3/2.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit
import Alamofire
import Fuzi

/// 大乐透所有获奖信息。数据从网络获取，存储在本地。位置：/Library/Caches/dlt_winnings.plist
class DataManager: NSObject {
    private let baseURL = "http://datachart.500.com/dlt/history/newinc/history.php?"
    private let documentPath = NSHomeDirectory() + "/Library/Caches/dlt_winnings.plist"
    
    // MARK: - 本地文档数据
    /// 最新获奖数据（本地）
    func readLatestWinningInFile() -> Winning {
        let winnings = readAllWinningsInFile()
        return winnings.first!
    }
    
    /// 所有获奖数据（本地；主要方法，其它方法主要调用它。）
    func readAllWinningsInFile() -> Array<Winning> {
        return NSKeyedUnarchiver.unarchiveObject(withFile: self.documentPath) as! Array<Winning>
    }
    
    /// 所有获奖数据（本地；逆序；走势图用。）
    func readAllWinningsInFileUseReverse() -> Array<Winning> {
        return readAllWinningsInFile().reversed()
    }
    
    // MARK: - 网络处理
    /// 完整URL（添加范围参数）
    private func completeURL(start: String) -> String {
        let start = "start=" + start
        let year = calculateYear()%2000
        let end: String = "&end=\(year)001"
        
        return baseURL + start + end
    }
    
    /// 计算明年，用于网络提取获奖数据确定范围。
    private func calculateYear() -> Int {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month, .day, .weekday, .hour, .minute, .second], from: Date())
        
        return components.year!+1
    }
    
    /// 更新数据（网络）
    func updateWinningsUseNetworking() {
        // 判断文档不存在
        if !self.documentExists() {
            // 拷贝文档到指定目录
            if self.copyDocument() {
                // 更新文档
                self.getLatestWinningsUseNetworking()
            }
        } else { // 文档存在
            // 更新文档
            self.getLatestWinningsUseNetworking()
        }
        
        // 修复损坏文档
        self.repairBadDocument()
    }
    
    /// 获取最新数据（网络）
    private func getLatestWinningsUseNetworking() {
        let winning = readLatestWinningInFile()
        Alamofire.request(completeURL(start: winning.term)).response { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                do {
                    let doc = try HTMLDocument(string: utf8Text)
                    var winnings = [Winning]()
                    for tdata in doc.xpath("//tbody[@id='tdata']") {
                        let winningDoc = try HTMLDocument(string: tdata.rawXML)
                        for anWinningInfo in winningDoc.xpath("//tr") {
                            let winning = Winning.init(winningHTML: anWinningInfo.rawXML)
                            winnings.append(winning)
                        }
                    }
                    if winnings.count > 1 { // 有新数据
                        let oldWinnings = self.readAllWinningsInFile()
                        winnings.append(contentsOf: Array(oldWinnings[1...oldWinnings.count-1]))
                        if NSKeyedArchiver.archiveRootObject(winnings, toFile: self.documentPath) {
//                            print("写文件成功")
                        }
                    }
                } catch let error {
                    print(error)
                }
            }
        }
    }
    
    /// 重新获取所有数据（网络）
    private func resetAllWinningsUseNetworking() {
        Alamofire.request(completeURL(start: "07001")).response { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                do {
                    let doc = try HTMLDocument(string: utf8Text)
                    var winnings = [Winning]()
                    for tdata in doc.xpath("//tbody[@id='tdata']") {
                        let winningDoc = try HTMLDocument(string: tdata.rawXML)
                        for anWinningInfo in winningDoc.xpath("//tr") {
                            let winning = Winning.init(winningHTML: anWinningInfo.rawXML)
                            winnings.append(winning)
                        }
                    }
                    if NSKeyedArchiver.archiveRootObject(winnings, toFile: self.documentPath) {
                        print("写文件成功")
                    }
                } catch let error {
                    print(error)
                }
            }
        }
    }

    // MARK: - 本地文档处理
    /// 拷贝文档到本地
    private func copyDocument() -> Bool {
        do {
            let path = Bundle.main.path(forResource: "dlt_winnings", ofType: "plist")
            try FileManager().copyItem(atPath: path!, toPath: documentPath)
        } catch let error {
            print(error)
        }
        
        return documentExists()
    }
    
    /// 删除本地文档
    private func removeDocument() -> Bool {
        do {
            try FileManager().removeItem(atPath: documentPath)
        } catch let error {
            print(error)
        }
        
        return !documentExists()
    }
    
    /// 修复受损文档
    private func repairBadDocument() {
        // 判断文档中的信息是否完整
        let winnings = readLatestWinningInFile()
        if winnings.term.isEmpty || winnings.reds.isEmpty || winnings.blues.isEmpty {
            print("修复受损文档")
            // 删除受损文档
            if removeDocument() {
                // 把健康文档拷贝过去
                if copyDocument() {
                    self.getLatestWinningsUseNetworking()
                }
            }
        }
    }
    
    /// 判断文档（winnings.plist）是否存在
    private func documentExists() -> Bool {
        return FileManager().fileExists(atPath: documentPath)
    }
}
