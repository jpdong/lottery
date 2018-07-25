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
        return Observable<VisitListResult>.create { observer -> Disposable in
            VisitAPIProvicer.request(.visitRecords(pageIndex:pageIndex,num:num), completion: { (response) in
                var result:VisitListResult = VisitListResult()
                switch response {
                case .success(let value):
                    guard let entity:VisitListEntity = VisitListEntity.deserialize(from: value.data.toString()) as? VisitListEntity else {
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
            })
            return Disposables.create()
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    func sign(longitude:Double, latitude:Double, status:Int, shopId:String) ->Observable<VisitListResult> {
        return Observable<VisitListResult>.create { observer -> Disposable in
            VisitAPIProvicer.request(.sign(longitude:longitude,latitude:latitude,status:status,shopId:shopId), completion: { (response) in
                var result:VisitListResult = VisitListResult()
                switch response {
                case .success(let value):
                    guard let entity:VisitListEntity = VisitListEntity.deserialize(from: value.data.toString()) as? VisitListEntity else {
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
            })
            return Disposables.create()
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    
    func checkVisitManagerState() -> Observable<VisitStateResult> {
        return Observable<VisitStateResult>.create { observer -> Disposable in
            VisitAPIProvicer.request(.visitManagerState, completion: { (response) in
                var result:VisitStateResult = VisitStateResult()
                switch response {
                case .success(let value):
                    guard let entity:VisitStateEntity = VisitStateEntity.deserialize(from: value.data.toString()) as? VisitStateEntity else {
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
            })
            return Disposables.create()
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
}
