//
//  BoardView.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/10.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class BoardView:UIView {
    var contentImage:UIImageView!
    var contentTitle:UILabel!
    var contentMessage:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
