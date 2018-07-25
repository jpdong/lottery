//
//  VisitRecordAPI.swift
//  Zhongwei
//
//  Created by eesee on 2018/7/25.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import Moya

let VisitAPIProvicer = MoyaProvider<VisitRecordAPI>()

public enum VisitRecordAPI {
    
    private var sid:String {
        return App.globalData?.sid ?? ""
    }
    
    case visitRecords(pageIndex:Int,num:Int)
    case sign(longitude:Double, latitude:Double, status:Int, shopId:String)
    case visitManagerState
}

extension VisitRecordAPI:TargetType {
    
    public var baseURL: URL {
        return URL(string: "https://app.api.bjzwhz.cn/")!
    }
    
    public var path: String {
        switch self {
        case .visitRecords:
            return "app/lottery/lottery_record"
        case .sign:
            return "app/lottery/sign"
        case .visitManagerState:
            return "mobile/app/lottery_manager"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        default:
            return .post
        }
    }
    
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        switch self {
        case .visitRecords(let pageIndex, let num):
            let parameters:Dictionary = ["sid":sid, "pageIndex":String(pageIndex), "entryNum":String(num)]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        case .sign(let longitude, let latitude, let status, let shopId):
            let parameters:Dictionary = ["sid":sid, "long":String(longitude), "lat":String(latitude), "status":String(status),"club_id":shopId]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        case .visitManagerState:
            let parameters:Dictionary = ["sid":sid]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        default:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
}


