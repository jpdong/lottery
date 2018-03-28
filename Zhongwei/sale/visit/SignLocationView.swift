//
//  SignLocationView.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/26.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class SignLocationView:UIView {
    
    var titleLable:UILabel!
    var updateLocationButton:UILabel!
    
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
        titleLable = UILabel()
        titleLable.font = UIFont.systemFont(ofSize: 15)
        titleLable.text = "打卡位置"
        updateLocationButton = UILabel()
        updateLocationButton.font = UIFont.systemFont(ofSize: 13)
        updateLocationButton.textColor = UIColor.blue
        updateLocationButton.text = "点击重新定位"
        addSubview(titleLable)
        addSubview(updateLocationButton)
    }
    
    func setupConstrains() {
        titleLable.snp.makeConstraints { (maker) in
            maker.top.left.equalTo(self)
        }
        updateLocationButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(self)
            maker.width.equalTo(100)
            maker.top.equalTo(titleLable.snp.bottom).offset(4)
        }
    }
}
