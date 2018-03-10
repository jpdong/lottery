//
//  MainNewsEntity.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/10.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import HandyJSON

class MainNewsEntity:ResponseEntity {
    var data:BridgeData?
}

class BridgeData:HandyJSON{
    var information:ArticleData?
    var activity:ArticleData?
    var news:ArticleData?
    
    required init() {
        
    }
}


