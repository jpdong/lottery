//
//  Result.swift
//  Zhongwei
//
//  Created by eesee on 2018/2/28.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class Result{
    var code:Int?
    var message:String?
    
    init() {
    }
    
    init(code:Int, message:String) {
        self.code = code
        self.message = message
    }
}
