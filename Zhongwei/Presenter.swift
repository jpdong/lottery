//
//  Presenter.swift
//  Zhongwei
//
//  Created by eesee on 2018/1/17.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

enum ApiError:Error {
    case NoSidError
    case NoResponseError
}

class Presenter{
    
    static let app = UIApplication.shared.delegate as! AppDelegate
    static let BASE_URL = app.globalData!.baseUrl
    
    static func getSid(unionid:String,headimgurl:String, nickname:String)  -> Observable<String>{
        return Observable<String>.create {
            (observer) -> Disposable in
            let parameters:Dictionary = ["unionid":unionid,"headimgurl":headimgurl, "nickname":nickname]
            Alamofire.request("\(BASE_URL)mobile/app/getSid",method:.post,parameters:parameters).responseString{response in
                print("value \(response.result.value)")
                if (response.result.value == nil) {
                    observer.onError(ApiError.NoResponseError)
                    return
                }
                if let sidEntity = SidEntity.deserialize(from:response.result.value!){
                    if (sidEntity != nil && sidEntity.data?.sid != nil) {
                        print("sid \(sidEntity.data!.sid!)")
                        observer.onNext(sidEntity.data!.sid!)
                    }else {
                        observer.onError(ApiError.NoSidError)
                    }
                    
                }
                
            }
            return Disposables.create ()
        }
    }
    
