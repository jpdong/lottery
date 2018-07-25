//
//  GalleryAPI.swift
//  Zhongwei
//
//  Created by eesee on 2018/7/25.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

//
//  ZhongweiAPI.swift
//  Zhongwei
//
//  Created by eesee on 2018/7/25.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import Moya

let GalleryAPIProvicer = MoyaProvider<GalleryAPI>()

public enum GalleryAPI {
    
    private var sid:String {
        return App.globalData?.sid ?? ""
    }
    
    case images(pageIndex:Int,num:Int,shopId:String)
    case addImage(shopId:String, imageUrl:String)
}

extension GalleryAPI:TargetType {
    
    public var baseURL: URL {
        return URL(string: "https://app.api.bjzwhz.cn/")!
    }
    
    public var path: String {
        switch self {
        case .images:
            return "app/Lottery_manager/interviewImagesList"
        case .addImage:
            return "app/Lottery_manager/addInterviewImages"
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
        case .images(let pageIndex, let num,let shopId):
            let parameters:Dictionary = ["sid":sid, "pageIndex":String(pageIndex), "entryNum":String(num),"club_id":shopId]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        case .addImage(let shopId, let imageUrl):
            var receiptImagesObject = ReceiptImagesObject()
            var imageUrls = [String]()
            imageUrls.append(imageUrl)
            receiptImagesObject.image = imageUrls
            var jsonString = receiptImagesObject.toJSONString() as! String
            let parameters:Dictionary = ["sid":sid,"club_id":shopId, "images":jsonString]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        default:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
}


