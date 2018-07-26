//
//  BusinessAPI.swift
//  Zhongwei
//
//  Created by eesee on 2018/7/26.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import Moya

let BusinessAPIProvicer = MoyaProvider<BusinessAPI>()

public enum BusinessAPI {
    
    private var sid:String {
        return App.globalData?.sid ?? ""
    }
    
    case businessState
    case addLicense(front:String, back:String, tobacco:String,business:String)
}

extension BusinessAPI:TargetType {
    
    public var baseURL: URL {
        return URL(string: "https://app.api.bjzwhz.cn/")!
    }
    
    public var path: String {
        switch self {
        case .businessState:
            return "mobile/app/judeIdent"
        case .addLicense:
            return "mobile/Register/uploadClubImage"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .businessState:
            return .get
        default:
            return .post
        }
    }
    
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        switch self {
            
        case .businessState:
            let parameters:Dictionary = ["sid":sid]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        case .addLicense(let front, let back, let tobacco, let business):
            let parameters:Dictionary = ["front":front, "back":back, "sid":sid, "yan_code":tobacco,"business_license":business]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        default:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
}




