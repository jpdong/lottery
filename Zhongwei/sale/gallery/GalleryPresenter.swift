//
//  GalleryPresenter.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/28.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import HandyJSON
import Toaster

class GalleryPresenter {
    
    static let app = UIApplication.shared.delegate as! AppDelegate
    static let BASE_URL = app.globalData!.baseUrl
    
    static func getGalleryList(pageIndex:Int, num:Int,shopId:String) ->Observable<GalleryListResult> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<GalleryListResult>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid, "pageIndex":String(pageIndex), "entryNum":String(num),"club_id":shopId]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)app/Lottery_manager/interviewImagesList",method:.post,parameters:parameters).responseString{response in
                        print("gallery list")
                        print("value: \(response.result.value)")
                        var result:GalleryListResult = GalleryListResult()
                        switch response.result {
                        case .success:
                            guard let entity:GalleryListEntity = GalleryListEntity.deserialize(from: response.result.value as! String) as? GalleryListEntity else {
                                result.code = 1
                                result.message = "服务器错误"
                                observer.onNext(result)
                                return
                            }
                            if (entity.code == 0) {
                                result.code = 0
                                result.message = entity.msg
                                var imageUrls = [String]()
                                
                                
                                
                            } else {
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
    
    static func addImageUrl(shopId:String, imageUrl:String) ->Observable<Result> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<Result>.create {
                    observer -> Disposable in
                    var receiptImagesObject = ReceiptImagesObject()
                    var imageUrls = [String]()
                    imageUrls.append(imageUrl)
                    receiptImagesObject.receipt_image = imageUrls
                    var jsonString = receiptImagesObject.toJSONString() as! String
                    let parameters:Dictionary = ["sid":sid,"club_id":shopId, "images":jsonString]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)app/Lottery_manager/addInterviewImages",method:.post,parameters:parameters).responseString{response in
                        print("submit gallery ")
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
