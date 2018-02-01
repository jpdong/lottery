//
//  ShopViewController.swift
//  Zhongwei
//
//  Created by eesee on 2018/1/24.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import WebKit
import RxSwift

class ShopViewController: UIViewController,WKUIDelegate,WKNavigationDelegate {
    
    var backButton: UIBarButtonItem!
    var fullScreenButton:UIBarButtonItem!
    //var progressView: UIProgressView!
    var navigationBar:UINavigationBar!
    var webView:WKWebView!
    var webNavigationItem:UINavigationItem!
    var shopUrl:String?
    var segmentedControl:UISegmentedControl!
    var unionid:String?
    
    @objc func goBack(_ sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    @objc func switchFullScreen(_ sender:UIBarButtonItem){
        if (self.tabBarController?.tabBar.isHidden == true) {
            self.tabBarController?.tabBar.isHidden = false
        } else {
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
    func goForward(_ sender: UIBarButtonItem) {
        webView.goForward()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        setupViews()
    }
    
    func setupViews(){
        navigationBar = UINavigationBar(frame:CGRect( x:0,y:20, width:self.view.frame.width, height:44))
        webNavigationItem = UINavigationItem()
        backButton = UIBarButtonItem(title:"后退",style:.plain, target:self, action:#selector(goBack))
        fullScreenButton = UIBarButtonItem(title:"全屏", style:.plain, target:self, action:#selector(switchFullScreen))
        //backButton.image = UIImage(named:"back")
        webNavigationItem.setLeftBarButton(backButton, animated: true)
        webNavigationItem.setRightBarButton(fullScreenButton, animated: true)
        
        segmentedControl = UISegmentedControl(items:["零售店主", "客户经理", "区域经理"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.frame = CGRect(x:0, y:64, width:UIScreen.main.bounds.width * 0.4, height:20)
        segmentedControl.layer.cornerRadius = 5.0
        segmentedControl.addTarget(self, action: #selector(segmentedValueChanged(_:)), for: .valueChanged)
        webNavigationItem.titleView = segmentedControl
        
        navigationBar?.pushItem(webNavigationItem, animated: true)
        self.view.addSubview(navigationBar!)
        //self.view.addSubview(segmentedControl)
        //progressView = UIProgressView(frame: CGRect(x:0, y:0, width:self.view.frame.width, height:4))
        //self.view.addSubview(progressView)
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: CGRect(x:0,y:64, width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height - 64), configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        backButton.isEnabled = false
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath:"title", options:.new, context:nil)
    }
    
    @objc func segmentedValueChanged(_ sender:UISegmentedControl){
        print("selected segment index is : \(sender.selectedSegmentIndex)")
        switch sender.selectedSegmentIndex {
        case 0:
            //Presenter.getShopUrl(unionid: "o6mWl1a58jqGX_TAT6tpd2zpJ2lI")
//            Presenter.getShopUrl(unionid: unionid!)
//                .observeOn(MainScheduler.instance)
//                .subscribe(onNext:{
//                    url in
//                    self.loadUrl(url: url)
//                })
            break
        case 1:
            //Presenter.getManagerUrl(unionid: "o6mWl1a58jqGX_TAT6tpd2zpJ2lI")
//            Presenter.getManagerUrl(unionid: unionid!)
//                .observeOn(MainScheduler.instance)
//                .subscribe(onNext:{
//                    url in
//                    self.loadUrl(url: url)
//                })
            break
        case 2:
            //Presenter.getAreaManagerUrl(unionid: "o6mWl1a58jqGX_TAT6tpd2zpJ2lI")
//            Presenter.getAreaManagerUrl(unionid: unionid!)
//                .observeOn(MainScheduler.instance)
//                .subscribe(onNext:{
//                    url in
//                    self.loadUrl(url: url)
//                })
            break
        default:
            break
        }
    }
    
    func loadUrl(url:String){
        if (url != nil){
            let myUrl = URL(string:url)
            let myRequest = URLRequest(url:myUrl!)
            webView.load(myRequest)
        } else {
            print("Url is nil")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "loading") {
            backButton.isEnabled = webView.canGoBack
        }
        if (keyPath == "estimatedProgress") {
            //progressView.isHidden = webView.estimatedProgress == 1
            //progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
        if (keyPath == "title") {
            print("title:\(webView.title)")
            //webNavigationItem.title = webView.title
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webView did finish navigation")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Log("viewWillDisappear")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Log("viewWillAppear")
        unionid = getCacheUnionid()
        if (unionid == nil || unionid! == ""){
            hideViews()
            let alertView = UIAlertController(title:"未登录", message:"前往登录", preferredStyle:.alert)
            let cancel = UIAlertAction(title:"取消", style:.cancel)
            let confirm = UIAlertAction(title:"确定", style:.default){
                action in
                //self.performSegue(withIdentifier: "showMe", sender: self)
                self.tabBarController?.tabBar.isHidden = false
                self.tabBarController?.selectedIndex = 3
            }
            alertView.addAction(cancel)
            alertView.addAction(confirm)
            present(alertView,animated: true,completion: nil)
        } else {
            //loadUrl(url: "http://yan.eeseetech.cn/mobile/wechat/shop?sid=a4b2b3d03a082353954a2d3db28c4d05")
            showViews()
            //Presenter.getShopUrl(unionid: "o6mWl1a58jqGX_TAT6tpd2zpJ2lI")
//            Presenter.getShopUrl(unionid: unionid!)
//                .observeOn(MainScheduler.instance)
//                .subscribe(onNext:{
//                    url in
//                    self.loadUrl(url: url)
//                })
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
    func hideViews(){
        segmentedControl.isHidden = true
        backButton.isEnabled = false
        fullScreenButton.isEnabled = false
    }
    
    func showViews(){
        segmentedControl.isHidden = false
        backButton.isEnabled = true
        fullScreenButton.isEnabled = true
    }
}


