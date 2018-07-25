//
//  CertificateItem.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import HandyJSON

class CertificateItem :HandyJSON{
    
    static let edit = 1
    static let add = 2
    
    var id:String?
    var certificateId:String?
    var certificateImage:String?
    var name:String?
    var phone:String?
    var address:String?
    
    required init() {
        
    }
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.certificateId <-- "lottery_papers"
        mapper <<<
            self.certificateImage <-- "lottery_papers_image"
    }
}
