//
//  TabViewController.swift
//  Zhongwei
//
//  Created by eesee on 2018/4/18.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class TabViewController:UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let homeNavigation = HomeNavigationController()
        let newsNavigation = NewsNavigationController()
        let serviceNavigation = ServiceNavigationController()
        let userNavigation = UserNavigationController()
        
        homeNavigation.tabBarItem.title = "首页"
        newsNavigation.tabBarItem.title = "首页"
        serviceNavigation.tabBarItem.title = "首页"
        userNavigation.tabBarItem.title = "首页"
        
        homeNavigation.tabBarItem.image = UIImage(named:"tab_home")
        newsNavigation.tabBarItem.image = UIImage(named:"tab_home")
        serviceNavigation.tabBarItem.image = UIImage(named:"tab_home")
        userNavigation.tabBarItem.image = UIImage(named:"tab_home")
        
        homeNavigation.tabBarItem.selectedImage = UIImage(named:"tab_home_selected")
        newsNavigation.tabBarItem.selectedImage = UIImage(named:"tab_home_selected")
        serviceNavigation.tabBarItem.selectedImage = UIImage(named:"tab_home_selected")
        userNavigation.tabBarItem.selectedImage = UIImage(named:"tab_home_selected")
        
        tabBar.tintColor = UIColor(red:0x2e/255,green:0x6e/255,blue:0x55/255,alpha:1)
        
        self.viewControllers = [homeNavigation, newsNavigation, serviceNavigation, userNavigation]
        self.selectedIndex = 0
    }
}
