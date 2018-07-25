//
//  ZhongweiAPI.swift
//  Zhongwei
//
//  Created by eesee on 2018/7/25.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import Moya

let ReceiptAPIProvicer = MoyaProvider<ReceiptAPI>()

public enum ReceiptAPI {
    
    private var sid:String {
        let app = UIApplication.shared.delegate as! AppDelegate
        return app.globalData?.sid ?? ""
    }
    
    case receipts(pageIndex:Int,num:Int)
    case addReceipt(notes:String,imageUrls:Array<String>)
    case editReceipt(notes:String, imageUrls:[String],id:String)
    case getReceipt(id:String)
    case deleteReceipt(id:String)
}

extension ZhongweiAPI:TargetType {
    
    public var baseURL: URL {
        return URL(string: "https://app.api.bjzwhz.cn/")!
    }
    
    public var path: String {
        switch self {
        case .receipts:
            return "app/Lottery_manager/receiptList"
        case .addReceipt:
            return "app/Lottery_manager/addReceipt"
        case .editReceipt:
            return "app/Lottery_manager/modifyReceipt"
        case .getReceipt:
            return "app/Lottery_manager/getReceiptDetail"
        case .deleteReceipt:
            return "app/Lottery_manager/delReceipt"
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
        case .receipts(let pageIndex, let num):
            let parameters:Dictionary = ["sid":sid, "pageIndex":String(pageIndex), "entryNum":String(num)]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        case .addReceipt(let notes, let imageUrls):
            var receiptImagesObject = ReceiptImagesObject()
            receiptImagesObject.image = imageUrls
            var jsonString = receiptImagesObject.toJSONString() as! String
            let parameters:Dictionary = ["sid":sid,"notes":notes, "receipt_image":jsonString]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        case .editReceipt(let notes, let imageUrls, let id):
            var receiptImagesObject = ReceiptImagesObject()
            receiptImagesObject.image = imageUrls
            var jsonString = receiptImagesObject.toJSONString() as! String
            let parameters:Dictionary = ["sid":sid,"notes":notes, "receipt_image":jsonString,"id":id]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        case .getReceipt(let id):
            let parameters:Dictionary = ["sid":sid,"id":id]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        case .deleteReceipt(let id):
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

