//
//  UserPresenter.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/5.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON
import Alamofire

class UserPresenter {
    static let app = UIApplication.shared.delegate as! AppDelegate
    static let BASE_URL = app.globalData!.baseUrl
    
    static func updateMessages() -> Observable<MessageResult> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<MessageResult>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)mobile/msgtip/get_audit_msgtip",method:.post,parameters:parameters).responseString{response in
                        print("response:\(response)")
                        print("result:\(response.result)")
                        print("value: \(response.result.value)")
                        if (response.result.value == nil) {
                            return
                        }
                        let messageEntity:MessageEntity = MessageEntity.deserialize(from: response.result.value as! String) as! MessageEntity
                        var result:MessageResult = MessageResult()
                        if (messageEntity.code == 0) {
                            result.code = 0
                            result.message = messageEntity.msg
                            result.messageList = messageEntity.data
                        }else {
                            result.code = 1
                            result.message = messageEntity.msg
                        }
                        observer.onNext(result)
                    }
                    return Disposables.create()
                }
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
}
