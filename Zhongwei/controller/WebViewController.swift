//
//  ViewController.swift
//  Zhongwei
//
//  Created by eesee on 2017/12/19.
//  Copyright © 2017年 zhongwei. All rights reserved.
//

import UIKit
import WebKit
import Reachability

class WebViewController: UIViewController,WKUIDelegate,WKNavigationDelegate {
    
    var backButton: UIBarButtonItem!
    //var progressView: UIProgressView!
    var navigationBar:UINavigationBar!
    var webView:WKWebView!
    var webNavigationItem:UINavigationItem!
    var shopUrl:String?
    var navigationBarHeight:CGFloat?
    var statusBarHeight:CGFloat?
    
    @objc func goBack(_ sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    func goForward(_ sender: UIBarButtonItem) {
        webView.goForward()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        navigationBarHeight = Size.instance.navigationBarHeight
        statusBarHeight = Size.instance.statusBarHeight
        navigationBar = UINavigationBar(frame:CGRect( x:0,y:Size.instance.statusBarHeight, width:self.view.frame.width, height:Size.instance.navigationBarHeight))
        webNavigationItem = UINavigationItem()
        backButton = UIBarButtonItem(title:"",style:.plain, target:self, action:#selector(goBack))
        backButton.image = UIImage(named:"backButton")
        webNavigationItem.setLeftBarButton(backButton, animated: true)
        navigationBar?.pushItem(webNavigationItem, animated: true)
        self.view.addSubview(navigationBar!)
        //progressView = UIProgressView(frame: CGRect(x:0, y:0, width:self.view.frame.width, height:4))
        //self.view.addSubview(progressView)
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: CGRect(x:0,y:navigationBarHeight! + statusBarHeight!, width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height - navigationBarHeight! - statusBarHeight!), configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        //backButton.isEnabled = false
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath:"title", options:.new, context:nil)
        //loadUrl(url: shopUrl!)
        
    }
    
    func loadUrl(url:String){
        if (url != nil){
            let myUrl = URL(string:url)
            let myRequest = URLRequest(url:myUrl!)
            webView.load(myRequest)
        } else {
            print("shopUrl is nil")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "loading") {
            if (webView.canGoBack) {
                backButton.image = UIImage(named:"backButton")
            } else {
                backButton.image = nil
            }
        }
        if (keyPath == "estimatedProgress") {
        }
        if (keyPath == "title") {
            print("title:\(webView.title)")
            webNavigationItem.title = webView.title
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webView did finish navigation")
    }
    
    func startLoad(url:String) {
        if(hasNetwork()) {
            Log("should load url")
            loadUrl(url: url)
        } else {
            Log("should alert")
            let alertView = UIAlertController(title:"无网络连接", message:"请检查网络", preferredStyle:.alert)
            let cancel = UIAlertAction(title:"取消", style:.cancel)
            let confirm = UIAlertAction(title:"重试", style:.default){
                action in
                self.startLoad(url:url)
            }
            alertView.addAction(cancel)
            alertView.addAction(confirm)
            present(alertView,animated: true,completion: nil)
        }
    }
    
    func hasNetwork() -> Bool{
        let reachability = Reachability()
        if (reachability?.connection != .none) {
            return true
        } else {
            return false
        }
    }
}

