//
//  VisitPresenter.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import HandyJSON
import Toaster

class VisitPresenter:Presenter {
    
    func getVisitList(pageIndex:Int, num:Int) ->Observable<VisitListResult> {
        return getSid()
            .flatMap{
                sid in
                return Observable<VisitListResult>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid, "pageIndex":String(pageIndex), "entryNum":String(num)]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(self.baseUrl)app/lottery/lottery_record",method:.post,parameters:parameters).responseString{response in
                        print("Visit list")
                        print("value: \(response.result.value)")
                        var result:VisitListResult = VisitListResult()
                        switch response.result {
                        case .success:
                            guard let entity:VisitListEntity = VisitListEntity.deserialize(from: response.result.value) as? VisitListEntity else {
                                result.code = 1
                                result.message = "服务器错误"
                                observer.onNext(result)
                                observer.onCompleted()
                                return
                            }
                            if (entity.code == 0) {
                                result.code = 0
                                result.message = entity.msg
                                result.list = entity.data?.list
                            }else {
                                result.code = 1
                                result.message = entity.msg
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
    
    func sign(longitude:Double, latitude:Double, status:Int, shopId:String) ->Observable<VisitListResult> {
        return getSid()
            .flatMap{
                sid in
                return Observable<VisitListResult>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid, "long":String(longitude), "lat":String(latitude), "status":String(status),"club_id":shopId]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(self.baseUrl)app/lottery/sign",method:.post,parameters:parameters).responseString{response in
                        print("Visit list")
                        print("value: \(response.result.value)")
                        var result:VisitListResult = VisitListResult()
                        switch response.result {
                        case .success:
                            guard let entity:VisitListEntity = VisitListEntity.deserialize(from: response.result.value) as? VisitListEntity else {
                                result.code = 1
                                result.message = "服务器错误"
                                observer.onNext(result)
                                observer.onCompleted()
                                return
                            }
                            if (entity.code == 0) {
                                result.code = 0
                                result.message = entity.msg
                                result.list = entity.data?.list
                            }else {
                                result.code = 1
                                result.message = entity.msg
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
    
    
    func checkVisitManagerState() -> Observable<VisitStateResult> {
        return getSid()
            .flatMap{
                sid in
                return Observable<VisitStateResult>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(self.baseUrl)mobile/app/lottery_manager",method:.post,parameters:parameters).responseString{response in
                        print("Visit state")
                        print("value: \(response.result.value)")
                        var result:VisitStateResult = VisitStateResult()
                        switch response.result {
                        case .success:
                            guard let entity:VisitStateEntity = VisitStateEntity.deserialize(from: response.result.value) as? VisitStateEntity else {
                                result.code = 1
                                result.message = "服务器错误"
                                observer.onNext(result)
                                observer.onCompleted()
                                return
                            }
                            if (entity.code == 0) {
                                result.code = 0
                                result.message = entity.msg
                                result.data = entity.data
                            }else {
                                result.code = 1
                                result.message = entity.msg
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
}
