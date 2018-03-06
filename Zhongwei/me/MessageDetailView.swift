//
//  MessageDetailView.swift
//  Zhongwei
//
//  Created by eesee on 2018/1/31.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class MessageDetailView:WebViewController{
    
    var closeButton:UIBarButtonItem!
    var app:AppDelegate!
    var messageDetailUrl:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate
        closeButton = UIBarButtonItem(title:"", style:.plain, target:self, action:#selector(close))
        closeButton.image = UIImage(named:"closeButton")
        webNavigationItem.setRightBarButton(closeButton, animated: true)
        //loadUrl(url: "http://yan.eeseetech.cn/mobile/wechat/caipiao/")
        //app.globalData?.baseUrl
        print("message url:\(messageDetailUrl)")
        startLoad(url: messageDetailUrl!)
    }
    
    @objc func close(_ sender:UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
}

