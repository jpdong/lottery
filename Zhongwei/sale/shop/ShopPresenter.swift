//
//  ShopPresenter.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/26.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import HandyJSON
import Toaster

class ShopPresenter:Presenter {
    
    func searchShopList(pageIndex:Int, num:Int, key:String) ->Observable<ShopListResult> {
        return Observable<ShopListResult>.create { observer -> Disposable in
            ShopAPIProvicer.request(.shops(pageIndex:pageIndex,num:num,key:key), completion: { (response) in
                var result:ShopListResult = ShopListResult()
                switch response {
                case .success(let value):
                    guard let entity:ShopListEntity = ShopListEntity.deserialize(from: value.data.toString()) as? ShopListEntity else {
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
    
    func getShopHistoryList(pageIndex:Int, num:Int) ->Observable<ShopListResult> {
        return getSid()
            .flatMap{
                sid in
                return Observable<ShopListResult>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid, "pageIndex":String(pageIndex), "entryNum":String(num)]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(self.baseUrl)app/lottery/lottery_record",method:.post,parameters:parameters).responseString{response in
                        print("shop list")
                        print("value: \(response.result.value)")
                        var result:ShopListResult = ShopListResult()
                        switch response.result {
                        case .success:
                            guard let entity:ShopListEntity = ShopListEntity.deserialize(from: response.result.value) as? ShopListEntity else {
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
    
    func getDBShopHistory(pageIndex:Int, num:Int) ->Observable<ShopListResult> {
        return Observable<ShopListResult>.create {
            observer -> Disposable in
            var result:ShopListResult = ShopListResult()
            result.code = 0
            result.list = CoreDataHelper.instance.getShopHistoryList()
            observer.onNext(result)
            observer.onCompleted()
            return Disposables.create()
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    
    
    func getShopWithId(id:String) ->Observable<ShopResult> {
        return Observable<ShopResult>.create { observer -> Disposable in
            ShopAPIProvicer.request(.getShop(id:id), completion: { (response) in
                var result:ShopResult = ShopResult()
                switch response {
                case .success(let value):
                    guard let entity:ShopEntity = ShopEntity.deserialize(from: value.data.toString()) as? ShopEntity else {
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
