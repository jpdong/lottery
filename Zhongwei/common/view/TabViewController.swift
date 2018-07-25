//
//  TabViewController.swift
//  Zhongwei
//
//  Created by eesee on 2018/4/18.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import Toaster

class TabViewController:UITabBarController {
    
    var presenter:Presenter!
    var userPresenter:UserPresenter!
    var disposeBag:DisposeBag!
    var userNavigation:UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        disposeBag = DisposeBag()
        presenter = Presenter()
        userPresenter = UserPresenter()
        var  delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.tabViewController = self
        Timer.scheduledTimer(timeInterval: 3, target: self,
                             selector: #selector(checkAppUpdate),
                             userInfo: nil, repeats: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkMessage()
        checkUserState()
    }
    
    func setupViews() {
        let homeNavigation = HomeNavigationController()
        let newsNavigation = NewsNavigationController()
        let serviceNavigation = ServiceNavigationController()
        userNavigation = UserNavigationController()
        
        homeNavigation.tabBarItem.title = "首页"
        newsNavigation.tabBarItem.title = "资讯"
        serviceNavigation.tabBarItem.title = "客服"
        userNavigation.tabBarItem.title = "我"
        
        homeNavigation.tabBarItem.image = UIImage(named:"tab_home")
        newsNavigation.tabBarItem.image = UIImage(named:"news")
        serviceNavigation.tabBarItem.image = UIImage(named:"tab_service")
        userNavigation.tabBarItem.image = UIImage(named:"me")
        
        homeNavigation.tabBarItem.selectedImage = UIImage(named:"tab_home_selected")
        newsNavigation.tabBarItem.selectedImage = UIImage(named:"news_selected")
        serviceNavigation.tabBarItem.selectedImage = UIImage(named:"tab_service_selected")
        userNavigation.tabBarItem.selectedImage = UIImage(named:"me_selected")
        
        tabBar.tintColor = UIColor(red:0x2e/255,green:0x6e/255,blue:0x55/255,alpha:1)
        
        self.viewControllers = [homeNavigation, newsNavigation, serviceNavigation, userNavigation]
        self.selectedIndex = 0
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        Log("tab bar selected")
        checkMessage()
    }
    
    func checkMessage() {
        userPresenter.updateMessages()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (messageResult) in
                if (messageResult.code == 0) {
                    var num = messageResult.messageList?.count
                    if (num! > 0) {
                        self.userNavigation.tabBarItem.badgeValue = String(describing:messageResult.messageList!.count)
                    } else {
                        self.userNavigation.tabBarItem.badgeValue = nil
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
            presenter.checkSid(sid:sid!)
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
    
    @objc func checkAppUpdate() {
        presenter.checkAppUpdate()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                if (result.code == 0) {
                    if (result.update!) {
                        if (result.forceUpdate!) {
                            let alertView = UIAlertController(title:"重要更新", message:"新版本 \(result.version!)", preferredStyle:.alert)
                            self.present(alertView,animated: true,completion: nil)
                        } else {
                            Toast(text:"检测到新版本 \(result.version ?? "")").show()
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
