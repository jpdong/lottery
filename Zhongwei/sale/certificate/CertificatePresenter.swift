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
import Toaster

class CertificatePresenter:Presenter {
    
    func getCertificateList(pageIndex:Int, num:Int) ->Observable<CertificateListResult> {
        return Observable<CertificateListResult>.create { observer -> Disposable in
            CertificateAPIProvicer.request(.certificates(pageIndex:pageIndex,num:num), completion: { (response) in
                var result:CertificateListResult = CertificateListResult()
                switch response {
                case .success(let value):
                    guard let certificateListEntity:CertificateListEntity = CertificateListEntity.deserialize(from: value.data.toString()) as? CertificateListEntity else {
                        result.code = 1
                        result.message = "服务器错误"
                        observer.onNext(result)
                        observer.onCompleted()
                        return
                    }
                    if (certificateListEntity.code == 0) {
                        result.code = 0
                        result.message = certificateListEntity.msg
                        result.list = certificateListEntity.data?.list
                    }else {
                        result.code = 1
                        result.message = certificateListEntity.msg
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
    
    func submitCertificate(_ name:String,_ phone:String,_ id:String,_ image:String) ->Observable<Result> {
        return Observable<Result>.create { observer -> Disposable in
            CertificateAPIProvicer.request(.addCertificate(name:name,phone:phone,id:id,image:image), completion: { (response) in
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
    
    func editCertificate(_ name:String,_ phone:String,_ cardId:String,_ imageUrl:String,_ itemId:String) ->Observable<Result> {
        return Observable<Result>.create { observer -> Disposable in
            CertificateAPIProvicer.request(.editCertificate(name:name,phone:phone,cardId:cardId,imageUrl:imageUrl,itemId:itemId), completion: { (response) in
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
    
    func getDetailWithId(_ id:String) ->Observable<CertificateResult> {
        return Observable<CertificateResult>.create { observer -> Disposable in
            CertificateAPIProvicer.request(.getCertificate(id:id), completion: { (response) in
                var result:CertificateResult = CertificateResult()
                switch response {
                case .success(let value):
                    guard let certificateEntity:CertificateEntity = CertificateEntity.deserialize(from: value.data.toString()) as? CertificateEntity else {
                        result.code = 1
                        result.message = "服务器错误"
                        observer.onNext(result)
                        observer.onCompleted()
                        return
                    }
                    if (certificateEntity.code == 0) {
                        result.code = 0
                        result.message = certificateEntity.msg
                        result.data = certificateEntity.data
                    }else {
                        result.code = 1
                        result.message = certificateEntity.msg
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
    
    func deleteCertificate(id:String) ->Observable<Result> {
        return Observable<Result>.create {observer -> Disposable in
            CertificateAPIProvicer.request(.deleteCertificate(id:id), completion: { (response) in
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
