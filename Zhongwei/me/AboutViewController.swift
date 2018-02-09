//
//  AboutViewController.swift
//  Zhongwei
//
//  Created by eesee on 2018/2/2.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class AboutViewController:UITableViewController {
    
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame:.zero)
        let infoDictionary = Bundle.main.infoDictionary!
        let appDisplayName = infoDictionary["CFBundleDisplayName"]
        let majorVersion = infoDictionary["CFBundleShortVersionString"]
        let minorVersion = infoDictionary["CFBundleVersion"]
        let appVersion = majorVersion as! String
        let appName = appDisplayName as! String
        //appNameLabel.text = appName
        appVersionLabel.text = appVersion
        print("程序名称：\(appDisplayName)")
        print("主程序版本号：\(appVersion)")
        print("内部版本号：\(minorVersion)")
    }
}
