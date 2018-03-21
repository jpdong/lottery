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
import Toaster

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
                var result = ""
                switch response.result {
                case .success:
                    if let sidEntity = SidEntity.deserialize(from:response.result.value!) as? SidEntity {
                        if (sidEntity.data?.sid != nil) {
                            result = sidEntity.data!.sid!
                        }
                    } else {
                        result = ""
                        return
                    }
                case .failure(let error):
                    result = ""
                }
                observer.onNext(result)
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
                switch response.result {
                case .success:
                    guard let responseEntity = ResponseEntity.deserialize(from: response.result.value as! String) as? ResponseEntity else {
                        result.code = 1
                        result.message = "服务器错误"
                        observer.onNext(result)
                        return
                    }
                    if (responseEntity.code == 0) {
                        result.code = 0
                        result.message = responseEntity.msg
                    } else {
                        result.code = 1
                        result.message = responseEntity.msg
                    }
                case .failure(let error):
                    result.code = 1
                    result.message = "网络错误"
                }
                observer.onNext(result)
            }
            return Disposables.create()
        })
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    static func checkAppUpdate() -> Observable<AppUpdateResult> {
        return Observable<AppUpdateResult>.create({ (observer) -> Disposable in
            let infoDictionary = Bundle.main.infoDictionary!
            let majorVersion = infoDictionary["CFBundleShortVersionString"]
            let version = majorVersion as! String
            let parameters:Dictionary = ["version":version]
            print("parameters:\(parameters)")
            Alamofire.request("\(BASE_URL)mobile/App/checkVersion",method:.post,parameters:parameters).responseString{
                response in
                print("update")
                print("response:\(response)")
                print("value \(response.result.value)")
                var result:AppUpdateResult = AppUpdateResult()
                switch response.result {
                case .success:
                    guard let appUpdateEntity = AppUpdateEntity.deserialize(from: response.result.value as! String) as? AppUpdateEntity else {
                        result.code = 1
                        result.message = "服务器错误"
                        observer.onNext(result)
                        return
                    }
                    
                    if (appUpdateEntity.code == 0) {
                        result.code = 0
                        result.message = appUpdateEntity.msg
                        result.version = appUpdateEntity.data?.version
                        result.forceUpdate = appUpdateEntity.data?.compel
                        if (version == result.version) {
                            result.update = false
                        } else {
                            result.update = true
                        }
                        
                    } else {
                        result.code = 1
                        result.message = appUpdateEntity.msg
                    }
                case .failure(let error):
                    result.code = 1
                    result.message = "网络错误"
                }
            
                
                
                observer.onNext(result)
            }
            return Disposables.create()
        })
        .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
}
