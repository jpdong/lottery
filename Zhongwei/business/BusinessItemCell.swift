//
//  BusinessItemCell.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/9.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class BusinessItemCell:UITableViewCell {
    
    var icon: UIImageView!
    var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
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
        title.snp.makeConstraints { (maker) in
            maker.center.equalTo(self)
        }
    }
}
