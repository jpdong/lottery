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
    
    static let edit = 1
    static let add = 2
    
    var id:String?
    var create_date:String?
    var notes:String?
    var visit_image:VisitImagesObject?
    
    required init() {
        
    }
}