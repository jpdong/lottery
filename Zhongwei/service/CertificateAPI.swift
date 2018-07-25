//
//  ZhongweiAPI.swift
//  Zhongwei
//
//  Created by eesee on 2018/7/25.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import Moya

let CertificateAPIProvicer = MoyaProvider<CertificateAPI>()

public enum CertificateAPI {
    
    private var sid:String {
        return App.globalData?.sid ?? ""
    }
    
    case certificates(pageIndex:Int,num:Int)
    case addCertificate(name:String,phone:String,id:String,image:String)
    case editCertificate(name:String,phone:String,cardId:String,imageUrl:String,itemId:String)
    case getCertificate(id:String)
    case deleteCertificate(id:String)
}

extension CertificateAPI:TargetType {
    
    public var baseURL: URL {
        return URL(string: "https://app.api.bjzwhz.cn/")!
    }
    
    public var path: String {
        switch self {
        case .certificates:
            return "app/Lottery_manager/lotteryList"
        case .addCertificate:
            return "app/Lottery_manager/lotteryBind"
        case .editCertificate:
            return "app/Lottery_manager/modifyLotteryBind"
        case .getCertificate:
            return "app/Lottery_manager/getLotteryDetail"
        case .deleteCertificate:
            return "app/Lottery_manager/delLottery"
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
        case .certificates(let pageIndex, let num):
            let parameters:Dictionary = ["sid":sid, "pageIndex":String(pageIndex), "entryNum":String(num)]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        case .addCertificate(let name, let phone, let id, let image):
            let parameters:Dictionary = ["sid":sid,"name":name,"phone":phone, "lottery_papers":id, "lottery_papers_image":image]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        case .editCertificate(let name, let phone, let cardId, let imageUrl, let itemId):
            let parameters:Dictionary = ["sid":sid,"name":name,"phone":phone, "lottery_papers":cardId, "lottery_papers_image":imageUrl,"id":itemId]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        case .getCertificate(let id):
            let parameters:Dictionary = ["sid":sid,"id":id]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        case .deleteCertificate(let id):
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

