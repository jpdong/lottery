//
//  MainPresenter.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/9.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import HandyJSON

class MainPresenter {
    
    static let app = UIApplication.shared.delegate as! AppDelegate
    static let BASE_URL = app.globalData!.baseUrl

    static func updateBoardContent() -> Observable<ContentResult>{
        return Observable<ContentResult>.create{
            observer -> Disposable in
            Alamofire.request("\(BASE_URL)mobile/Contents/getContent").responseString{response in
                let contentResult:ContentResult = ContentResult()
                let mainNewsEntity:MainNewsEntity = MainNewsEntity.deserialize(from: response.result.value as! String) as! MainNewsEntity
                if (mainNewsEntity.code == 0) {
                    contentResult.code = 0
                    contentResult.articles = [ArticleData]()
                    contentResult.articles?.append(mainNewsEntity.data!.information!)
                    contentResult.articles?.append(mainNewsEntity.data!.activity!)
                    contentResult.articles?.append(mainNewsEntity.data!.news!)
                    observer.onNext(contentResult )
//                    contentResult.information = mainNewsEntity.data?.information
//                    contentResult.activity = mainNewsEntity.data?.activity
//                    contentResult.news = mainNewsEntity.data?.news
                } else {
                    contentResult.code = 1
                    contentResult.message = mainNewsEntity.msg
                }
            }
            return Disposables.create()
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    static func updateBannerContent() -> Observable<ImageResult> {
        
        return Observable<ImageResult>.create{
            observer -> Disposable in
            Alamofire.request("\(BASE_URL)mobile/Contents/getBanner").responseString{response in
                print("banner")
                print("response:\(response)")
                print("result:\(response.result)")
                print("value: \(response.result.value)")
                var imageResult = ImageResult()
                var imageDataEntity = ImageDataEntity.deserialize(from: response.result.value as! String) as! ImageDataEntity
                if (imageDataEntity.code == 0) {
                    imageResult.code = 0
                    imageResult.imageUrls = [String]()
                    for imageData in imageDataEntity.data! {
                        imageResult.imageUrls?.append(imageData.image!)
                    }
                    observer.onNext(imageResult)
                }
            }
            return Disposables.create()
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
}