    static func getUrl(unionid:String,headimgurl:String, nickname:String,urlHead:String) -> Observable<String>{
        print("urlHead:\(urlHead)")
//        return Observable<String>.create {
//            (observer) -> Disposable in
//            let parameters:Dictionary = ["unionid":unionid,"headimgurl":headimgurl, "nickname":nickname]
//            Alamofire.request("\(BASE_URL)mobile/wechat/getSid",method:.post,parameters:parameters).responseString{response in
//                print("value \(response.result.value)")
//                if (response.result.value == nil) {
//                    return
//                }
//                if let sidEntity = SidEntity.deserialize(from:response.result.value!){
//                    print("sid \(sidEntity.data!.sid!)")
//                    observer.onNext(sidEntity.data!.sid!)
//                }
//
//            }
//            return Disposables.create ()
//            }
            return getSid(unionid: unionid, headimgurl: headimgurl, nickname: nickname)
            .map{
                sid in
                Log("url:\(urlHead)\(sid)")
                return "\(urlHead)\(sid)"
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    static func getShopUrl(unionid:String,headimgurl:String, nickname:String) -> Observable<String>{
        return getUrl(unionid:unionid,headimgurl: headimgurl, nickname: nickname, urlHead:"\(BASE_URL)mobile/app/shop?sid=")
    }
    
    static func getManagerUrl(unionid:String,headimgurl:String, nickname:String) -> Observable<String>{
        return getUrl(unionid:unionid, headimgurl: headimgurl, nickname: nickname,urlHead:"\(BASE_URL)mobile/app/manager?sid=")
    }
    
    static func getAreaManagerUrl(unionid:String,headimgurl:String, nickname:String) -> Observable<String>{
        return getUrl(unionid:unionid, headimgurl: headimgurl, nickname: nickname,urlHead:"\(BASE_URL)mobile/app/bazaar_manager?sid=")
    }
    
    static func getMarketManagerUrl(unionid:String,headimgurl:String, nickname:String) -> Observable<String>{
        return getUrl(unionid:unionid, headimgurl: headimgurl, nickname: nickname,urlHead:"\(BASE_URL)mobile/app/area_manager?sid=")
    }
    
    static func getPrizeRecordUrl() -> Observable<String>{
        var unionid = app.globalData!.unionid
        var headImgUrl = app.globalData!.headImgUrl
        var nickName = app.globalData!.nickName
        return getSid(unionid: unionid, headimgurl: headImgUrl, nickname: nickName)
            .map{ sid in
                let now = Date()
                let timeInterval:TimeInterval = now.timeIntervalSince1970 * 1000
                let timeStamp = Int(timeInterval)
                return "\(BASE_URL)resources/app/scan-qr-code/redeem-record.html?\(timeStamp)=&sid=\(sid)"
                }
    }
    
    
    static func getPrizeData(code:String)  -> Observable<AlertData>{
        var unionid = app.globalData!.unionid
        var headImgUrl = app.globalData!.headImgUrl
        var nickName = app.globalData!.nickName
        return getSid(unionid: unionid, headimgurl: headImgUrl, nickname: nickName)
            .flatMap{
                sid in
                return Observable<AlertData>.create {
                    observer -> Disposable in
                    var result = "a"
                    Alamofire.request("\(BASE_URL)mobile/Redeem/doRedeem?sid=\(sid)&code=\(code)").responseString{
                        response in
                        print("prize value \(response.result.value)")
                        if (response.result.value == nil) {
                            return
                        }
                        print("response.result.value : \(response.result.value as! String)")
                        var alertData = AlertData()
                        var message = ""
                        var title = ""
                        if let prizeEntity = PrizeEntity.deserialize(from: response.result.value as! String) {
                            print("prizeEntity:\(prizeEntity)")
                            if (prizeEntity.code != 200) {
                                title = prizeEntity.msg!
                            } else {
                                let dataString = prizeEntity.data as! String
                                print("dataString:\(dataString)")
                                if let prizeData = PrizeData.deserialize(from: dataString){
                                    if (prizeData.ret == "1307" || prizeData.ret == "1305") {
                                        title = prizeData.msg as! String
                                        var type = prizeData.content?.gameName as! String
                                        var time = getTimeStamp(timeString:prizeData.content?.transacId as! String)
                                        var ticketNo = prizeData.content?.ticketNo as! String
                                        message = "兑换票种：\(type)\n扫码时间：\(time)\n兑奖单号：\(ticketNo)"
                                    } else if (prizeData.ret == "1301") {
                                        title = "兑奖成功，奖金\(prizeData.content!.prize)元"
                                        var type = prizeData.content?.gameName as! String
                                        var time = getTimeStamp(timeString:prizeData.content?.transacId as! String)
                                        var ticketNo = prizeData.content?.ticketNo as! String
                                        message = "兑换票种：\(type)\n扫码时间：\(time)\n兑奖单号：\(ticketNo)"
                                    } else {
                                        title = prizeData.msg as! String
                                    }
                                }
                            }
                            alertData.title = title
                            alertData.message = message
                            print("result:\(result)")
                            //result = response.result.value!
                            observer.onNext(alertData)
                        }
                    }
                        return Disposables.create()
                    }
                    }
                    .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
        }
    
    
        static func getTimeStamp(timeString:String) -> String{
            return "\(subString(timeString, 0, 3))-\(subString(timeString, 4, 5))-\(subString(timeString, 6, 7)) \(subString(timeString, 8, 9)):\(subString(timeString, 10, 11)):\(subString(timeString, 12, 13))"
        }
        
        static func subString(_ str:String,_  start:Int,_ end:Int) -> String{
            let startIndex = str.startIndex
            return String(str[str.index(startIndex, offsetBy: start)...str.index(startIndex, offsetBy: end)])
        }
    
    static func sendVerificationCode(phone:String) -> Observable<Result>{
        return Observable<Result>.create({ (observer) -> Disposable in
            let parameters:Dictionary = ["mobile":phone]
            print("parameters:\(parameters)")
            Alamofire.request("\(BASE_URL)mobile/wechat/ajaxSend",method:.post,parameters:parameters).responseString{response in
                print("response:\(response)")
                print("result:\(response.result)")
                print("value: \(response.result.value)")
                if (response.result.value == nil) {
                    return
                }
                let codeEntity:CodeEntity = CodeEntity.deserialize(from: response.result.value as! String) as! CodeEntity
                var result:Result = Result()
                if (codeEntity.success!) {
                    result.code = 1
                    result.message = "验证码发送成功"
                }else {
                    result.code = 0
                    result.message = codeEntity.error
                }
                observer.onNext(result)
            }
            return Disposables.create()
        })
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    static func phoneNumRegister(phone:String, password:String, code:String) -> Observable<Result> {
        return Observable<Result>.create({ (observer) -> Disposable in
            let parameters:Dictionary = ["phone":phone, "password":password, "password2":password, "code":code]
            print("parameters:\(parameters)")
            Alamofire.request("\(BASE_URL)mobile/Register/appUserRegister/",method:.post,parameters:parameters).responseString{
                response in
                print("response:\(response)")
                print("value \(response.result.value)")
                if (response.result.value == nil) {
                    return
                }
                var sidEntity = SidEntity.deserialize(from:response.result.value as! String)
                var result:Result = Result()
                if (sidEntity != nil) {
                    if (sidEntity?.code == 0) {
                        result.code = 0
                        result.message = sidEntity?.msg
                        app.globalData?.sid = sidEntity!.data!.sid!
                        storeSid(sidEntity!.data!.sid!)
                    } else {
                        result.code = 1
                        result.message = sidEntity?.msg
                    }
                }
                observer.onNext(result)
            }
            return Disposables.create()
        })
        .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    static func passwordLogin(phone:String, password:String) -> Observable<Result> {
        return Observable<Result>.create({ (observer) -> Disposable in
            let parameters:Dictionary = ["phone":phone, "password":password]
            print("parameters:\(parameters)")
            Alamofire.request("\(BASE_URL)mobile/Login/doLogin",method:.post,parameters:parameters).responseString{
                response in
                print("response:\(response)")
                print("value \(response.result.value)")
                if (response.result.value == nil) {
                    return
                }
                var sidEntity = SidEntity.deserialize(from:response.result.value as! String)
                var result:Result = Result()
                if (sidEntity != nil) {
                    if (sidEntity?.code == 0) {
                        result.code = 0
                        result.message = sidEntity?.msg
                        app.globalData?.sid = sidEntity!.data!.sid!
                        storeSid(sidEntity!.data!.sid!)
                    } else {
                        result.code = 1
                        result.message = sidEntity?.msg
                    }
                }
                observer.onNext(result)
            }
            return Disposables.create()
        })
        .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    static func codeLogin(phone:String, code:String) -> Observable<Result> {
        return Observable<Result>.create({ (observer) -> Disposable in
            
            let parameters:Dictionary = ["phone":phone, "code":code]
            print("parameters:\(parameters)")
            Alamofire.request("\(BASE_URL)mobile/Login/doLoginByCode",method:.post,parameters:parameters).responseString{
                response in
                print("response:\(response)")
                print("value \(response.result.value)")
                if (response.result.value == nil) {
                    return
                }
                var sidEntity = SidEntity.deserialize(from:response.result.value as! String)
                var result:Result = Result()
                if (sidEntity != nil) {
                    if (sidEntity?.code == 0) {
                        result.code = 0
                        result.message = sidEntity?.msg
                        app.globalData?.sid = sidEntity!.data!.sid!
                        storeSid(sidEntity!.data!.sid!)
                    } else {
                        result.code = 1
                        result.message = sidEntity?.msg
                    }
                }
                observer.onNext(result)
            }
            return Disposables.create()
        })
        .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
        
    }
}
