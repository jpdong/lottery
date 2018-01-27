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

class Presenter{
    static func getUrl(unionid:String,urlHead:String) -> Observable<String>{
        return Observable<String>.create {
            (observer) -> Disposable in
            Alamofire.request("http://yan.eeseetech.cn/mobile/wechat/getSid/\(unionid)").responseString{response in
                print("value \(response.result.value)")
                if let sidEntity = SidEntity.deserialize(from:response.result.value!){
                    print("sid \(sidEntity.data!.sid!)")
                    observer.onNext(sidEntity.data!.sid!)
                }
                
            }
            return Disposables.create ()
            }
            .map{"\(urlHead)\($0)"}
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    static func getShopUrl(unionid:String) -> Observable<String>{
        return getUrl(unionid:unionid, urlHead:"http://yan.eeseetech.cn/mobile/wechat/shop?sid=")
    }
    
    static func getManagerUrl(unionid:String) -> Observable<String>{
        return getUrl(unionid:unionid, urlHead:"http://yan.eeseetech.cn/mobile/wechat/manager?sid=")
    }
    
    static func getAreaManagerUrl(unionid:String) -> Observable<String>{
        return getUrl(unionid:unionid, urlHead:"http://yan.eeseetech.cn/mobile/wechat/area_manager?sid=")
    }
}
