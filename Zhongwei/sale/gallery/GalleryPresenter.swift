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
import SwiftyJSON

class GalleryPresenter:Presenter {
    
    func getGalleryList(pageIndex:Int, num:Int,shopId:String) ->Observable<GalleryListResult> {
        return Observable<GalleryListResult>.create { observer -> Disposable in
            GalleryAPIProvicer.request(.images(pageIndex:pageIndex,num:num,shopId:shopId), completion: { (response) in
                var result:GalleryListResult = GalleryListResult()
                switch response {
                case .success(let value):
                    guard let entity:GalleryListEntity = GalleryListEntity.deserialize(from: value.data.toString()) as? GalleryListEntity else {
                        result.code = 1
                        result.message = "服务器错误"
                        observer.onNext(result)
                        observer.onCompleted()
                        return
                    }
                    if (entity.code == 0) {
                        result.code = 0
                        result.message = entity.msg
                        var imageUrls = [String]()
                        if let list = entity.data?.list {
                            for item in list {
                                if let images = item.images {
                                    do{
                                        let jsonData = try JSON(data: images.data(using: String.Encoding.utf8, allowLossyConversion: false)!)
                                        if let url = jsonData[0][0].string {
                                            imageUrls.append(url)
                                        }
                                    } catch (let error) {
                                        Log(error)
                                    }
                                }
                            }
                        }
                        result.data = imageUrls
                    } else {
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
    
    func addImageUrl(shopId:String, imageUrl:String) ->Observable<Result> {
        return Observable<Result>.create { observer -> Disposable in
            GalleryAPIProvicer.request(.addImage(shopId:shopId,imageUrl:imageUrl), completion: { (response) in
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
