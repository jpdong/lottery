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
    static let completedSemaphore = DispatchSemaphore(value: 0)
    static let semaphore = DispatchSemaphore(value:0)
    
    static func getReceiptList(pageIndex:Int, num:Int) ->Observable<ReceiptListResult> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<ReceiptListResult>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid, "pageIndex":String(pageIndex), "entryNum":String(num)]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)app/Lottery_manager/receiptList",method:.post,parameters:parameters).responseString{response in
                        print("Receipt list")
                        print("value: \(response.result.value)")
                        
                        var result:ReceiptListResult = ReceiptListResult()
                        switch response.result {
                        case .success:
                            guard let entity:ReceiptListEntity = ReceiptListEntity.deserialize(from: response.result.value as! String) as? ReceiptListEntity else {
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
    
    static func uploadReceiptImages(images:[UIImage]) -> Observable<Result> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<Result>.create {
                    observer -> Disposable in
                    for image in images {
                        Alamofire.upload(multipartFormData: { (multipartFormData) in
                            multipartFormData.append(UIImageJPEGRepresentation(image,1.0)!,withName:"image",fileName:"idcard.png",mimeType:"image/png")
                            multipartFormData.append(sid.data(using: String.Encoding.utf8)!,withName:"sid")
                        }, to: "\(BASE_URL)mobile/Register/upload", encodingCompletion: { (encodingResult) in
                            //print("encodingResult:\(encodingResult)")
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseString{ response in
                                    print("response:\(response)")
                                    print("result:\(response.result)")
                                    var result:Result = Result()
                                    switch response.result {
                                    case .success:
                                        guard let imageUrlEntity:ImageUrlEntity = ImageUrlEntity.deserialize(from: response.result.value as! String) as? ImageUrlEntity else {
                                            result.code = 1
                                            result.message = "服务器错误"
                                            semaphore.signal()
                                            observer.onNext(result)
                                            return
                                        }
                                        if (imageUrlEntity.code != nil && imageUrlEntity.code! == 0) {
                                            result.code = 0
                                            result.message = imageUrlEntity.data
                                        } else {
                                            result.code = 1
                                            result.message = "图片上传失败"
                                        }
                                    case .failure(let error):
                                        result.code = 1
                                        result.message = "网络错误"
                                    }
                                    semaphore.signal()
                                    observer.onNext(result)
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                                semaphore.signal()
                            }
                            
                        })
                        Log("semaphore wait")
                        semaphore.wait(timeout:DispatchTime.now() + .seconds(10))
                    }
                    observer.onCompleted()
                    return Disposables.create()
                }
            }
        .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    static func submitReceipt(notes:String, imageUrls:[String]) ->Observable<Result> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<Result>.create {
                    observer -> Disposable in
                    var receiptImagesObject = ReceiptImagesObject()
                    receiptImagesObject.receipt_image = imageUrls
                    var jsonString = receiptImagesObject.toJSONString() as! String
                    let parameters:Dictionary = ["sid":sid,"notes":notes, "receipt_image":jsonString]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)app/Lottery_manager/addReceipt",method:.post,parameters:parameters).responseString{response in
                        print("submitReceipt ")
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
    
    static func getReceiptImageUrls(images:[UIImage]) -> [String] {
        var imageUrls = [String]()
        uploadReceiptImages(images: images)
            .subscribe(onNext: { (result) in
                if (result.code == 0) {
                    Log("on next")
                    imageUrls.append(result.message!)
                }
            }, onCompleted: {
                Log("on complete")
                completedSemaphore.signal()
            })
        completedSemaphore.wait(timeout:DispatchTime.now() + .seconds(60))
        return imageUrls
    }
    
    static func editReceipt(notes:String, imageUrls:[String],id:String) ->Observable<Result> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<Result>.create {
                    observer -> Disposable in
                    var receiptImagesObject = ReceiptImagesObject()
                    receiptImagesObject.receipt_image = imageUrls
                    var jsonString = receiptImagesObject.toJSONString() as! String
                    let parameters:Dictionary = ["sid":sid,"notes":notes, "receipt_image":jsonString,"id":id]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)app/Lottery_manager/modifyReceipt",method:.post,parameters:parameters).responseString{response in
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
    
    static func getDetailWithId(_ id:String) ->Observable<ReceiptResult> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<ReceiptResult>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid,"id":id]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)app/Lottery_manager/getReceiptDetail",method:.post,parameters:parameters).responseString{response in
                        print("detai id ")
                        print("value: \(response.result.value)")
                        var result:ReceiptResult = ReceiptResult()
                        switch response.result {
                        case .success:
                            guard let entity:ReceiptEntity = ReceiptEntity.deserialize(from: response.result.value as! String) as? ReceiptEntity else {
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
    
    static func deleteReceipt(id:String) ->Observable<Result> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<Result>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid,"id":id]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)app/Lottery_manager/delReceipt",method:.post,parameters:parameters).responseString{response in
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
