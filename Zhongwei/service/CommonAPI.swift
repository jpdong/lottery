//
//  CommonAPI.swift
//  Zhongwei
//
//  Created by eesee on 2018/7/26.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import Moya

let CommonAPIProvicer = MoyaProvider<CommonAPI>()

public enum CommonAPI {
    
    private var sid:String {
        return App.globalData?.sid ?? ""
    }
    
    case sidState
    case versionState(version:String)
    case uploadImage(image:UIImage)
}

extension CommonAPI:TargetType {
    
    public var baseURL: URL {
        return URL(string: "https://app.api.bjzwhz.cn/")!
    }
    
    public var path: String {
        switch self {
        case .sidState:
            return "mobile/Login/checkSidExpire"
        case .versionState:
            return "mobile/App/checkVersion"
        case .uploadImage:
            return "mobile/Register/upload"
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
            
        case .sidState:
            let parameters:Dictionary = ["sid":sid]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        case .versionState(let version):
            let parameters:Dictionary = ["version":version]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        case .uploadImage(let image):
            var datas = Array<MultipartFormData>()
            datas.append(MultipartFormData(provider:.data(UIImageJPEGRepresentation(image,1.0)!),name:"image",fileName:"idcard.png",mimeType:"image/png"))
            datas.append(MultipartFormData(provider:.data(sid.data(using: String.Encoding.utf8)!),name:"sid"))
            return .uploadMultipart(datas)
            
        default:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
}




