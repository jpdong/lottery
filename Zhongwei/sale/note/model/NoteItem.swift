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
    var shopId:String?
    var note:String?
    var createDate:String?
    
    required init() {
        
    }
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.shopId <-- "club_id"
        mapper <<<
            self.note <-- "question"
        mapper <<<
            self.createDate <-- "create_date"
    }
}
