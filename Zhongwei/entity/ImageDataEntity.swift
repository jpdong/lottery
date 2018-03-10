//
//  ImageDataEntity.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/10.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import HandyJSON

class ImageDataEntity:ResponseEntity {
    var data:[ImageData]?
}

class ImageData:HandyJSON {
    
    var image:String?
    
    required init() {
        
    }
}
