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
        return Observable<MessageResult>.create { observer -> Disposable in
            UserAPIProvicer.request(.notifications, completion: { (response) in
                var result:MessageResult = MessageResult()
                switch response {
                case .success(let value):
                    guard let messageEntity:MessageEntity = MessageEntity.deserialize(from: value.data.toString()) as? MessageEntity else {
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
            })
                    return Disposables.create()
                }
            
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    func sendVerificationCode(phone:String) -> Observable<Result>{
        return Observable<Result>.create({ (observer) -> Disposable in
            UserAPIProvicer.request(.sendSMSCode(phone:phone), completion: { (response) in
                var result:Result = Result()
                switch response {
                case .success(let value):
                    guard let codeEntity:CodeEntity = CodeEntity.deserialize(from: value.data.toString()) as? CodeEntity else {
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
            })
            return Disposables.create()
        })
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    func phoneNumRegister(phone:String, password:String, code:String) -> Observable<Result> {
        return Observable<Result>.create({ (observer) -> Disposable in
            UserAPIProvicer.request(.register(phone:phone,password:password,code:code), completion: { (response) in
                var result:Result = Result()
                switch response {
                case .success(let value):
                    guard let sidEntity = SidEntity.deserialize(from:value.data.toString()) as? SidEntity else {
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
            })
            return Disposables.create()
        })
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    func passwordLogin(phone:String, password:String) -> Observable<Result> {
        return Observable<Result>.create({ (observer) -> Disposable in
            UserAPIProvicer.request(.passwordLogin(phone:phone,password:password), completion: { (response) in
                var result:Result = Result()
                switch response {
                case .success(let value):
                    guard let sidEntity = SidEntity.deserialize(from:value.data.toString()) as? SidEntity else {
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
            })
            return Disposables.create()
        })
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    func codeLogin(phone:String, code:String) -> Observable<Result> {
        return Observable<Result>.create({ (observer) -> Disposable in
            UserAPIProvicer.request(.smsLogin(phone:phone,code:code), completion: { (response) in
                var result:Result = Result()
                switch response {
                case .success(let value):
                    guard let sidEntity = SidEntity.deserialize(from:value.data.toString()) as? SidEntity else {
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
            })
            return Disposables.create()
        })
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
        
    }
}
