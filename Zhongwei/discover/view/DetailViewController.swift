//
//  DetailViewController.swift
//  Zhongwei
//
//  Created by eesee on 2018/1/25.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class DetailViewController:WebViewController{
    
    var closeButton:UIBarButtonItem!
    var app:AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate
        closeButton = UIBarButtonItem(title:"", style:.plain, target:self, action:#selector(close))
        closeButton.image = UIImage(named:"closeButton")
        webNavigationItem.setRightBarButton(closeButton, animated: true)
        //loadUrl(url: "http://yan.eeseetech.cn/mobile/wechat/caipiao/")
        //app.globalData?.baseUrl
        startLoad(url: "\(app.globalData!.baseUrl)mobile/wechat/caipiao/")
    }
    
    @objc func close(_ sender:UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
}
