//
//  ImageInputView.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class ImageInputBoxView:UIView{
    
    var titleLabel:UILabel!
    var imageView:UIImageView!
    
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
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        addSubview(titleLabel)
        addSubview(imageView)
    }
    
    func setupConstrains() {
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self).offset(16)
            maker.left.equalTo(self)
        }
        
        imageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(16)
            maker.right.equalTo(self)
            maker.width.equalTo(231)
            maker.height.equalTo(144)
        }
    }
}
