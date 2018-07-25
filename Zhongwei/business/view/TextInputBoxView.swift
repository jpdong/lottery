//
//  InputBox.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class TextInputBoxView:UIView {
    
    var titleLable:UILabel!
    var textField:UITextField!
    
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
        textField = UITextField()
        addSubview(titleLable)
        addSubview(textField)
    }
    
    func setupConstrains() {
        titleLable.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self)
            maker.left.equalTo(self)
            maker.width.equalTo(70)
        }
        
        textField.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self)
            maker.left.equalTo(titleLable.snp.right).offset(10)
            maker.right.equalTo(self)
        }
    }
}
