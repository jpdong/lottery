//
//  HomeNavigationViewController.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/14.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class HomeNavigationController:UINavigationController {
    
    override func viewDidLoad() {
        navigationBar.tintColor = UIColor.black
        let vc = MainPageViewController()
        pushViewController(vc, animated: true)
    }
}
