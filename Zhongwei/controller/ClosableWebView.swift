//
//  ClosableWebView.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/9.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
class ClosableWebView:WebViewController{
    
    var closeButton:UIBarButtonItem!
    var app:AppDelegate!
    var url:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        app = UIApplication.shared.delegate as! AppDelegate
        closeButton = UIBarButtonItem(title:"", style:.plain, target:self, action:#selector(close))
        closeButton.image = UIImage(named:"closeButton")
        closeButton.tintColor = UIColor.black
        webNavigationItem.setRightBarButton(closeButton, animated: true)
        //loadUrl(url: "http://yan.eeseetech.cn/mobile/wechat/caipiao/")
        //app.globalData?.baseUrl
        Log("url:\(url)")
        //startLoad(url:url!)
    }
    
    @objc func close(_ sender:UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
}
