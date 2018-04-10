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

class ShopPresenter {
    
    static let app = UIApplication.shared.delegate as! AppDelegate
    static let BASE_URL = app.globalData!.baseUrl
    
    static func searchShopList(pageIndex:Int, num:Int, key:String) ->Observable<ShopListResult> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<ShopListResult>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid, "pageIndex":String(pageIndex), "entryNum":String(num), "search":key]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)app/lottery/sendclub",method:.post,parameters:parameters).responseString{response in
                        print("shop list")
                        print("value: \(response.result.value)")
                        var result:ShopListResult = ShopListResult()
                        switch response.result {
                        case .success:
                            guard let entity:ShopListEntity = ShopListEntity.deserialize(from: response.result.value) as? ShopListEntity else {
                                result.code = 1
                                result.message = "服务器错误"
                                observer.onNext(result)
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
                    }
                    return Disposables.create()
                }
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    static func getShopHistoryList(pageIndex:Int, num:Int) ->Observable<ShopListResult> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<ShopListResult>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid, "pageIndex":String(pageIndex), "entryNum":String(num)]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)app/lottery/lottery_record",method:.post,parameters:parameters).responseString{response in
                        print("shop list")
                        print("value: \(response.result.value)")
                        var result:ShopListResult = ShopListResult()
                        switch response.result {
                        case .success:
                            guard let entity:ShopListEntity = ShopListEntity.deserialize(from: response.result.value) as? ShopListEntity else {
                                result.code = 1
                                result.message = "服务器错误"
                                observer.onNext(result)
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
                    }
                    return Disposables.create()
                }
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    static func getDBShopHistory(pageIndex:Int, num:Int) ->Observable<ShopListResult> {
        return Observable<ShopListResult>.create {
            observer -> Disposable in
            var result:ShopListResult = ShopListResult()
                result.code = 0
                result.list = CoreDataHelper.instance.getShopHistoryList()
                observer.onNext(result)
            
            return Disposables.create()
        }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    

    
    static func getShopWithId(id:String) ->Observable<ShopResult> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<ShopResult>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid,"club_id":id]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)app/lottery/club_detail/",method:.post,parameters:parameters).responseString{response in
                        print("shop detail id ")
                        print("value: \(response.result.value)")
                        
                        var result:ShopResult = ShopResult()
                        switch response.result {
                        case .success:
                            guard let entity:ShopEntity = ShopEntity.deserialize(from: response.result.value) as? ShopEntity else {
                                result.code = 1
                                result.message = "服务器错误"
                                observer.onNext(result)
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
                    }
                    return Disposables.create()
                }
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
}
