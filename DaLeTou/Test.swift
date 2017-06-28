//
//  Test.swift
//  DaLeTou
//
//  Created by 刘明 on 2017/5/5.
//  Copyright © 2017年 刘明. All rights reserved.
//

import UIKit

class Test: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let ballView = BallView(frame: CGRect(x: 10, y: 10, width: 80, height: 80))
        ballView.setState(state: 3)
        ballView.titleLabel.text = "02"
        self.view.addSubview(ballView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
