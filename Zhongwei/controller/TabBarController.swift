//
//  TabBarController.swift
//  Zhongwei
//
//  Created by eesee on 2018/1/23.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class TabBarController:UITabBarController{
    
    override func viewDidLoad() {
        var  delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.tabViewController = self
        
        setUpTabs()
    }
    
    func setUpTabs(){
        let newsTab:UIViewController = self.viewControllers![0]
        let shopTab:UIViewController = self.viewControllers![1]
        let discoverTab:UIViewController = self.viewControllers![2]
        let meTab:UIViewController = self.viewControllers![3]
        newsTab.tabBarItem.title = "资讯"
        newsTab.tabBarItem.image = UIImage(named:"news")
        newsTab.tabBarItem.selectedImage = UIImage(named:"news_selected")
        shopTab.tabBarItem.title = "业务"
        shopTab.tabBarItem.image = UIImage(named:"shop")
        shopTab.tabBarItem.selectedImage = UIImage(named:"shop_selected")
        discoverTab.tabBarItem.title = "发现"
        discoverTab.tabBarItem.image = UIImage(named:"discover")
        discoverTab.tabBarItem.selectedImage = UIImage(named:"discover_selected")
        meTab.tabBarItem.title = "我"
        meTab.tabBarItem.image = UIImage(named:"me")
        meTab.tabBarItem.selectedImage = UIImage(named:"me_selected")
    }
}
