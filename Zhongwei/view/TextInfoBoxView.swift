//
//  TextInfoBox.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class TextInfoBoxView:UIView {
    
    var titleLabel:UILabel!
    var messageLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupViews()
        setupConstrains()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupConstrains()
    }
    
    func setupViews() {
        titleLabel = UILabel()
        messageLabel = UILabel()
        addSubview(titleLabel)
        addSubview(messageLabel)
    }
    
    func setupConstrains() {
        titleLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self)
            maker.left.equalTo(self)
            maker.width.equalTo(70)
        }
        
        messageLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self)
            maker.left.equalTo(titleLabel.snp.right).offset(10)
            maker.right.equalTo(self)
        }
    }
}
