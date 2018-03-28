//
//  NotePresenter.swift
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

class NotePresenter {
    
    static let app = UIApplication.shared.delegate as! AppDelegate
    static let BASE_URL = app.globalData!.baseUrl
    
    static func getNoteList(pageIndex:Int, num:Int,shopId:String) ->Observable<NoteListResult> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<NoteListResult>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid, "pageIndex":String(pageIndex), "entryNum":String(num),"club_id":shopId]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)app/Lottery_manager/interviewLogList",method:.post,parameters:parameters).responseString{response in
                        print("Note list")
                        print("value: \(response.result.value)")
                        
                        var result:NoteListResult = NoteListResult()
                        switch response.result {
                        case .success:
                            guard let noteListEntity:NoteListEntity = NoteListEntity.deserialize(from: response.result.value as! String) as? NoteListEntity else {
                                result.code = 1
                                result.message = "服务器错误"
                                observer.onNext(result)
                                return
                            }
                            
                            if (noteListEntity.code == 0) {
                                result.code = 0
                                result.message = noteListEntity.msg
                                result.list = noteListEntity.data?.list
                            }else {
                                result.code = 1
                                result.message = noteListEntity.msg
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
    
    static func submitNote(note:String,shopId:String) ->Observable<Result> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<Result>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid,"club_id":shopId,"question":note]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)app/Lottery_manager/addInterviewLog",method:.post,parameters:parameters).responseString{response in
                        print("submit ")
                        print("value: \(response.result.value)")
                        if (response.result.value == nil) {
                            return
                        }
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
    
    static func editNote(note:String, noteId:String) ->Observable<Result> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<Result>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid,"id":noteId,"question":note]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)app/Lottery_manager/modifyInterviewLog",method:.post,parameters:parameters).responseString{response in
                        print("edit ")
                        print("value: \(response.result.value)")
                        if (response.result.value == nil) {
                            return
                        }
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
    
    static func getDetailWithId(_ id:String) ->Observable<NoteResult> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<NoteResult>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid,"id":id]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)app/Lottery_manager/getInterviewLogDetail",method:.post,parameters:parameters).responseString{response in
                        print("detai id ")
                        print("value: \(response.result.value)")
                        
                        var result:NoteResult = NoteResult()
                        switch response.result {
                        case .success:
                            guard let noteEntity:NoteEntity = NoteEntity.deserialize(from: response.result.value as! String) as? NoteEntity else {
                                result.code = 1
                                result.message = "服务器错误"
                                observer.onNext(result)
                                return
                            }
                            
                            if (noteEntity.code == 0) {
                                result.code = 0
                                result.message = noteEntity.msg
                                result.data = noteEntity.data
                            }else {
                                result.code = 1
                                result.message = noteEntity.msg
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
    
    static func deleteNote(id:String) ->Observable<Result> {
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<Result>.create {
                    observer -> Disposable in
                    let parameters:Dictionary = ["sid":sid,"id":id]
                    print("parameters:\(parameters)")
                    Alamofire.request("\(BASE_URL)delInterviewLog",method:.post,parameters:parameters).responseString{response in
                        print("delete id ")
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
