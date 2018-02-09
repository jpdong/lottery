//
//  PrizeEntity.swift
//  Zhongwei
//
//  Created by eesee on 2018/2/7.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import HandyJSON

class PrizeEntity:ResponseEntity{
    var data:String?
}

class PrizeData: HandyJSON{
    var content:ContentData?
    var ret:String?
    var msg:String?
    var success:String?
    
    required init() {
        
    }
}

class ContentData:HandyJSON{
    var transacId:String?
    var ticketNo:String?
    var gameName:String?
    var prize:String?
    
    required init(){
        
    }
}
