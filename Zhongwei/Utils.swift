//
//  Utils.swift
//  HelloWorld
//
//  Created by eesee on 2017/12/21.
//  Copyright © 2017年 eesee. All rights reserved.
//

import Foundation
import UIKit

class Size {
    static let instance = Size()
   var windowWidth:CGFloat
    var windowHeight:CGFloat
    var isiPhoneX:Bool
     var navigationBarHeight:CGFloat
    var statusBarHeight:CGFloat
    var tabBarHeight:CGFloat
    
    private init(){
        windowWidth = UIScreen.main.bounds.size.width
        windowHeight = UIScreen.main.bounds.size.height
        isiPhoneX = windowHeight == 812 ? true : false
        navigationBarHeight = isiPhoneX ? 44 : 44
        statusBarHeight = isiPhoneX ? 44 : 20
        tabBarHeight = isiPhoneX ? 83 : 49
    }
    
}

func Log<T>(_ message:T, file:String = #file, funcName:String = #function,lineNum:Int = #line){
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
        print("Line:\(lineNum) \(fileName)/\(funcName)/\(message)")
    #endif
}

func storePhoneNum(_ phoneNum:String) {
    let userDefaults = UserDefaults.standard
    userDefaults.set(phoneNum, forKey: "phoneNum")
    userDefaults.synchronize()
}

func getCachePhoneNum ()-> String? {
    let userDefaults = UserDefaults.standard
    let phoneNum:String? = userDefaults.string(forKey: "phoneNum")
    return phoneNum ?? ""
}

func storeSid(_ sid:String) {
    let userDefaults = UserDefaults.standard
    userDefaults.set(sid, forKey:"sid")
    userDefaults.synchronize()
}

func getCacheSid () -> String? {
    let userDefaults = UserDefaults.standard
    let sid:String? = userDefaults.string(forKey: "sid")
    return sid ?? ""
}

func storeUnionid(_ unionid:String){
    let userDefaults = UserDefaults.standard
    userDefaults.set(unionid, forKey: "unionid")
    userDefaults.synchronize()
}

func getCacheUnionid() -> String?{
    let userDefaults = UserDefaults.standard
    let unionid:String? = userDefaults.string(forKey: "unionid")
    return unionid ?? ""
}

func storeHeadImgUrl(_ imgUrl:String){
    let userDefaults = UserDefaults.standard
    userDefaults.set(imgUrl, forKey: "headimgurl")
    userDefaults.synchronize()
}

func storeNickName(_ nickName:String){
    let userDefaults = UserDefaults.standard
    userDefaults.set(nickName, forKey: "nickname")
    userDefaults.synchronize()
}

func getCacheImgUrl() -> String?{
    let userDefaults = UserDefaults.standard
    let imgUrl:String? = userDefaults.string(forKey: "headimgurl")
    return imgUrl ?? ""
}

func getCacheName() -> String?{
    let userDefaults = UserDefaults.standard
    let nickName:String? = userDefaults.string(forKey: "nickname")
    return nickName ?? ""
}

func getCacheFrontIDCardImageUrl() ->String {
    let userDefaults = UserDefaults.standard
    let frontUrl:String? = userDefaults.string(forKey: "front_idcard_url")
    return frontUrl ?? ""
}

func getCacheBackIDCardImageUrl() -> String {
    let userDefaults = UserDefaults.standard
    let backUrl:String? = userDefaults.string(forKey: "back_idcard_url")
    return backUrl ?? ""
}

func storeIDCardImageUrl(front:String, back:String) {
    let userDefaults = UserDefaults.standard
    userDefaults.set(front, forKey: "front_idcard_url")
    userDefaults.set(back, forKey:"back_idcard_url")
    userDefaults.synchronize()
}


func alert(viewController:UIViewController,title:String, message:String) {
    let alertView = UIAlertController(title:title, message:message, preferredStyle:.alert)
    let cancel = UIAlertAction(title:"确定", style:.cancel)
    alertView.addAction(cancel)
    viewController.present(alertView,animated: true,completion: nil)
}
