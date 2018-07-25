//
//  CertificateListEntity.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import HandyJSON

class ShopListEntity:ResponseEntity {
    var data:ShopListInfo?
}

class ShopListInfo:HandyJSON {
    var length:Int?
    var list:[ShopItem]?
    
    required init() {
        
    }
}
