//
//  VisitStateEntity.swift
//  Zhongwei
//
//  Created by eesee on 2018/4/3.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import HandyJSON

class VisitStateEntity:ResponseEntity {
    var data:VisitState?
}

class VisitState:HandyJSON {
    var pass:Bool?
    var url:String?
    
    required init() {
        
    }
}
