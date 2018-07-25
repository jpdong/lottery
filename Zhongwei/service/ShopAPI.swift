//
//  ShopAPI.swift
//  Zhongwei
//
//  Created by eesee on 2018/7/25.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import Moya

let ShopAPIProvicer = MoyaProvider<ShopAPI>()

public enum ShopAPI {
    
    private var sid:String {
        return App.globalData?.sid ?? ""
    }
    
    case shops(pageIndex:Int,num:Int,key:String)
    case getShop(id:String)
}

extension ShopAPI:TargetType {
    
    public var baseURL: URL {
        return URL(string: "https://app.api.bjzwhz.cn/")!
    }
    
    public var path: String {
        switch self {
        case .shops:
            return "app/lottery/sendclub"
        case .getShop:
            return "app/lottery/club_detail"
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
        case .shops(let pageIndex, let num,let key):
            let parameters:Dictionary = ["sid":sid, "pageIndex":String(pageIndex), "entryNum":String(num), "search":key]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        case .getShop(let id):
            let parameters:Dictionary = ["sid":sid,"id":id]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        default:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
}


