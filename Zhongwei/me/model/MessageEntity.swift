//
//  MessageEntity.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/5.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import HandyJSON

class MessageEntity:ResponseEntity {
    
    var data:[Message]?
}

class Message:HandyJSON {
    var type:String?
    var num:String?
    var msg:String?
    var url:String?
    var time:String?
    
    required init() {}
}
