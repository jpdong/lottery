//
//  NewsViewController.swift
//  Zhongwei
//
//  Created by eesee on 2018/1/24.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import Reachability

class NewsViewController:WebViewController{
    
    @IBOutlet weak var reLoadButton: UILabel!
    var app:AppDelegate?
    
    override func viewDidLoad() {
        app = UIApplication.shared.delegate as! AppDelegate
        self.shopUrl = "\(app!.globalData!.baseUrl)mobile/wechat/news/"
        print("news url : \(self.shopUrl!)")
        super.viewDidLoad()
        reLoadButton.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(reload)))
    }
    
    func _hasNetwork() -> Bool{
        let reachability = Reachability()
        print("reachablity:\(reachability)")
        print("connection:\(reachability!.connection)")
        if (reachability?.connection == .wifi || reachability?.connection == .cellular) {
            Log("has net work")
            return false
        } else {
            Log("no net work")
            return false
        }
    }
    
//    func load(){
//        if(hasNetwork()) {
//            Log("should load url")
//            loadUrl(url: shopUrl!)
//        } else {
//            Log("should alert")
//            let alertView = UIAlertController(title:"无网络连接", message:"请检查网络", preferredStyle:.alert)
//            let cancel = UIAlertAction(title:"取消", style:.cancel)
//            let confirm = UIAlertAction(title:"重试", style:.default){
//                action in
//                self.load()
//            }
//            alertView.addAction(cancel)
//            alertView.addAction(confirm)
//            present(alertView,animated: true,completion: nil)
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        Log("")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startLoad(url:shopUrl!)
    }
    
    @objc func reload() {
        loadUrl(url: "http://yan.eeseetech.cn/mobile/wechat/news/")
    }
}
