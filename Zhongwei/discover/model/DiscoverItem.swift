//
//  DiscoverItem.swift
//  Zhongwei
//
//  Created by eesee on 2018/1/25.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class DiscoverItem {
    
    public static let show = 1
    public static let scan = 2
    
    var icon:UIImage?
    var title:String?
    var detailUrl:String?
    var operation = 1
    
    init(title:String,operation:Int) {
        self.title = title
        self.operation = operation
    }
    
    init(title:String, detailUrl:String,operation:Int){
        self.title = title
        self.detailUrl = detailUrl
        self.operation = operation
    }
}

enum PageFunction{
    case show
    case scan
}
