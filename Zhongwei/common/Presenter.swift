//
//  Presenter.swift
//  Zhongwei
//
//  Created by eesee on 2018/1/17.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import Toaster

class Presenter{
    
    var app:AppDelegate!
    var baseUrl = ""
    
    public init() {
        app = UIApplication.shared.delegate as! AppDelegate
        self.baseUrl = app.globalData!.baseUrl
    }
    
//    func getSid(unionid:String,headimgurl:String, nickname:String)  -> Observable<String>{
//        return Observable<String>.create {
//            (observer) -> Disposable in
//            let parameters:Dictionary = ["unionid":unionid,"headimgurl":headimgurl, "nickname":nickname]
//            Alamofire.request("\(self.baseUrl)mobile/app/getSid",method:.post,parameters:parameters).responseString{response in
//                print("value \(response.result.value)")
//                var result = ""
//                switch response.result {
//                case .success:
//                    if let sidEntity = SidEntity.deserialize(from:response.result.value!) as? SidEntity {
//                        if let sid = sidEntity.data?.sid{
//                            result = sid
//                        } else {
//                            result = ""
//                        }
//                    } else {
//                        result = ""
//                        return
//                    }
//                case .failure(let error):
//                    result = ""
//                }
//                observer.onNext(result)
//                observer.onCompleted()
//            }
//            return Disposables.create ()
//        }
//    }
    
    func getSid() -> Observable<String> {
        return Observable<String>.create({ (observer) -> Disposable in
            let sid = self.app.globalData?.sid
            observer.onNext(sid ?? "")
            observer.onCompleted()
            return Disposables.create()
        })
    }
   
    func checkSid(sid:String) -> Observable<Result> {
        return Observable<Result>.create({ (observer) -> Disposable in
            CommonAPIProvicer.request(.sidState, completion: { (response) in
                var result:Result = Result()
                switch response {
                case .success(let value):
                    guard let responseEntity = ResponseEntity.deserialize(from: value.data.toString()) as? ResponseEntity else {
                        result.code = 1
                        result.message = "服务器错误"
                        observer.onNext(result)
                        return
                    }
                    if (responseEntity.code == 0) {
                        result.code = 0
                        result.message = responseEntity.msg
                    } else {
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
        })
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    func checkAppUpdate() -> Observable<AppUpdateResult> {
        return Observable<AppUpdateResult>.create({ (observer) -> Disposable in
            let infoDictionary = Bundle.main.infoDictionary!
            let majorVersion = infoDictionary["CFBundleShortVersionString"]
            let version = majorVersion as! String
            CommonAPIProvicer.request(.versionState(version:version), completion: { (response) in
                var result:AppUpdateResult = AppUpdateResult()
                switch response {
                case .success(let value):
                    guard let appUpdateEntity = AppUpdateEntity.deserialize(from: value.data.toString()) as? AppUpdateEntity else {
                        result.code = 1
                        result.message = "服务器错误"
                        observer.onNext(result)
                        return
                    }
                    
                    if (appUpdateEntity.code == 0) {
                        result.code = 0
                        result.message = appUpdateEntity.msg
                        result.version = appUpdateEntity.data?.version
                        result.forceUpdate = appUpdateEntity.data?.compel
                        if (version == result.version) {
                            result.update = false
                        } else {
                            result.update = true
                        }
                        
                    } else {
                        result.code = 1
                        result.message = appUpdateEntity.msg
                    }
                case .failure(let error):
                    result.code = 1
                    result.message = "网络错误"
                }
                observer.onNext(result)
                observer.onCompleted()
            })
            return Disposables.create()
        })
        .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    func uploadImage(image:UIImage) -> Observable<Result> {
        return Observable<Result>.create { observer -> Disposable in
            CommonAPIProvicer.request(.uploadImage(image:image), completion: { (response) in
                var result:Result = Result()
                switch response {
                case .success(let value):
                    guard let imageUrlEntity:ImageUrlEntity = ImageUrlEntity.deserialize(from: value.data.toString()) as? ImageUrlEntity else {
                        result.code = 1
                        result.message = "服务器错误"
                        observer.onNext(result)
                        observer.onCompleted()
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
                
                observer.onNext(result)
                observer.onCompleted()
            })
            
//                    Alamofire.upload(multipartFormData: { (multipartFormData) in
//                        multipartFormData.append(UIImageJPEGRepresentation(image,1.0)!,withName:"image",fileName:"idcard.png",mimeType:"image/png")
//                        multipartFormData.append(sid.data(using: String.Encoding.utf8)!,withName:"sid")
//                    }, to: "\(self.baseUrl)mobile/Register/upload", encodingCompletion: { (encodingResult) in
//                        print("encodingResult:\(encodingResult)")
//                        switch encodingResult {
//                        case .success(let upload, _, _):
//                            upload.responseString{ response in
//                                debugPrint(response)
//                                print("response:\(response)")
//                                print("value: \(response.result.value)")
//
//                                var result:Result = Result()
//                                switch response.result {
//                                case .success:
//                                    guard let imageUrlEntity:ImageUrlEntity = ImageUrlEntity.deserialize(from: response.result.value as! String) as? ImageUrlEntity else {
//                                        result.code = 1
//                                        result.message = "服务器错误"
//                                        observer.onNext(result)
//                                        observer.onCompleted()
//                                        return
//                                    }
//                                    if (imageUrlEntity.code != nil && imageUrlEntity.code! == 0) {
//                                        result.code = 0
//                                        result.message = imageUrlEntity.data
//                                    } else {
//                                        result.code = 1
//                                        result.message = "图片上传失败"
//                                    }
//                                case .failure(let error):
//                                    result.code = 1
//                                    result.message = "网络错误"
//                                }
//
//                                observer.onNext(result)
//                                observer.onCompleted()
//                            }
//                        case .failure(let encodingError):
//                            print(encodingError)
//                        }
//
//                    })
                    return Disposables.create()
                }
            
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos:.userInitiated))
    }
}
