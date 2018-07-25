//
//  File.swift
//  Zhongwei
//
//  Created by eesee on 2018/1/17.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import HandyJSON

class ResponseEntity:HandyJSON{
    var code:Int?
    var msg:String?
    
    required init() {
        
    }
}
