//
//  ShopItemCell.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/26.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class ShopItemCell:UITableViewCell {
    
    var shopLabel:UILabel!
    var shopInfoView:ShopInfoView!
    
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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupConstrains()
    }
    
    func setupViews() {
        
        addSubview(shopLabel)
        addSubview(shopInfoView)
    }
    
    func setupConstrains() {
        
        shopLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(32)
            maker.top.equalTo(self).offset(8)
        }
        shopInfoView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(16)
            maker.top.equalTo(shopLabel.snp.bottom).offset(16)
        }
        
    }
    
}
