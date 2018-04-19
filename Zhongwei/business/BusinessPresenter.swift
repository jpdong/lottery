//
//  BusinessPresenter.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/2.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import HandyJSON
import Toaster

class BusinessPresenter:Presenter {
    
    func checkBusinessRegisterState() -> Observable<Result> {
        //return Observable<Result>.create({ (observer) -> Disposable in
        return getSid()
            .flatMap{
                sid in
                return Observable<Result>.create {
                    observer -> Disposable in
                    Alamofire.request("\(self.baseUrl)mobile/app/judeIdent?sid=\(sid)").responseString{response in
                        print("business state")
                        print("response:\(response)")
                        print("value: \(response.result.value)")
                        var result:Result = Result()
                        switch response.result {
                        case .success:
                            print("switch case success")
                            guard let businessStateEntity:BusinessStateEntity = BusinessStateEntity.deserialize(from: response.result.value as? String) as? BusinessStateEntity else {
                                //Toast(text: "服务器错误").show()
                                result.code = 1
                                result.message = "服务器错误"
                                observer.onNext(result)
                                observer.onCompleted()
                                return
                            }
                            if (businessStateEntity.code == 200) {
                                if (businessStateEntity.data!.club!){
                                    result.code = 0
                                }else {
                                    result.code = 2
                                    result.message = "未注册"
                                }
                            } else {
                                result.code = 1
                                result.message = businessStateEntity.msg
                            }
                            
                        case .failure(let error):
                            print("switch case failure:\(error)")
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
    
    
    
    func uploadImageUrls(front:String, back:String, tobacco:String) -> Observable<Result> {
        //return Observable<Result>.create({ (observer) -> Disposable in
        return getSid()
            .flatMap{
                sid in
                return Observable<Result>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["front":front, "back":back, "sid":sid, "yan_code":tobacco]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(self.baseUrl)mobile/Register/uploadClubImage",method:.post,parameters:parameters).responseString{response in
                        print("response:\(response)")
                        print("result:\(response.result)")
                        print("value: \(response.result.value)")
                        var result:Result = Result()
                        switch response.result {
                        case .success:
                            guard let responseEntity:ResponseEntity = ResponseEntity.deserialize(from: response.result.value as! String) as? ResponseEntity else {
                                result.code = 1
                                result.message = "服务器错误"
                                observer.onNext(result)
                                observer.onCompleted()
                                return
                            }
                            
                            if (responseEntity.code == 0) {
                                result.code = 0
                                result.message = responseEntity.msg
                            }else {
                                result.code = 1
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
    
    func getUrl(unionid:String,headimgurl:String, nickname:String,urlHead:String) -> Observable<String>{
        print("urlHead:\(urlHead)")
        //        return Observable<String>.create {
        //            (observer) -> Disposable in
        //            let parameters:Dictionary = ["unionid":unionid,"headimgurl":headimgurl, "nickname":nickname]
        //            Alamofire.request("\(self.baseUrl)mobile/wechat/getSid",method:.post,parameters:parameters).responseString{response in
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
        //return getSid(unionid: unionid, headimgurl: headimgurl, nickname: nickname)
        return getSid()
            .map{
                sid in
                Log("url:\(urlHead)\(sid)")
                return "\(urlHead)\(sid)"
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    func getShopUrl(unionid:String,headimgurl:String, nickname:String) -> Observable<String>{
        return getUrl(unionid:unionid,headimgurl: headimgurl, nickname: nickname, urlHead:"\(self.baseUrl)mobile/app/shop?sid=")
    }
    
    func getManagerUrl(unionid:String,headimgurl:String, nickname:String) -> Observable<String>{
        return getUrl(unionid:unionid, headimgurl: headimgurl, nickname: nickname,urlHead:"\(self.baseUrl)mobile/app/manager?sid=")
    }
    
    func getAreaManagerUrl(unionid:String,headimgurl:String, nickname:String) -> Observable<String>{
        return getUrl(unionid:unionid, headimgurl: headimgurl, nickname: nickname,urlHead:"\(self.baseUrl)mobile/app/bazaar_manager?sid=")
    }
    
    func getMarketManagerUrl(unionid:String,headimgurl:String, nickname:String) -> Observable<String>{
        return getUrl(unionid:unionid, headimgurl: headimgurl, nickname: nickname,urlHead:"\(self.baseUrl)mobile/app/area_manager?sid=")
    }
    
    func getPointMallUrl() -> Observable<String> {
        return getSid()
            .map{
                sid in
                return "\(self.baseUrl)mobile/wechat/credits_shop?sid=\(sid)"
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
}
