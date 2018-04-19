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
import Toaster

class UserPresenter:Presenter {
    
    func updateMessages() -> Observable<MessageResult> {
        return getSid()
            .flatMap{
                sid in
                return Observable<MessageResult>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(self.baseUrl)mobile/msgtip/get_audit_msgtip",method:.post,parameters:parameters).responseString{response in
                        print("response:\(response)")
                        print("result:\(response.result)")
                        print("value: \(response.result.value)")
                        
                        var result:MessageResult = MessageResult()
                        switch response.result {
                        case .success:
                            guard let messageEntity:MessageEntity = MessageEntity.deserialize(from: response.result.value as! String) as? MessageEntity else {
                                result.code = 1
                                result.message = "服务器错误"
                                observer.onNext(result)
                                return
                            }
                            
                            if (messageEntity.code == 0) {
                                result.code = 0
                                result.message = messageEntity.msg
                                result.messageList = messageEntity.data
                            }else {
                                result.code = 1
                                result.message = messageEntity.msg
                            }
                        case .failure(let error):
                            result.code = 1
                            result.message = "网络错误"
                        }
                        
                        observer.onNext(result)
                        observer.onCompleted()
                    }
                    return Disposables.create()
                }
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    func sendVerificationCode(phone:String) -> Observable<Result>{
        return Observable<Result>.create({ (observer) -> Disposable in
            let parameters:Dictionary = ["mobile":phone]
            print("parameters:\(parameters)")
            Alamofire.request("\(self.baseUrl)mobile/wechat/ajaxSend",method:.post,parameters:parameters).responseString{response in
                print("response:\(response)")
                print("result:\(response.result)")
                print("value: \(response.result.value)")
                var result:Result = Result()
                switch response.result {
                case .success:
                    guard let codeEntity:CodeEntity = CodeEntity.deserialize(from: response.result.value as! String) as? CodeEntity else {
                        result.code = 1
                        result.message = "服务器错误"
                        observer.onNext(result)
                        return
                    }
                    
                    if (codeEntity.success!) {
                        result.code = 0
                        result.message = "验证码发送成功"
                    }else {
                        result.code = 1
                        result.message = codeEntity.error
                    }
                case .failure(let error):
                    result.code = 1
                    result.message = "网络错误"
                }
                
                observer.onNext(result)
                observer.onCompleted()
            }
            return Disposables.create()
        })
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    func phoneNumRegister(phone:String, password:String, code:String) -> Observable<Result> {
        return Observable<Result>.create({ (observer) -> Disposable in
            let parameters:Dictionary = ["phone":phone, "password":password, "password2":password, "code":code]
            print("parameters:\(parameters)")
            Alamofire.request("\(self.baseUrl)mobile/Register/appUserRegister/",method:.post,parameters:parameters).responseString{
                response in
                print("response:\(response)")
                print("value \(response.result.value)")
                
                var result:Result = Result()
                switch response.result {
                case .success:
                    guard let sidEntity = SidEntity.deserialize(from:response.result.value as! String) as? SidEntity else {
                        result.code = 1
                        result.message = "服务器错误"
                        observer.onNext(result)
                        return
                    }
                    
                    
                    if (sidEntity.code == 0) {
                        result.code = 0
                        result.message = sidEntity.msg
                        //                        app.globalData?.sid = sidEntity!.data!.sid!
                        //                        storeSid(sidEntity!.data!.sid!)
                    } else {
                        result.code = 1
                        result.message = sidEntity.msg
                    }
                case .failure(let error):
                    result.code = 1
                    result.message = "网络错误"
                }
                
                
                observer.onNext(result)
                observer.onCompleted()
            }
            return Disposables.create()
        })
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    func passwordLogin(phone:String, password:String) -> Observable<Result> {
        return Observable<Result>.create({ (observer) -> Disposable in
            let parameters:Dictionary = ["phone":phone, "password":password]
            print("parameters:\(parameters)")
            Alamofire.request("\(self.baseUrl)mobile/Login/doLogin",method:.post,parameters:parameters).responseString{
                response in
                print("response:\(response)")
                print("value \(response.result.value)")
                var result:Result = Result()
                switch response.result {
                case .success:
                    guard let sidEntity = SidEntity.deserialize(from:response.result.value as! String) as? SidEntity else {
                        result.code = 1
                        result.message = "服务器错误"
                        observer.onNext(result)
                        return
                    }
                    if (sidEntity.code == 0) {
                        result.code = 0
                        result.message = sidEntity.msg
                        self.app.globalData?.sid = sidEntity.data!.sid!
                        storeSid(sidEntity.data!.sid!)
                    } else {
                        result.code = 1
                        result.message = sidEntity.msg
                    }
                case .failure(let error):
                    result.code = 1
                    result.message = "网络错误"
                }
                
                observer.onNext(result)
                observer.onCompleted()
            }
            return Disposables.create()
        })
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    func codeLogin(phone:String, code:String) -> Observable<Result> {
        return Observable<Result>.create({ (observer) -> Disposable in
            
            let parameters:Dictionary = ["phone":phone, "code":code]
            print("parameters:\(parameters)")
            Alamofire.request("\(self.baseUrl)mobile/Login/doLoginByCode",method:.post,parameters:parameters).responseString{
                response in
                print("response:\(response)")
                print("value \(response.result.value)")
                var result:Result = Result()
                switch response.result {
                case .success:
                    guard let sidEntity = SidEntity.deserialize(from:response.result.value as! String) as? SidEntity else {
                        result.code = 1
                        result.message = "服务器错误"
                        observer.onNext(result)
                        return
                    }
                    
                    if (sidEntity.code == 0) {
                        result.code = 0
                        result.message = sidEntity.msg
                        self.app.globalData?.sid = sidEntity.data!.sid!
                        storeSid(sidEntity.data!.sid!)
                    } else {
                        result.code = 1
                        result.message = sidEntity.msg
                    }
                case .failure(let error):
                    result.code = 1
                    result.message = "网络错误"
                }
                observer.onNext(result)
                observer.onCompleted()
            }
            return Disposables.create()
        })
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
        
    }
}
