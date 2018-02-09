//
//  BusinessItem.swift
//  Zhongwei
//
//  Created by eesee on 2018/1/30.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class BusinessItem {
    
    public static let shop = 1
    public static let manager = 2
    public static let areaManager = 3
    public static let marketManager = 4
    
    var title:String?
    var detailUrl:String?
    var type:Int?
    var icon:UIImage?
    
    init(title:String, detailUrl:String) {
        self.title =  title
        self.detailUrl = detailUrl
    }
    
    init(title:String,type:Int) {
        self.title = title
        self.type = type
    }
}
