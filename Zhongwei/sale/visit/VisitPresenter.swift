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

class VisitPresenter {
    
    static let app = UIApplication.shared.delegate as! AppDelegate
    static let BASE_URL = app.globalData!.baseUrl
    
    static func getVisitList(pageIndex:Int, num:Int) ->Observable<VisitListResult> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<VisitListResult>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid, "pageIndex":String(pageIndex), "entryNum":String(num)]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)app/Lottery_manager/interviewLogList",method:.post,parameters:parameters).responseString{response in
                        print("Visit list")
                        print("value: \(response.result.value)")
                        var result:VisitListResult = VisitListResult()
                        switch response.result {
                        case .success:
                            guard let entity:VisitListEntity = VisitListEntity.deserialize(from: response.result.value as! String) as? VisitListEntity else {
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
    
    static func sign(longitude:Double, latitude:Double, status:Int, shopId:String) ->Observable<VisitListResult> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<VisitListResult>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid, "long":String(longitude), "lat":String(latitude), "status":String(status),"club_id":shopId]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)app/lottery/sign",method:.post,parameters:parameters).responseString{response in
                        print("Visit list")
                        print("value: \(response.result.value)")
                        var result:VisitListResult = VisitListResult()
                        switch response.result {
                        case .success:
                            guard let entity:VisitListEntity = VisitListEntity.deserialize(from: response.result.value as! String) as? VisitListEntity else {
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
}
