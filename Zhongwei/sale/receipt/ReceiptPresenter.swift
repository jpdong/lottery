//
//  ReceiptPresenter.swift
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

class ReceiptPresenter:Presenter {
 
    func getReceiptList(pageIndex:Int, num:Int) ->Observable<ReceiptListResult> {
        return getSid()
            .flatMap{
                sid in
                return Observable<ReceiptListResult>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid, "pageIndex":String(pageIndex), "entryNum":String(num)]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(self.baseUrl)app/Lottery_manager/receiptList",method:.post,parameters:parameters).responseString{response in
                        print("Receipt list")
                        print("value: \(response.result.value)")
                        
                        var result:ReceiptListResult = ReceiptListResult()
                        switch response.result {
                        case .success:
                            guard let entity:ReceiptListEntity = ReceiptListEntity.deserialize(from: response.result.value as! String) as? ReceiptListEntity else {
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
    
    func submitReceipt(notes:String, imageUrls:[String]) ->Observable<Result> {
        return getSid()
            .flatMap{
                sid in
                return Observable<Result>.create {
                    observer -> Disposable in
                    var receiptImagesObject = ReceiptImagesObject()
                    receiptImagesObject.image = imageUrls
                    var jsonString = receiptImagesObject.toJSONString() as! String
                    let parameters:Dictionary = ["sid":sid,"notes":notes, "receipt_image":jsonString]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(self.baseUrl)app/Lottery_manager/addReceipt",method:.post,parameters:parameters).responseString{response in
                        print("submitReceipt ")
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
                                result.message = responseEntity.msg
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
    
    func editReceipt(notes:String, imageUrls:[String],id:String) ->Observable<Result> {
        return getSid()
            .flatMap{
                sid in
                return Observable<Result>.create {
                    observer -> Disposable in
                    var receiptImagesObject = ReceiptImagesObject()
                    receiptImagesObject.image = imageUrls
                    var jsonString = receiptImagesObject.toJSONString() as! String
                    let parameters:Dictionary = ["sid":sid,"notes":notes, "receipt_image":jsonString,"id":id]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(self.baseUrl)app/Lottery_manager/modifyReceipt",method:.post,parameters:parameters).responseString{response in
                        print("edit ")
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
                                result.message = responseEntity.msg
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
    
    func getDetailWithId(_ id:String) ->Observable<ReceiptResult> {
        return getSid()
            .flatMap{
                sid in
                return Observable<ReceiptResult>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid,"id":id]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(self.baseUrl)app/Lottery_manager/getReceiptDetail",method:.post,parameters:parameters).responseString{response in
                        print("detai id ")
                        print("value: \(response.result.value)")
                        var result:ReceiptResult = ReceiptResult()
                        switch response.result {
                        case .success:
                            guard let entity:ReceiptEntity = ReceiptEntity.deserialize(from: response.result.value as! String) as? ReceiptEntity else {
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
    
    func deleteReceipt(id:String) ->Observable<Result> {
        return getSid()
            .flatMap{
                sid in
                return Observable<Result>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid,"id":id]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(self.baseUrl)app/Lottery_manager/delReceipt",method:.post,parameters:parameters).responseString{response in
                        print("delete id ")
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
                                result.message = responseEntity.msg
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
