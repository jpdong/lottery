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
        checkUserState()
        checkAppUpdate()
    }
    
    func setUpTabs(){
        let mainPageTab:UIViewController = self.viewControllers![0]
        let newsTab:UIViewController = self.viewControllers![1]
        let discoverTab:UIViewController = self.viewControllers![2]
        meTab = self.viewControllers![3] as! UIViewController
        newsTab.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor(red:0x2e/255,green:0x6e/255,blue:0x55/255,alpha:1)], for: .selected)
        newsTab.tabBarItem.title = "资讯"
        newsTab.tabBarItem.image = UIImage(named:"news")
        newsTab.tabBarItem.selectedImage = UIImage(named:"news_selected")
        mainPageTab.tabBarItem.title = "首页"
        mainPageTab.tabBarItem.image = UIImage(named:"tab_home")
        mainPageTab.tabBarItem.selectedImage = UIImage(named:"tab_home_selected")
        mainPageTab.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor(red:0x2e/255,green:0x6e/255,blue:0x55/255,alpha:1)], for: .selected)
        discoverTab.tabBarItem.title = "客服"
        discoverTab.tabBarItem.image = UIImage(named:"tab_service")
        discoverTab.tabBarItem.selectedImage = UIImage(named:"tab_service_selected")
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
    
    func checkUserState() {
        let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let sid = app.globalData?.sid
        var result:Bool = false
        if (sid != nil && sid! != ""){
            Log("sid:\(sid!)")
            Presenter.checkSid(sid:sid!)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (result) in
                    if (result.code == 0) {
                    } else {
                        self.showLoginView()
                    }
                })
            
        } else {
            showLoginView()
        }
    }
    
    func checkAppUpdate() {
        Presenter.checkAppUpdate()
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                if (result.code == 0) {
                    if (result.update!) {
                        if (result.forceUpdate!) {
                            let alertView = UIAlertController(title:"检测到新版本", message:result.version!, preferredStyle:.alert)
//                            let confirm = UIAlertAction(title:"确定", style:.default){
//                                action in
//                                //self.performSegue(withIdentifier: "showMe", sender: self)
//                                self.tabBarController?.tabBar.isHidden = false
//                                self.tabBarController?.selectedIndex = 3
//                            }
//                            alertView.addAction(cancel)
//                            alertView.addAction(confirm)
                            self.present(alertView,animated: true,completion: nil)
                        } else {
                            alert(viewController: self, title: "检测到新版本", message:result.version!)
                        }
                        
                        
                    }
                }
            })
    }
    
    func showLoginView() {
        let sb = UIStoryboard(name:"Me",bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(vc, animated: true, completion: nil)
        //        let vc = LoginViewControllerCode()
        //        self.present(vc, animated: true, completion: nil)
    }
}
