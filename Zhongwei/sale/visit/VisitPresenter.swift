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
    
    static func submitVisit(notes:String, imageUrls:[String]) ->Observable<Result> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<Result>.create {
                    observer -> Disposable in
                    var visitImagesObject = VisitImagesObject()
                    //visitImagesObject.visit_image = imageUrls
                    var jsonString = visitImagesObject.toJSONString() as! String
                    let parameters:Dictionary = ["sid":sid,"notes":notes, "Visit_image":jsonString]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)app/Lottery_manager/addVisit",method:.post,parameters:parameters).responseString{response in
                        print("submitVisit ")
                        print("value: \(response.result.value)")
                        var result:Result = Result()
                        switch response.result {
                        case .success:
                            guard let responseEntity:ResponseEntity = ResponseEntity.deserialize(from: response.result.value as! String) as? ResponseEntity else {
                                result.code = 1
                                result.message = "服务器错误"
                                observer.onNext(result)
                                return
                            }
                            
                            if (responseEntity.code == 0) {
                                result.code = 0
                                result.message = responseEntity.msg
                            }else {
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
                }
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    static func editVisit(notes:String, imageUrls:[String],id:String) ->Observable<Result> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<Result>.create {
                    observer -> Disposable in
                    var visitImagesObject = VisitImagesObject()
                    //VisitImagesObject.Visit_image = imageUrls
                    var jsonString = visitImagesObject.toJSONString() as! String
                    let parameters:Dictionary = ["sid":sid,"notes":notes, "Visit_image":jsonString,"id":id]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)app/Lottery_manager/modifyVisit",method:.post,parameters:parameters).responseString{response in
                        print("edit ")
                        print("value: \(response.result.value)")
                        var result:Result = Result()
                        switch response.result {
                        case .success:
                            guard let responseEntity:ResponseEntity = ResponseEntity.deserialize(from: response.result.value as! String) as? ResponseEntity else {
                                result.code = 1
                                result.message = "服务器错误"
                                observer.onNext(result)
                                return
                            }
                            
                            if (responseEntity.code == 0) {
                                result.code = 0
                                result.message = responseEntity.msg
                            }else {
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
                }
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    static func getDetailWithId(_ id:String) ->Observable<VisitResult> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<VisitResult>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid,"id":id]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)app/Lottery_manager/getVisitDetail",method:.post,parameters:parameters).responseString{response in
                        print("detai id ")
                        print("value: \(response.result.value)")
                        var result:VisitResult = VisitResult()
                        switch response.result {
                        case .success:
                            guard let entity:VisitEntity = VisitEntity.deserialize(from: response.result.value as! String) as? VisitEntity else {
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
    
    static func deleteVisit(id:String) ->Observable<Result> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<Result>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid,"id":id]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)app/Lottery_manager/delVisit",method:.post,parameters:parameters).responseString{response in
                        print("delete id ")
                        print("value: \(response.result.value)")
                        var result:Result = Result()
                        switch response.result {
                        case .success:
                            guard let responseEntity:ResponseEntity = ResponseEntity.deserialize(from: response.result.value as! String) as? ResponseEntity else {
                                result.code = 1
                                result.message = "服务器错误"
                                observer.onNext(result)
                                return
                            }
                            
                            if (responseEntity.code == 0) {
                                result.code = 0
                                result.message = responseEntity.msg
                            }else {
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
                }
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
}
