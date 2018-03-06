//
//  BusinessPresenter.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/2.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import HandyJSON

class BusinessPresenter {
    
    static let app = UIApplication.shared.delegate as! AppDelegate
    static let BASE_URL = app.globalData!.baseUrl
    
    static func checkBusinessRegisterState() -> Observable<Result> {
        //return Observable<Result>.create({ (observer) -> Disposable in
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<Result>.create {
                    observer -> Disposable in
                    Alamofire.request("\(BASE_URL)mobile/app/judeIdent?sid=\(sid)").responseString{response in
                        print("response:\(response)")
                        print("result:\(response.result)")
                        print("value: \(response.result.value)")
                        if (response.result.value == nil) {
                            return
                        }
                        let businessStateEntity:BusinessStateEntity = BusinessStateEntity.deserialize(from: response.result.value as! String) as! BusinessStateEntity
                        var result:Result = Result()
                        if (businessStateEntity.code == 200) {
                            if (businessStateEntity.data!.club!){
                                result.code = 0
                            }else {
                                result.code = 1
                            }
                            observer.onNext(result)
                        }
                    }
                    return Disposables.create()
                }
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
        
    }
    
    static func uploadImage(image:UIImage) -> Observable<Result> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<Result>.create {
                    observer -> Disposable in
                    Alamofire.upload(multipartFormData: { (multipartFormData) in
//                        multipartFormData.appendBodyPart(data:UIImageJPEGRepresentation(image,1.0),name:"image",fileName:"idcard.png",mimeType:"image/png")
//                        multipartFormData.appendBodyPart(data:sid.data(using: String.Encoding.utf8),name:"sid")
                        multipartFormData.append(UIImageJPEGRepresentation(image,1.0)!,withName:"image",fileName:"idcard.png",mimeType:"image/png")
                        multipartFormData.append(sid.data(using: String.Encoding.utf8)!,withName:"sid")
                    }, to: "\(BASE_URL)mobile/Register/upload", encodingCompletion: { (encodingResult) in
                        print("encodingResult:\(encodingResult)")
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseString{ response in
                                debugPrint(response)
                                print("response:\(response)")
                                print("result:\(response.result)")
                                print("value: \(response.result.value)")
                                if (response.result.value == nil) {
                                    return
                                }
                                var result:Result = Result()
                                var imageUrlEntity:ImageUrlEntity = ImageUrlEntity.deserialize(from: response.result.value as! String) as! ImageUrlEntity
                                if (imageUrlEntity.code != nil && imageUrlEntity.code! == 0) {
                                    result.code = 0
                                    result.message = imageUrlEntity.data
                                } else {
                                    result.code = 1
                                    result.message = "图片上传失败"
                                }
                                observer.onNext(result)
                            }
                        case .failure(let encodingError):
                            print(encodingError)
                        }
                        
                    })
                    return Disposables.create()
                }
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    static func uploadImageUrls(front:String, back:String) -> Observable<Result> {
        //return Observable<Result>.create({ (observer) -> Disposable in
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<Result>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["front":front, "back":back, "sid":sid]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)mobile/Register/uploadClubImage",method:.post,parameters:parameters).responseString{response in
                        print("response:\(response)")
                        print("result:\(response.result)")
                        print("value: \(response.result.value)")
                        if (response.result.value == nil) {
                            return
                        }
                        let responseEntity:ResponseEntity = ResponseEntity.deserialize(from: response.result.value as! String) as! ResponseEntity
                        var result:Result = Result()
                        if (responseEntity.code == 0) {
                            result.code = 0
                            result.message = responseEntity.msg
                        }else {
                            result.code = 1
                        }
                        observer.onNext(result)
                    }
                    return Disposables.create()
                }
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
        
    }
    
    static func getUrl(unionid:String,headimgurl:String, nickname:String,urlHead:String) -> Observable<String>{
        print("urlHead:\(urlHead)")
        //        return Observable<String>.create {
        //            (observer) -> Disposable in
        //            let parameters:Dictionary = ["unionid":unionid,"headimgurl":headimgurl, "nickname":nickname]
        //            Alamofire.request("\(BASE_URL)mobile/wechat/getSid",method:.post,parameters:parameters).responseString{response in
        //                print("value \(response.result.value)")
        //                if (response.result.value == nil) {
        //                    return
        //                }
        //                if let sidEntity = SidEntity.deserialize(from:response.result.value!){
        //                    print("sid \(sidEntity.data!.sid!)")
        //                    observer.onNext(sidEntity.data!.sid!)
        //                }
        //
        //            }
        //            return Disposables.create ()
        //            }
        //return getSid(unionid: unionid, headimgurl: headimgurl, nickname: nickname)
        return Presenter.getSid()
            .map{
                sid in
                Log("url:\(urlHead)\(sid)")
                return "\(urlHead)\(sid)"
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    static func getShopUrl(unionid:String,headimgurl:String, nickname:String) -> Observable<String>{
        return getUrl(unionid:unionid,headimgurl: headimgurl, nickname: nickname, urlHead:"\(BASE_URL)mobile/app/shop?sid=")
    }
    
    static func getManagerUrl(unionid:String,headimgurl:String, nickname:String) -> Observable<String>{
        return getUrl(unionid:unionid, headimgurl: headimgurl, nickname: nickname,urlHead:"\(BASE_URL)mobile/app/manager?sid=")
    }
    
    static func getAreaManagerUrl(unionid:String,headimgurl:String, nickname:String) -> Observable<String>{
        return getUrl(unionid:unionid, headimgurl: headimgurl, nickname: nickname,urlHead:"\(BASE_URL)mobile/app/bazaar_manager?sid=")
    }
    
    static func getMarketManagerUrl(unionid:String,headimgurl:String, nickname:String) -> Observable<String>{
        return getUrl(unionid:unionid, headimgurl: headimgurl, nickname: nickname,urlHead:"\(BASE_URL)mobile/app/area_manager?sid=")
    }
}
