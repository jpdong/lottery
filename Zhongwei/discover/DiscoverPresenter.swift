//
//  DiscoverPresenter.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/6.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import HandyJSON

class DiscoverPresenter{
    
    static let app = UIApplication.shared.delegate as! AppDelegate
    static let BASE_URL = app.globalData!.baseUrl
    
    static func getPrizeRecordUrl() -> Observable<String>{
        var unionid = app.globalData!.unionid
        var headImgUrl = app.globalData!.headImgUrl
        var nickName = app.globalData!.nickName
        //return getSid(unionid: unionid, headimgurl: headImgUrl, nickname: nickName)
        return Presenter.getSid()
            .map{ sid in
                let now = Date()
                let timeInterval:TimeInterval = now.timeIntervalSince1970 * 1000
                let timeStamp = Int(timeInterval)
                return "\(BASE_URL)resources/app/scan-qr-code/redeem-record.html?\(timeStamp)=&sid=\(sid)"
        }
    }
    
    
    static func getPrizeData(code:String)  -> Observable<AlertData>{
        var unionid = app.globalData!.unionid
        var headImgUrl = app.globalData!.headImgUrl
        var nickName = app.globalData!.nickName
        //return getSid(unionid: unionid, headimgurl: headImgUrl, nickname: nickName)
        return Presenter.getSid()
            .flatMap{
                sid in
                return Observable<AlertData>.create {
                    observer -> Disposable in
                    var result = "a"
                    Alamofire.request("\(BASE_URL)mobile/Redeem/doRedeem?sid=\(sid)&code=\(code)").responseString{
                        response in
                        print("prize value \(response.result.value)")
                        if (response.result.value == nil) {
                            return
                        }
                        print("response.result.value : \(response.result.value as! String)")
                        var alertData = AlertData()
                        var message = ""
                        var title = ""
                        if let prizeEntity = PrizeEntity.deserialize(from: response.result.value as! String) {
                            print("prizeEntity:\(prizeEntity)")
                            if (prizeEntity.code != 200) {
                                title = prizeEntity.msg!
                            } else {
                                let dataString = prizeEntity.data as! String
                                print("dataString:\(dataString)")
                                if let prizeData = PrizeData.deserialize(from: dataString){
                                    if (prizeData.ret == "1307" || prizeData.ret == "1305") {
                                        title = prizeData.msg as! String
                                        var type = prizeData.content?.gameName as! String
                                        var time = getTimeStamp(timeString:prizeData.content?.transacId as! String)
                                        var ticketNo = prizeData.content?.ticketNo as! String
                                        message = "兑换票种：\(type)\n扫码时间：\(time)\n兑奖单号：\(ticketNo)"
                                    } else if (prizeData.ret == "1301") {
                                        title = "兑奖成功，奖金\(prizeData.content!.prize)元"
                                        var type = prizeData.content?.gameName as! String
                                        var time = getTimeStamp(timeString:prizeData.content?.transacId as! String)
                                        var ticketNo = prizeData.content?.ticketNo as! String
                                        message = "兑换票种：\(type)\n扫码时间：\(time)\n兑奖单号：\(ticketNo)"
                                    } else {
                                        title = prizeData.msg as! String
                                    }
                                }
                            }
                            alertData.title = title
                            alertData.message = message
                            print("result:\(result)")
                            //result = response.result.value!
                            observer.onNext(alertData)
                        }
                    }
                    return Disposables.create()
                }
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos:.userInitiated))
    }
    
    
    static func getTimeStamp(timeString:String) -> String{
        return "\(subString(timeString, 0, 3))-\(subString(timeString, 4, 5))-\(subString(timeString, 6, 7)) \(subString(timeString, 8, 9)):\(subString(timeString, 10, 11)):\(subString(timeString, 12, 13))"
    }
    
    static func subString(_ str:String,_  start:Int,_ end:Int) -> String{
        let startIndex = str.startIndex
        return String(str[str.index(startIndex, offsetBy: start)...str.index(startIndex, offsetBy: end)])
    }
}
