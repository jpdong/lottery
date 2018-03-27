//
//  SignButtonView.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/26.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class SignButtonView:UIView {
    
    var titleLabel:UILabel!
    var timeLabel:UILabel!
    var backgroundImage:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstrains()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupConstrains()
    }
    
    func setupViews() {
        backgroundImage = UIImageView(image:UIImage(named:"background_sign"))
        backgroundImage.contentMode = .scaleAspectFit
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.text = "到店打卡"
        timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 15)
        timeLabel.text = "00:00:04"
        addSubview(backgroundImage)
        addSubview(titleLabel)
        addSubview(timeLabel)
        
    }
    
    func setupConstrains() {
        titleLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self).offset(-8)
            maker.centerX.equalTo(self)
        }
        timeLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self).offset(8)
            maker.centerX.equalTo(self)
        }
        backgroundImage.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self)
        }
    }
}
