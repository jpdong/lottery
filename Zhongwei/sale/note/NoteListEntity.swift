//
//  CertificateListEntity.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import HandyJSON

class NoteListEntity:ResponseEntity {
    var data:NoteListInfo?
}

class NoteListInfo:HandyJSON {
    var length:Int?
    var list:[NoteItem]?
    
    required init() {
        
    }
}
