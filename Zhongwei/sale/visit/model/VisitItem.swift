//
//  CertificateItem.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import HandyJSON

class VisitItem :HandyJSON{
    
    
    var name:String?
    var shopId:String?
    var shopName:String?
    var beginTime:String?
    var endTime:String?
    
    required init() {
        
    }
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.shopId <-- "club_id"
        mapper <<<
            self.shopName <-- "club_name"
        mapper <<<
            self.beginTime <-- "begin_timestamp"
        mapper <<<
            self.endTime <-- "end_timestamp"
    }
}
