//
//  BusinessItemCell.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/9.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class BusinessItemCell:UITableViewCell {
    
    static let titleLeft = 1
    static let titleRight = 2
    
    var icon: UIImageView!
    var title: UILabel!
    var type:Int! = titleLeft
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
        setupConstrains()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupViews()
        setupConstrains()
    }
    
    func setupViews() {
        //icon = UIImageView()
        //title = UILabel()
        addSubview(icon)
        addSubview(title)
    }
    
    func setupConstrains() {
        if (type == 1) {
        title.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(20)
            maker.centerY.equalTo(self)
        }
        
        icon.snp.makeConstraints { (maker) in
            maker.right.equalTo(self)
            maker.top.bottom.equalTo(self)
        }
        } else {
            title.snp.makeConstraints { (maker) in
                maker.right.equalTo(self).offset(-20)
                maker.centerY.equalTo(self)
            }
            
            icon.snp.makeConstraints { (maker) in
                maker.left.equalTo(self)
                maker.top.bottom.equalTo(self)
            }
        }
    }
}
