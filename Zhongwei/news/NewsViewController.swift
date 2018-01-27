//
//  NewsViewController.swift
//  Zhongwei
//
//  Created by eesee on 2018/1/24.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class NewsViewController:WebViewController{
    override func viewDidLoad() {
        self.shopUrl = "http://yan.eeseetech.cn/mobile/wechat/news/"
        super.viewDidLoad()
        loadUrl(url: shopUrl!)
    }
}
