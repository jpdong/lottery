//
//  CertificateListEntity.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import HandyJSON

class VisitListEntity:ResponseEntity {
    var data:VisitListInfo?
}

class VisitListInfo:HandyJSON {
    var length:Int?
    var list:[VisitItem]?
    
    required init() {
        
    }
}
