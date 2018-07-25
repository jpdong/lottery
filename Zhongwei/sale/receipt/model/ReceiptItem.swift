//
//  CertificateItem.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import HandyJSON

class ReceiptItem :HandyJSON{
    
    static let edit = 1
    static let add = 2
    
    var id:String?
    var createDate:String?
    var notes:String?
    var image:ReceiptImagesObject?
    
    required init() {
        
    }
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.createDate <-- "create_date"
        mapper <<<
            self.image <-- "receipt_image"
    }
}
