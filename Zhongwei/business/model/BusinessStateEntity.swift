//
//  BusinessStateEntity.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/6.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import HandyJSON

class BusinessStateEntity:ResponseEntity {
    var data:BusinessState?
}

class BusinessState:HandyJSON{
    var club:Bool?
    var manager:Bool?
    var areaManager:Bool?
    
    required init() {
        
    }
}
