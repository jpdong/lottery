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
    var id:String?
    var lottery_papers:String?
    var lottery_papers_image:String?
    var name:String?
    var phone:String?
    var address:String?
    
    required init() {
        
    }
}
