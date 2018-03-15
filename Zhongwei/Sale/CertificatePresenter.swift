//
//  CertificatePresenter.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import HandyJSON

class CertificatePresenter {
    
    static let app = UIApplication.shared.delegate as! AppDelegate
    static let BASE_URL = app.globalData!.baseUrl
    
    static func getCertificateList(pageIndex:Int, num:Int) ->Observable<CertificateListResult> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<CertificateListResult>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid, "pageIndex":String(pageIndex), "entryNum":String(num)]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)app/Lottery_manager/lotteryList",method:.post,parameters:parameters).responseString{response in
                        print("certificate list")
                        print("value: \(response.result.value)")
                        if (response.result.value == nil) {
                            return
                        }
                        let certificateListEntity:CertificateListEntity = CertificateListEntity.deserialize(from: response.result.value as! String) as! CertificateListEntity
                        var result:CertificateListResult = CertificateListResult()
                        if (certificateListEntity.code == 0) {
                            result.code = 0
                            result.message = certificateListEntity.msg
                            result.list = certificateListEntity.data?.list
                        }else {
                            result.code = 1
                            result.message = certificateListEntity.msg
                        }
                        observer.onNext(result)
                    }
                    return Disposables.create()
                }
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    static func submitCertificate(_ name:String,_ phone:String,_ id:String,_ image:String) ->Observable<Result> {
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
                        let responseEntity:ResponseEntity = ResponseEntity.deserialize(from: response.result.value as! String) as! ResponseEntity
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
