//
//  CertificateListEntity.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import HandyJSON

class CertificateListEntity:ResponseEntity {
    var data:ListInfo?
}

class ListInfo:HandyJSON {
    var length:Int?
    var list:[CertificateItem]?
    
    required init() {
        
    }
}
