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
    
    static func getSid() -> Observable<String> {
        return Observable<String>.create({ (observer) -> Disposable in
            let sid = app.globalData?.sid
            observer.onNext(sid ?? "")
            return Disposables.create()
        })
    }
    
    
    
    
    
    static func checkSid(sid:String) -> Observable<Result> {
        return Observable<Result>.create({ (observer) -> Disposable in
            let parameters:Dictionary = ["sid":sid]
            print("parameters:\(parameters)")
            Alamofire.request("\(BASE_URL)mobile/Login/checkSidExpire",method:.post,parameters:parameters).responseString{
                response in
                print("response:\(response)")
                print("value \(response.result.value)")
                if (response.result.value == nil) {
                    return
                }
                var result:Result = Result()
                var responseEntity = ResponseEntity.deserialize(from: response.result.value as! String)
                if (responseEntity != nil) {
                    if (responseEntity?.code == 0) {
                        result.code = 0
                        result.message = responseEntity?.msg
                    } else {
                        result.code = 1
                        result.message = responseEntity?.msg
                    }
                }
                observer.onNext(result)
            }
            return Disposables.create()
        })
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
}
