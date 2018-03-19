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

class ReceiptPresenter {
    
    static let app = UIApplication.shared.delegate as! AppDelegate
    static let BASE_URL = app.globalData!.baseUrl
    
    static func getReceiptList(pageIndex:Int, num:Int) ->Observable<ReceiptListResult> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<ReceiptListResult>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid, "pageIndex":String(pageIndex), "entryNum":String(num)]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)app/Lottery_manager/lotteryList",method:.post,parameters:parameters).responseString{response in
                        print("Receipt list")
                        print("value: \(response.result.value)")
                        if (response.result.value == nil) {
                            return
                        }
                        guard let receiptListEntity:ReceiptListEntity = ReceiptListEntity.deserialize(from: response.result.value as! String) as? ReceiptListEntity else {
                            Toast(text: "服务器错误").show()
                            return
                        }
                        var result:ReceiptListResult = ReceiptListResult()
                        if (receiptListEntity.code == 0) {
                            result.code = 0
                            result.message = receiptListEntity.msg
                            result.list = receiptListEntity.data?.list
                        }else {
                            result.code = 1
                            result.message = receiptListEntity.msg
                        }
                        observer.onNext(result)
                    }
                    return Disposables.create()
                }
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    static func submitReceipt(_ name:String,_ phone:String,_ id:String,_ image:String) ->Observable<Result> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<Result>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid,"name":name,"phone":phone, "lottery_papers":id, "lottery_papers_image":image]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)app/Lottery_manager/lotteryBind",method:.post,parameters:parameters).responseString{response in
                        print("submit ")
                        print("value: \(response.result.value)")
                        if (response.result.value == nil) {
                            return
                        }
                        guard let responseEntity:ResponseEntity = ResponseEntity.deserialize(from: response.result.value as! String) as? ResponseEntity else {
                            Toast(text: "服务器错误").show()
                            return
                        }
                        var result:Result = Result()
                        if (responseEntity.code == 0) {
                            result.code = 0
                            result.message = responseEntity.msg
                        }else {
                            result.code = 1
                            result.message = responseEntity.msg
                        }
                        observer.onNext(result)
                    }
                    return Disposables.create()
                }
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    static func editReceipt(_ name:String,_ phone:String,_ cardId:String,_ imageUrl:String,_ itemId:String) ->Observable<Result> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<Result>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid,"name":name,"phone":phone, "lottery_papers":cardId, "lottery_papers_image":imageUrl,"id":itemId]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)app/Lottery_manager/modifyLotteryBind",method:.post,parameters:parameters).responseString{response in
                        print("edit ")
                        print("value: \(response.result.value)")
                        if (response.result.value == nil) {
                            return
                        }
                        guard let responseEntity:ResponseEntity = ResponseEntity.deserialize(from: response.result.value as! String) as? ResponseEntity else {
                            Toast(text: "服务器错误").show()
                            return
                        }
                        var result:Result = Result()
                        if (responseEntity.code == 0) {
                            result.code = 0
                            result.message = responseEntity.msg
                        }else {
                            result.code = 1
                            result.message = responseEntity.msg
                        }
                        observer.onNext(result)
                    }
                    return Disposables.create()
                }
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    static func getDetailWithId(_ id:String) ->Observable<ReceiptResult> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<ReceiptResult>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid,"id":id]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)app/Lottery_manager/getLotteryDetail",method:.post,parameters:parameters).responseString{response in
                        print("detai id ")
                        print("value: \(response.result.value)")
                        if (response.result.value == nil) {
                            return
                        }
                        guard let receiptEntity:ReceiptEntity = ReceiptEntity.deserialize(from: response.result.value as! String) as? ReceiptEntity else {
                            Toast(text: "服务器错误").show()
                            return
                        }
                        var result:ReceiptResult = ReceiptResult()
                        if (receiptEntity.code == 0) {
                            result.code = 0
                            result.message = receiptEntity.msg
                            result.data = receiptEntity.data
                        }else {
                            result.code = 1
                            result.message = receiptEntity.msg
                        }
                        observer.onNext(result)
                    }
                    return Disposables.create()
                }
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    static func deleteReceipt(id:String) ->Observable<Result> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<Result>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid,"id":id]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)app/Lottery_manager/delLottery",method:.post,parameters:parameters).responseString{response in
                        print("delete id ")
                        print("value: \(response.result.value)")
                        if (response.result.value == nil) {
                            return
                        }
                        guard let responseEntity:ResponseEntity = ResponseEntity.deserialize(from: response.result.value as! String) as? ResponseEntity else {
                            Toast(text: "服务器错误").show()
                            return
                        }
                        var result:Result = Result()
                        if (responseEntity.code == 0) {
                            result.code = 0
                            result.message = responseEntity.msg
                        }else {
                            result.code = 1
                            result.message = responseEntity.msg
                        }
                        observer.onNext(result)
                    }
                    return Disposables.create()
                }
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
}
