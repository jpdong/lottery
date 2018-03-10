//
//  SmallboardView.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/9.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class SmallboardView:BoardView{
    
//    var contentImage:UIImageView!
//    var contentTitle:UILabel!
//    var contentMessage:UILabel!
    
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
        contentImage = UIImageView()
        contentImage.contentMode = .scaleAspectFit
        contentTitle = UILabel()
        contentTitle.font = UIFont.systemFont(ofSize:17)
        contentTitle.textAlignment = .center
        contentMessage = UILabel()
        contentMessage.font = UIFont.systemFont(ofSize:10)
        contentMessage.lineBreakMode = .byWordWrapping
        contentMessage.numberOfLines = 0
        addSubview(contentImage)
        addSubview(contentTitle)
        addSubview(contentMessage)
    }
    
    func setupConstrains() {
        contentImage.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self)
            maker.width.height.equalTo(self.snp.height)
            maker.right.equalTo(self)
        }
        
        contentMessage.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentTitle.snp.bottom).offset(10)
            maker.left.equalTo(self).offset(10)
            maker.right.equalTo(contentImage.snp.left)
        }
        contentTitle.snp.makeConstraints { (maker) in
            maker.top.equalTo(self).offset(10)
            maker.left.equalTo(self).offset(10)
        }
    }
}
