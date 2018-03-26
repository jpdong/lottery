//
//  ShopInfoView.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/26.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class ShopInfoView:UIView {
    
    var nameLabel:UILabel!
    var phoneLabel:UILabel!
    var addressLabel:UILabel!
    var nameIcon:UIImageView!
    var phoneIcon:UIImageView!
    var addressIcon:UIImageView!
    
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
        nameLabel = UILabel()
        phoneLabel = UILabel()
        addressLabel = UILabel()
        nameIcon = UIImageView(image: UIImage(named:""))
        nameIcon.contentMode = .scaleAspectFit
        phoneIcon = UIImageView(image: UIImage(named:""))
        phoneIcon.contentMode = .scaleAspectFit
        addressIcon = UIImageView(image: UIImage(named:""))
        addressIcon.contentMode = .scaleAspectFit
        
        addSubview(nameIcon)
        addSubview(phoneIcon)
        addSubview(addressIcon)
        addSubview(nameLabel)
        addSubview(phoneLabel)
        addSubview(addressLabel)
    }
    
    func setupConstrains() {
        nameIcon.snp.makeConstraints { (maker) in
            maker.left.equalTo(self)
            maker.width.height.equalTo(20)
            maker.top.equalTo(self)
        }
        phoneIcon.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameIcon)
            maker.width.height.equalTo(nameIcon)
            maker.top.equalTo(nameIcon.snp.bottom)
        }
        addressIcon.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameIcon)
            maker.width.height.equalTo(nameIcon)
            maker.top.equalTo(phoneIcon.snp.bottom)
        }
        nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameIcon)
            maker.top.equalTo(nameIcon)
        }
        phoneLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameLabel)
            maker.top.equalTo(phoneIcon)
        }
        addressLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameLabel)
            maker.top.equalTo(addressIcon)
        }
    }
}
