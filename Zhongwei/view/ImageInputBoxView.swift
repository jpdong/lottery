//
//  ImageInputView.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class ImageInputBoxView:UIView{
    
    var titleLable:UILabel!
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
        titleLable = UILabel()
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        addSubview(titleLable)
        addSubview(imageView)
    }
    
    func setupConstrains() {
        titleLable.snp.makeConstraints { (maker) in
            maker.top.equalTo(self).offset(16)
            maker.left.equalTo(self)
        }
        
        imageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLable.snp.bottom).offset(16)
            maker.right.equalTo(self).offset(-16)
            maker.width.equalTo(231)
            maker.height.equalTo(144)
        }
    }
}
