//
//  AppUpdateEntity.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/12.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import HandyJSON

class AppUpdateEntity:ResponseEntity {
    var data:UpdataInfo?
}

class UpdataInfo:HandyJSON {
    var version:String?
    var compel:Bool?
    
    required init() {
        
    }
}
