//
//  CertificateListEntity.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import HandyJSON

class GalleryListEntity:ResponseEntity {
    var data:[GalleryListInfo]?
}

class GalleryListInfo:HandyJSON {
    
    var list:GalleryList?
    
    required init() {
        
    }
}

class GalleryList:HandyJSON {
    
    required init() {
        
    }
}
