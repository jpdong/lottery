//
//  NoteItem.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import HandyJSON

class NoteItem :HandyJSON{
    
    static let edit = 1
    static let add = 2
    
    var id:String?
    var user_id:String?
    var club_id:String?
    var question:String?
    var create_date:String?
    var update_date:String?
    
    required init() {
        
    }
}
