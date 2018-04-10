//
//  ReceiptImagesObject.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/21.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import HandyJSON

class ReceiptImagesObject:HandyJSON {
    var image:[String]?
    
    required init() {
        
    }
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.image <-- "receipt_image"
    }
}
