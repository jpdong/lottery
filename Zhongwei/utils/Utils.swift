//
//  Utils.swift
//  HelloWorld
//
//  Created by eesee on 2017/12/21.
//  Copyright © 2017年 eesee. All rights reserved.
//

import Foundation
import Reachability

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

extension Data {
    func toString() -> String {
        return String(data: self, encoding: String.Encoding.utf8) ?? ""
    }
}

extension String {
    func pregReplace(pattern: String, with: String,
                     options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [],
                                              range: NSMakeRange(0, self.count),
                                              withTemplate: with)
    }
    
    func subString(start:Int, length:Int = -1) -> String {
        var len = length
        if len == -1 {
            len = self.count - start
        }
        let st = self.index(startIndex, offsetBy:start)
        let en = self.index(st, offsetBy:len)
        return String(self[st ..< en])
    }
}

extension UIView {
    
    private func drawBorder(rect:CGRect,color:UIColor){
        let line = UIBezierPath(rect: rect)
        let lineShape = CAShapeLayer()
        lineShape.path = line.cgPath
        lineShape.fillColor = color.cgColor
        self.layer.addSublayer(lineShape)
    }
    
    public func bottomBorder(width:CGFloat,borderColor:UIColor){
        let rect = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.width, height: width)
        drawBorder(rect: rect, color: borderColor)
    }
    
    public func topBorder(width:CGFloat,borderColor:UIColor){
        let rect = CGRect(x: 0, y: 0, width: self.frame.width, height: width)
        drawBorder(rect: rect, color: borderColor)
    }
    
    
    public func leftBorder(width:CGFloat,borderColor:UIColor){
        let rect = CGRect(x: 0, y: 0, width: width, height: self.frame.height)
        drawBorder(rect: rect, color: borderColor)
    }
    
    public func rightBorder(width:CGFloat,borderColor:UIColor){
        let rect = CGRect(x: self.frame.width, y: 0, width: width, height: self.frame.height)
        drawBorder(rect: rect, color: borderColor)
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

func getCacheTobaccoCardImageUrl() -> String {
    let userDefaults = UserDefaults.standard
    let tobaccoUrl:String? = userDefaults.string(forKey: "tobacco_idcard_url")
    return tobaccoUrl ?? ""
}

func getCacheBusinessCardImageUrl() -> String {
    let userDefaults = UserDefaults.standard
    let businessUrl:String? = userDefaults.string(forKey: "business_idcard_url")
    return businessUrl ?? ""
}

func storeTobaccoCardImageUrl(cardUrl:String) {
    let userDefaults = UserDefaults.standard
    userDefaults.set(cardUrl, forKey: "tobacco_idcard_url")
    userDefaults.synchronize()
}

func storeBusinessCardImageUrl(cardUrl:String) {
    let userDefaults = UserDefaults.standard
    userDefaults.set(cardUrl, forKey: "business_idcard_url")
    userDefaults.synchronize()
}

func storeIDCardImageUrl(front:String, back:String) {
    let userDefaults = UserDefaults.standard
    userDefaults.set(front, forKey: "front_idcard_url")
    userDefaults.set(back, forKey:"back_idcard_url")
    userDefaults.synchronize()
}

func storeSigningShopId(shopId:String) {
    let userDefaults = UserDefaults.standard
    userDefaults.set(shopId, forKey: "signing_shopId")
    userDefaults.synchronize()
}

func getSigningShopId() -> String{
    let userDefaults = UserDefaults.standard
    let shopId:String? = userDefaults.string(forKey: "signing_shopId")
    return shopId ?? ""
}

func storeSignTime(_ time:String) {
    let userDefaults = UserDefaults.standard
    userDefaults.set(time, forKey: "signing_time")
    userDefaults.synchronize()
}

func getSigningTime() -> String{
    let userDefaults = UserDefaults.standard
    let time:String? = userDefaults.string(forKey: "signing_time")
    return time ?? ""
}


func alert(viewController:UIViewController,title:String, message:String) {
    let alertView = UIAlertController(title:title, message:message, preferredStyle:.alert)
    let cancel = UIAlertAction(title:"确定", style:.cancel)
    alertView.addAction(cancel)
    viewController.present(alertView,animated: true,completion: nil)
}

func hasNetwork() -> Bool{
    let reachability = Reachability()
    if (reachability?.connection != .none) {
        return true
    } else {
        return false
    }
}

func setupCustomerServiceInfo(_ phoneNum:String) {
    let userInfo = QYUserInfo()
    userInfo.userId = phoneNum
    var array = Array<Dictionary<String,Any>>()
    var nameDictionary = Dictionary<String,String>()
    nameDictionary.updateValue("real_name", forKey: "key")
    nameDictionary.updateValue(phoneNum, forKey: "value")
    array.append(nameDictionary)
    var phoneDictionary = Dictionary<String,Any>()
    phoneDictionary.updateValue("mobile_phone", forKey: "key")
    phoneDictionary.updateValue(phoneNum, forKey: "value")
    phoneDictionary.updateValue(false, forKey: "hidden")
    array.append(phoneDictionary)
    if let data = try? JSONSerialization.data(withJSONObject: array, options: []) {
        userInfo.data = String(data:data,encoding:String.Encoding.utf8)
        QYSDK.shared().setUserInfo(userInfo)
        print("customer service info:\(userInfo.data!)")
    }
}
