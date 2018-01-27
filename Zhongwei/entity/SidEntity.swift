//
//  SidEntity.swift
//  Zhongwei
//
//  Created by eesee on 2018/1/17.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import HandyJSON

class SidEntity:ResponseEntity{
    var data:Sid?

}
class Sid :HandyJSON{
    var sid:String?
    
    required init() {
        
    }
}
