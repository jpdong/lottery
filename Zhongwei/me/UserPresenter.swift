//
//  UserPresenter.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/5.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON
import Alamofire

class UserPresenter {
    static let app = UIApplication.shared.delegate as! AppDelegate
    static let BASE_URL = app.globalData!.baseUrl
    
    static func updateMessages() -> Observable<MessageResult> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<MessageResult>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)mobile/msgtip/get_audit_msgtip",method:.post,parameters:parameters).responseString{response in
                        print("response:\(response)")
                        print("result:\(response.result)")
                        print("value: \(response.result.value)")
                        if (response.result.value == nil) {
                            return
                        }
                        let messageEntity:MessageEntity = MessageEntity.deserialize(from: response.result.value as! String) as! MessageEntity
                        var result:MessageResult = MessageResult()
                        if (messageEntity.code == 0) {
                            result.code = 0
                            result.message = messageEntity.msg
                            result.messageList = messageEntity.data
                        }else {
                            result.code = 1
                            result.message = messageEntity.msg
                        }
                        observer.onNext(result)
                    }
                    return Disposables.create()
                }
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
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
                        //                        app.globalData?.sid = sidEntity!.data!.sid!
                        //                        storeSid(sidEntity!.data!.sid!)
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
