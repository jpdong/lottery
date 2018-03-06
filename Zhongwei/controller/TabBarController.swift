//
//  TabBarController.swift
//  Zhongwei
//
//  Created by eesee on 2018/1/23.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift

class TabBarController:UITabBarController{
    
    var meTab:UIViewController!
    
    override func viewDidLoad() {
        var  delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.tabViewController = self
        setUpTabs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //checkMessage()
    }
    
    func setUpTabs(){
        let newsTab:UIViewController = self.viewControllers![0]
        let shopTab:UIViewController = self.viewControllers![1]
        let discoverTab:UIViewController = self.viewControllers![2]
        meTab = self.viewControllers![3] as! UIViewController
        newsTab.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor(red:0x2e/255,green:0x6e/255,blue:0x55/255,alpha:1)], for: .selected)
        newsTab.tabBarItem.title = "资讯"
        newsTab.tabBarItem.image = UIImage(named:"news")
        newsTab.tabBarItem.selectedImage = UIImage(named:"news_selected")
        shopTab.tabBarItem.title = "业务"
        shopTab.tabBarItem.image = UIImage(named:"shop")
        shopTab.tabBarItem.selectedImage = UIImage(named:"shop_selected")
        shopTab.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor(red:0x2e/255,green:0x6e/255,blue:0x55/255,alpha:1)], for: .selected)
        discoverTab.tabBarItem.title = "发现"
        discoverTab.tabBarItem.image = UIImage(named:"discover")
        discoverTab.tabBarItem.selectedImage = UIImage(named:"discover_selected")
        discoverTab.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor(red:0x2e/255,green:0x6e/255,blue:0x55/255,alpha:1)], for: .selected)
        meTab.tabBarItem.title = "我"
        meTab.tabBarItem.image = UIImage(named:"me")
        meTab.tabBarItem.selectedImage = UIImage(named:"me_selected")
        //meTab.tabBarItem.badgeValue = "4"
        meTab.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor(red:0x2e/255,green:0x6e/255,blue:0x55/255,alpha:1)], for: .selected)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        Log("tab bar selected")
        checkMessage()
    }
    
    func checkMessage() {
        UserPresenter.updateMessages()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (messageResult) in
                if (messageResult.code == 0) {
                    var num = messageResult.messageList?.count
                    if (num! > 0) {
                        self.meTab.tabBarItem.badgeValue = String(describing:messageResult.messageList!.count)
                    } else {
                        self.meTab.tabBarItem.badgeValue = nil
                    }
                }
            })
    }
}
