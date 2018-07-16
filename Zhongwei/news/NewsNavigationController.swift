//
//  NewsNavigationController.swift
//  Zhongwei
//
//  Created by eesee on 2018/4/18.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class NewsNavigationController:UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = UIColor.black
        let vc = NewsViewController()
        pushViewController(vc, animated: true)
    }
}
