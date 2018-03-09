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
    
    static func getRecentNews() -> Observable<String>{
        return getPage(type: "information")
    }

    static func getPage(type:String) -> Observable<String>{
        return Observable<String>.create{
            observer -> Disposable in
            let parameters:Dictionary = ["type":type]
            print("parameters:\(parameters)")
            Alamofire.request("\(BASE_URL)mobile/Contents/getContent",method:.post,parameters:parameters).responseString{response in
                print("response:\(response)")
                print("result:\(response.result)")
                print("value: \(response.result.value)")
                
                
            }
            return Disposables.create()
            }
            .flatMap{
                id in
                return Observable<String>.create {
                    observer -> Disposable in
//                    Alamofire.request("\(BASE_URL)mobile/app/judeIdent?sid=\(sid)").responseString{response in
//                        print("response:\(response)")
//                        print("result:\(response.result)")
//                        print("value: \(response.result.value)")
//                        if (response.result.value == nil) {
//                            return
//                        }
//                        let businessStateEntity:BusinessStateEntity = BusinessStateEntity.deserialize(from: response.result.value as! String) as! BusinessStateEntity
//                        var result:Result = Result()
//                        if (businessStateEntity.code == 200) {
//                            if (businessStateEntity.data!.club!){
//                                result.code = 0
//                            }else {
//                                result.code = 1
//                            }
//                            observer.onNext(result)
//                        }
//                    }
                    return Disposables.create()
                }
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
}
