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
import Toaster

class MainPresenter {
    
    static let app = UIApplication.shared.delegate as! AppDelegate
    static let BASE_URL = app.globalData!.baseUrl

    static func updateBoardContent() -> Observable<ContentResult>{
        return Observable<ContentResult>.create{
            observer -> Disposable in
            Alamofire.request("\(BASE_URL)mobile/Contents/getContent").responseString{response in
                print("board")
                print("response:\(response)")
                print("result:\(response.result)")
                print("value: \(response.result.value)")
                let result:ContentResult = ContentResult()
                switch response.result {
                case .success:
                    guard let mainNewsEntity:MainNewsEntity = MainNewsEntity.deserialize(from: response.result.value as! String) as? MainNewsEntity else {
                        result.code = 1
                        result.message = "服务器错误"
                        observer.onNext(result)
                        return
                    }
                    if (mainNewsEntity.code == 0) {
                        result.code = 0
                        result.articles = [ArticleData]()
                        result.articles?.append(mainNewsEntity.data!.information!)
                        result.articles?.append(mainNewsEntity.data!.activity!)
                        result.articles?.append(mainNewsEntity.data!.news!)
                    } else {
                        result.code = 1
                        result.message = mainNewsEntity.msg
                    }
                case .failure(let error):
                    result.code = 1
                    result.message = "网络错误"
                }
                observer.onNext(result)
                
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
                
                var result = ImageResult()
                switch response.result {
                case .success:
                    guard let imageDataEntity = ImageDataEntity.deserialize(from: response.result.value as! String) as? ImageDataEntity else {
                        result.code = 1
                        result.message = "服务器错误"
                        observer.onNext(result)
                        return
                    }
                    if (imageDataEntity.code == 0) {
                        result.code = 0
                        result.imageUrls = [String]()
                        for imageData in imageDataEntity.data! {
                            result.imageUrls?.append(imageData.image!)
                        }
                        
                    }
                case .failure(let error):
                    result.code = 1
                    result.message = "网络错误"
                }
                
                observer.onNext(result)
            }
            return Disposables.create()
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    static func getArticleWithId(_ id:String) ->Observable<ArticleUrlResult> {
        return Observable<ArticleUrlResult>.create({ (observer) -> Disposable in
            let parameters:Dictionary = ["id":id]
            print("parameters:\(parameters)")
            Alamofire.request("\(BASE_URL)mobile/Contents/getArticle",method:.post,parameters:parameters).responseString{
                response in
                print("response:\(response)")
                print("value \(response.result.value)")
                if (response.result.value == nil) {
                    return
                }
                var result:ArticleUrlResult = ArticleUrlResult()
                switch response.result {
                case .success:
                    guard let articleUrlEntity:ArticleUrlEntity = ArticleUrlEntity.deserialize(from: response.result.value as! String) as? ArticleUrlEntity else {
                        result.code = 1
                        result.message = "服务器错误"
                        observer.onNext(result)
                        return
                    }
                    if (articleUrlEntity.code == 0) {
                        result.code = 0
                        result.data = articleUrlEntity.data
                    } else {
                        result.code = 1
                        result.message = articleUrlEntity.msg
                    }
                case .failure(let error):
                    result.code = 1
                    result.message = "网络错误"
                }
                
                
                observer.onNext(result)
            }
            return Disposables.create()
        })
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
}
