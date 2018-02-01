//
//  AppDelegate.swift
//  Zhongwei
//
//  Created by eesee on 2017/12/19.
//  Copyright © 2017年 zhongwei. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import HandyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WXApiDelegate {

    var window: UIWindow?
    
    var wechatAppID = "wx97e268b8f22da698"
    var wechatAppSecret = "9904af864293deff123897d495fc3ca3"
    var tabViewController:UITabBarController?
    var globalData:GlobalData?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Bugly.start(withAppId:"98d4c1d3a8")
        print("application didFinsishLaunch")
        globalData = GlobalData()
        globalData?.unionid = getCacheUnionid()
        globalData?.headImgUrl = getCacheImgUrl()
        globalData?.nickName = getCacheName()
        WXApi.registerApp(wechatAppID)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print("application open url")
        print("resp \(url) \(options)")
        let urlKey:String = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String
        if (urlKey == "com.tencent.xin") {
            return WXApi.handleOpen(url, delegate: self)
        }
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Log("applicationDidEnterBackground")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Log("applicationDidBecomeActive")
    }
    
    
    func onReq(_ req: BaseReq!) {
        print("onReq")
    }
    
    func onResp(_ resp: BaseResp!) {
        print("onResp")
        let sendRes:SendAuthResp? = resp as? SendAuthResp
        print(resp)
        let queue = DispatchQueue(label:"wechatLoginQueue")
        queue.async {
            Log("async:\(Thread.current)")
            if let sd = sendRes{
                if sd.errCode == 0 {
                    guard sd.code != nil else {
                        return
                    }
                    self.requestAccessToken(sd.code)
                } else {
                    Log("授权失败")
                }
            }else{
                Log("sendRes wrong")
            }
        }
    }
    
    func requestAccessToken(_ code:String){
        print("requestAccessToken")
        let urlStr = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=\(self.wechatAppID)&secret=\(self.wechatAppSecret)&code=\(code)&grant_type=authorization_code"
        let url = URL(string:urlStr)
        do {
            let responseData = try Data.init(contentsOf: url!, options: Data.ReadingOptions.alwaysMapped)
            let dic = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, Any>
            guard dic != nil else {
                Log("授权异常")
                return
            }
            guard dic!["access_token"] != nil else {
                Log("access_token is nil")
                return
            }
            guard dic!["openid"] != nil else {
                Log("openid is nil")
                return
            }
            // 根据获取到的accessToken来请求用户信息
            self.requestUserInfo(dic!["access_token"]! as! String, openID: dic!["openid"]! as! String)
        } catch {
            DispatchQueue.main.async {
                // 获取授权信息异常
                Log("获取授权信息异常")
            }
        }
        
    }
    
    private func requestUserInfo(_ accessToken: String, openID: String) {
        print("requestUserInfo")
        let urlStr = "https://api.weixin.qq.com/sns/userinfo?access_token=\(accessToken)&openid=\(openID)"
        let url = URL(string: urlStr)
        do {
            let responseData = try Data.init(contentsOf: url!, options: Data.ReadingOptions.alwaysMapped)
            let dic = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, Any>
            guard dic != nil else {
                Log("获取授权信息异常")
                return
            }
            print("dic:\(dic)")
            let unionid:String! = String(describing:dic!["unionid"] as! String)
            let headImgUrl:String! = String(describing:dic!["headimgurl"] as! String)
            let nickName:String! = String(describing:dic!["nickname"] as! String)
            globalData?.unionid = unionid
            globalData?.headImgUrl = headImgUrl
            globalData?.nickName = nickName
            storeUnionid(unionid)
            storeHeadImgUrl(headImgUrl)
            storeNickName(nickName)
            
            DispatchQueue.main.async {
                for index in 0...3{
                    print("child:\(self.tabViewController!.childViewControllers[index])")
                }
                var nav = self.tabViewController!.childViewControllers[3]
                var logView = nav.childViewControllers[1] as! WeiChatLogin
                //logView.dismiss(animated: true, completion: nil)
                logView.refresh()
                //logView.removeFromParentViewController()
                
            }
        } catch {
            Log("获取授权信息异常")
        }
    }
    
    class GlobalData{
        var unionid:String?
        var headImgUrl:String?
        var nickName:String?
    }
}

