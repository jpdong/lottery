//
//  CertificateListEntity.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import HandyJSON

class ReceiptListEntity:ResponseEntity {
    var data:ReceiptListInfo?
}

class ReceiptListInfo:HandyJSON {
    var length:Int?
    var list:[ReceiptItem]?
    
    required init() {
        
    }
}
