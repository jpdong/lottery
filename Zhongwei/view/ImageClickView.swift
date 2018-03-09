//
//  ImageClickView.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/8.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import SnapKit

class ImageClickView:UIView{
    
    var contentImage:UIImageView!
    var contentTitle:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        contentImage = UIImageView()
        contentImage.contentMode = .scaleAspectFit
        contentTitle = UILabel()
        contentTitle.font = UIFont.systemFont(ofSize:10)
        contentTitle.textAlignment = .center
        addSubview(contentImage)
        addSubview(contentTitle)
        setupConstrains()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentImage = UIImageView()
        contentImage.contentMode = .scaleAspectFit
        contentTitle = UILabel()
        contentTitle.font = UIFont.systemFont(ofSize:10)
        contentTitle.textAlignment = .center
        addSubview(contentImage)
        addSubview(contentTitle)
        setupConstrains()
    }
    
    func setupConstrains() {
        contentImage.snp.makeConstraints { (maker) in
            maker.width.equalTo(self)
            maker.top.equalTo(self)
            maker.height.equalTo(50)
            maker.left.right.equalTo(self)
        }
        contentTitle.snp.makeConstraints { (maker) in
            maker.width.equalTo(self)
            maker.top.equalTo(contentImage.snp.bottom).offset(10)
            maker.left.right.equalTo(self)
        }
    }
}
