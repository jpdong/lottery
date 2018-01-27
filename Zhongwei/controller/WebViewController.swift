//
//  ViewController.swift
//  Zhongwei
//
//  Created by eesee on 2017/12/19.
//  Copyright © 2017年 zhongwei. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController,WKUIDelegate,WKNavigationDelegate {
    
    var backButton: UIBarButtonItem!
    //var progressView: UIProgressView!
    var navigationBar:UINavigationBar!
    var webView:WKWebView!
    var webNavigationItem:UINavigationItem!
    var shopUrl:String?
    
    @objc func goBack(_ sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    func goForward(_ sender: UIBarButtonItem) {
        webView.goForward()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        navigationBar = UINavigationBar(frame:CGRect( x:0,y:20, width:self.view.frame.width, height:44))
        webNavigationItem = UINavigationItem()
        backButton = UIBarButtonItem(title:"后退",style:.plain, target:self, action:#selector(goBack))
        //backButton.image = UIImage(named:"back")
        backButton.title = "后退"
        webNavigationItem.setLeftBarButton(backButton, animated: true)
        navigationBar?.pushItem(webNavigationItem, animated: true)
        self.view.addSubview(navigationBar!)
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
        // Dispose of any resources that can be recreated.
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //print("key:\(keyPath)")
        if (keyPath == "loading") {
            //print("keyPath loading")
            backButton.isEnabled = webView.canGoBack
            //forwardButton.isEnabled = webView.canGoForward
        }
        if (keyPath == "estimatedProgress") {
//            print("progressView:\(progressView)")
//            print("webView:\(webView)")
            //print(webView.estimatedProgress)
            //progressView.isHidden = webView.estimatedProgress == 1
            //progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
        if (keyPath == "title") {
            //print("title:\(((WKWebView)object).title)")
            print("title:\(webView.title)")
            webNavigationItem.title = webView.title
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
        webView.reload()
    }
}

