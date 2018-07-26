//
//  HomeAPI.swift
//  Zhongwei
//
//  Created by eesee on 2018/7/26.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import Moya

let HomeAPIProvicer = MoyaProvider<HomeAPI>()

public enum HomeAPI {
    
    private var sid:String {
        return App.globalData?.sid ?? ""
    }
    
    case boardContents
    case bannerImages
    case getMaterial(id:String)
}

extension HomeAPI:TargetType {
    
    public var baseURL: URL {
        return URL(string: "https://app.api.bjzwhz.cn/")!
    }
    
    public var path: String {
        switch self {
        case .boardContents:
            return "mobile/Contents/getContent"
        case .bannerImages:
            return "mobile/Contents/getBanner"
        case .getMaterial:
            return "mobile/Contents/getArticle"
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
            
        case .getMaterial(let id):
            let parameters:Dictionary = ["id":id]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        default:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
}



