//
//  UserAPI.swift
//  Zhongwei
//
//  Created by eesee on 2018/7/26.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import Moya

let UserAPIProvicer = MoyaProvider<UserAPI>()

public enum UserAPI {
    
    private var sid:String {
        return App.globalData?.sid ?? ""
    }
    
    case notifications
    case sendSMSCode(phone:String)
    case register(phone:String, password:String, code:String)
    case passwordLogin(phone:String, password:String)
    case smsLogin(phone:String, code:String)
}

extension UserAPI:TargetType {
    
    public var baseURL: URL {
        return URL(string: App.globalData?.baseUrl ?? "")!
    }
    
    public var path: String {
        switch self {
        case .notifications:
            return "mobile/msgtip/get_audit_msgtip"
        case .sendSMSCode:
            return "mobile/wechat/ajaxSend"
        case .register:
            return "mobile/Register/appUserRegister"
        case .passwordLogin:
            return "mobile/Login/doLogin"
        case .smsLogin:
            return "mobile/Login/doLoginByCode"
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
        case .notifications:
            let parameters:Dictionary = ["sid":sid]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        case .sendSMSCode(let phone):
            let parameters:Dictionary = ["mobile":phone]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        case .register(let phone, let password, let code):
            let parameters:Dictionary = ["phone":phone, "password":password, "password2":password, "code":code]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        case .passwordLogin(let phone, let password):
            let parameters:Dictionary = ["phone":phone, "password":password]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        case .smsLogin(let phone, let code):
            let parameters:Dictionary = ["phone":phone, "code":code]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        default:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
}




