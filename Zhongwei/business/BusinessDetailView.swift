//
//  BusinessDetailView.swift
//  Zhongwei
//
//  Created by eesee on 2018/1/30.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import WebKit
import RxSwift
import Toaster

class BusinessDetailView: UIViewController,WKUIDelegate,WKNavigationDelegate {
    
    var backButton: UIBarButtonItem!
    var closeButton:UIBarButtonItem!
    //var progressView: UIProgressView!
    var navigationBar:UINavigationBar!
    var webView:WKWebView!
    var webNavigationItem:UINavigationItem!
    var unionid:String?
    var type:Int?
    var app:AppDelegate?
    var headImgUrl:String?
    var nickName:String?
    var navigationBarHeight:CGFloat?
    var statusBarHeight:CGFloat?
    
    @objc func goBack(_ sender: UIBarButtonItem) {
        webView.goBack()
        webView.reload()
    }
    
    @objc func switchFullScreen(_ sender:UIBarButtonItem){
        if (self.tabBarController?.tabBar.isHidden == true) {
            self.tabBarController?.tabBar.isHidden = false
        } else {
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
    @objc func close(_ sender:UIBarButtonItem){
        if (type == BusinessItem.shop && (self.presentingViewController is IDCardViewController)) {
            var grandParentVC = self.presentingViewController?.presentingViewController
            grandParentVC?.dismiss(animated: true, completion: nil)
//            var parentVC:UIViewController? = self.presentingViewController
//            var bottomVC:UIViewController?
//            while(parentVC != nil) {
//                bottomVC = parentVC
//                parentVC = parentVC!.presentingViewController
//            }
//            bottomVC?.dismiss(animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        //
        
    }
    
    func goForward(_ sender: UIBarButtonItem) {
        webView.goForward()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        unionid = getCacheUnionid()
        app = UIApplication.shared.delegate as! AppDelegate
        headImgUrl = app?.globalData?.headImgUrl
        nickName = app?.globalData?.nickName
        setupViews()
    }
    
    func setupViews(){
        navigationBarHeight = Size.instance.navigationBarHeight
        statusBarHeight = Size.instance.statusBarHeight
        navigationBar = UINavigationBar(frame:CGRect( x:0,y:statusBarHeight!, width:self.view.frame.width, height:navigationBarHeight!))
        webNavigationItem = UINavigationItem()
        backButton = UIBarButtonItem(title:"",style:.plain, target:self, action:#selector(goBack))
        //backButton.image = UIImage(named:"backButton")
        closeButton = UIBarButtonItem(title:"", style:.plain, target:self, action:#selector(close))
        closeButton.image = UIImage(named:"closeButton")
        closeButton.tintColor = UIColor.black
        //backButton.image = UIImage(named:"back")
        webNavigationItem.setLeftBarButton(backButton, animated: true)
        webNavigationItem.setRightBarButton(closeButton, animated: true)
        
        navigationBar?.pushItem(webNavigationItem, animated: true)
        self.view.addSubview(navigationBar!)
        //self.view.addSubview(segmentedControl)
        //progressView = UIProgressView(frame: CGRect(x:0, y:0, width:self.view.frame.width, height:4))
        //self.view.addSubview(progressView)
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: CGRect(x:0,y:navigationBarHeight! + statusBarHeight!, width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height - (navigationBarHeight! + statusBarHeight!)), configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath:"title", options:.new, context:nil)
        showDetail()
    }
    
    func showDetail(){
        Log("type:\(type)")
        switch type! {
        case BusinessItem.shop:
            //Presenter.getShopUrl(unionid: "o6mWl1a58jqGX_TAT6tpd2zpJ2lI")
            BusinessPresenter.getShopUrl(unionid: unionid!,headimgurl: headImgUrl!, nickname:nickName!)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext:{
                    url in
                    self.loadUrl(url: url)
                })
            break
        case BusinessItem.manager:
            //Presenter.getManagerUrl(unionid: "o6mWl1a58jqGX_TAT6tpd2zpJ2lI")
            BusinessPresenter.getManagerUrl(unionid: unionid!,headimgurl: headImgUrl!, nickname:nickName!)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext:{
                    url in
                    self.loadUrl(url: url)
                })
            break
        case BusinessItem.areaManager:
            //Presenter.getAreaManagerUrl(unionid: "o6mWl1a58jqGX_TAT6tpd2zpJ2lI")
            BusinessPresenter.getAreaManagerUrl(unionid: unionid!,headimgurl: headImgUrl!, nickname:nickName!)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext:{
                    url in
                    self.loadUrl(url: url)
                })
            break
        case BusinessItem.marketManager:
            //Presenter.getAreaManagerUrl(unionid: "o6mWl1a58jqGX_TAT6tpd2zpJ2lI")
            BusinessPresenter.getMarketManagerUrl(unionid: unionid!,headimgurl: headImgUrl!, nickname:nickName!)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext:{
                    url in
                    self.loadUrl(url: url)
                })
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
            //backButton.isEnabled = webView.canGoBack
            if (webView.canGoBack) {
                backButton.image = UIImage(named:"backButton")
            } else {
                backButton.image = nil
            }
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
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        Toast(text:message).show()
        completionHandler()
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: webView.title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) -> Void in
            completionHandler(false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Log("viewWillDisappear")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Log("viewWillAppear")
//        unionid = getCacheUnionid()
//        if (unionid == nil || unionid! == ""){
//            hideViews()
//            let alertView = UIAlertController(title:"未登录", message:"前往登录", preferredStyle:.alert)
//            let cancel = UIAlertAction(title:"取消", style:.cancel)
//            let confirm = UIAlertAction(title:"确定", style:.default){
//                action in
//                //self.performSegue(withIdentifier: "showMe", sender: self)
//                self.tabBarController?.tabBar.isHidden = false
//                self.tabBarController?.selectedIndex = 3
//            }
//            alertView.addAction(cancel)
//            alertView.addAction(confirm)
//            present(alertView,animated: true,completion: nil)
//        }
    }
    
    func hideViews(){
        //backButton.isEnabled = false
        closeButton.isEnabled = false
    }
    
    func showViews(){
        backButton.isEnabled = true
        closeButton.isEnabled = true
    }
}
