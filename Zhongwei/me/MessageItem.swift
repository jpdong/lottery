//
//  MessageItem.swift
//  Zhongwei
//
//  Created by eesee on 2018/1/31.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class MessageItem{
    
    public static let read = 1
    public static let unRead = 2
    
    var title:String?
    var message:String?
    var date:String?
    var type:Int?
    
    init(title:String,date:String) {
        self.title = title
        self.date = date
    }
}
