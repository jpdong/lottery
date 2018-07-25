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
import Moya

class ReceiptPresenter:Presenter {
 
    func getReceiptList(pageIndex:Int, num:Int) ->Observable<ReceiptListResult> {
        return Observable<ReceiptListResult>.create { observer -> Disposable in
            ReceiptAPIProvicer.request(.receipts(pageIndex:pageIndex,num:num), completion: { (response) in
                var result:ReceiptListResult = ReceiptListResult()
                switch response {
                case .success(let value):
                    guard let entity:ReceiptListEntity = ReceiptListEntity.deserialize(from: String(data: value.data, encoding: String.Encoding.utf8)) as? ReceiptListEntity else {
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
    
    func submitReceipt(notes:String, imageUrls:[String]) ->Observable<Result> {
        return Observable<Result>.create { observer -> Disposable in
            ReceiptAPIProvicer.request(.addReceipt(notes:notes,imageUrls:imageUrls), completion: { (response) in
                var result:Result = Result()
                switch response {
                case .success(let value):
                    guard let responseEntity:ResponseEntity = ResponseEntity.deserialize(from: value.data.toString()) as? ResponseEntity else {
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
            })
            return Disposables.create()
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    func editReceipt(notes:String, imageUrls:[String],id:String) ->Observable<Result> {
        return Observable<Result>.create { observer -> Disposable in
            ReceiptAPIProvicer.request(.editReceipt(notes:notes,imageUrls:imageUrls,id:id), completion: { (response) in
                var result:Result = Result()
                switch response {
                case .success(let value):
                    guard let responseEntity:ResponseEntity = ResponseEntity.deserialize(from: value.data.toString()) as? ResponseEntity else {
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
            })
            
            return Disposables.create()
            
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    func getDetailWithId(_ id:String) ->Observable<ReceiptResult> {
        return Observable<ReceiptResult>.create { observer -> Disposable in
            ReceiptAPIProvicer.request(.getReceipt(id:id), completion: { (response) in
                var result:ReceiptResult = ReceiptResult()
                switch response {
                case .success(let value):
                    guard let entity:ReceiptEntity = ReceiptEntity.deserialize(from: value.data.toString()) as? ReceiptEntity else {
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
    
    func deleteReceipt(id:String) ->Observable<Result> {
        return Observable<Result>.create { observer -> Disposable in
            ReceiptAPIProvicer.request(.deleteReceipt(id:id), completion: { (response) in
                var result:Result = Result()
                switch response {
                case .success(let value):
                    guard let responseEntity:ResponseEntity = ResponseEntity.deserialize(from: value.data.toString()) as? ResponseEntity else {
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
            })
            return Disposables.create()
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
}
