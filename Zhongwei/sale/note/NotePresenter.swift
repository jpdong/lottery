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

class NotePresenter:Presenter {
    
    func getNoteList(pageIndex:Int, num:Int,shopId:String) ->Observable<NoteListResult> {
        return Observable<NoteListResult>.create { observer -> Disposable in
            NoteAPIProvicer.request(.notes(pageIndex:pageIndex,num:num,shopId:shopId), completion: { (response) in
                var result:NoteListResult = NoteListResult()
                switch response {
                case .success(let value):
                    guard let noteListEntity:NoteListEntity = NoteListEntity.deserialize(from: value.data.toString()) as? NoteListEntity else {
                        result.code = 1
                        result.message = "服务器错误"
                        observer.onNext(result)
                        observer.onCompleted()
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
                observer.onCompleted()
            })
            return Disposables.create()
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    func submitNote(note:String,shopId:String) ->Observable<Result> {
        return Observable<Result>.create { observer -> Disposable in
            NoteAPIProvicer.request(.addNote(note:note,shopId:shopId), completion: { (response) in
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
    
    func editNote(note:String, noteId:String) ->Observable<Result> {
        return Observable<Result>.create { observer -> Disposable in
            NoteAPIProvicer.request(.editNote(note:note,noteId:noteId), completion: { (response) in
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
    
    func getDetailWithId(_ id:String) ->Observable<NoteResult> {
        return Observable<NoteResult>.create { observer -> Disposable in
            NoteAPIProvicer.request(.getNote(id:id), completion: { (response) in
                var result:NoteResult = NoteResult()
                switch response {
                case .success(let value):
                    guard let noteEntity:NoteEntity = NoteEntity.deserialize(from: value.data.toString()) as? NoteEntity else {
                        result.code = 1
                        result.message = "服务器错误"
                        observer.onNext(result)
                        observer.onCompleted()
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
                observer.onCompleted()
            })
            return Disposables.create()
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    func deleteNote(id:String) ->Observable<Result> {
        return Observable<Result>.create { observer -> Disposable in
            NoteAPIProvicer.request(.deleteNote(id:id), completion: { (response) in
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
