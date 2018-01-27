//
//  WeiChatLogin.swift
//  Zhongwei
//
//  Created by eesee on 2017/12/27.
//  Copyright © 2017年 zhongwei. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Kingfisher

class WeiChatLogin:UIViewController {
    
    var isLogin:Bool = false
    var unionid:String?
    var app:AppDelegate?
    
    override func viewDidLoad() {
        app = UIApplication.shared.delegate as! AppDelegate
        var unionid:String? = getCacheUnionid()
        app!.globalData!.unionid = unionid
        if (unionid != nil && unionid! != ""){
            self.performSegue(withIdentifier: "showMe", sender: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Log("viewDidAppear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Log("viewDidDisappear")
    }
    
    override func viewWillAppear(_ animated: Bool) {
       Log("viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Log("viewWillDisappear")
    }
    
    @IBAction func login(_ sender: Any?) {
        unionid = getCacheUnionid()
        if (unionid == nil || unionid! == ""){
            var wechatUrl:URL! = URL(string:"weixin://")
            if(UIApplication.shared.canOpenURL(wechatUrl)){
                print("login button click")
                let req = SendAuthReq()
                req.scope = "snsapi_userinfo"
                req.state = "default_state"
                print(WXApi.send(req))
            }else {
                print("未安装微信")
            }
            //self.performSegue(withIdentifier: "showMe", sender: nil)
        } else {
            print("unionid not nil : \(unionid)")
            self.performSegue(withIdentifier: "showMe", sender: nil)
//            Presenter.getUrl(unionid:unionid!)
//                .observeOn(MainScheduler.instance)
//                .subscribe(onNext:{url in
//                    print("url: \(url)")
//                    self.shopUrl = url
//                    self.performSegue(withIdentifier: "shopPage", sender: nil)
//                })
        }
        
    }
    
    
    
    @IBAction func changeUser(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.set("", forKey: "unionid")
        userDefaults.synchronize()
        login(nil)
        
    }
    
    
    @IBAction func share(_ sender: UIButton) {
        print("share button click")
        let req = SendMessageToWXReq()
        req.bText = true
        req.text = "hello world"
        req.scene = Int32(WXSceneSession.rawValue)
        WXApi.send(req)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.identifier ?? "" {
        case "shopPage":
            break;
        default:
            break;
        }
    }
    
    @IBAction func unwindToLogin(sender:UIStoryboardSegue) {
        Log("unwind")
    }
    
}
