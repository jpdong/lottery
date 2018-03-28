//
//  CertificateItemCell.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class VisitItemCell:UITableViewCell {
    var pictureView: UIImageView!
    var dateLabel:UILabel!
    var shopNameLabel:UILabel!
    var arriveLabel:UILabel!
    var leaveLabel:UILabel!
    
    
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
        backgroundColor = UIColor.clear
        pictureView.contentMode = .scaleAspectFill
        addSubview(pictureView)
        addSubview(dateLabel)
        addSubview(shopNameLabel)
        addSubview(arriveLabel)
        addSubview(leaveLabel)
    }
    
    func setupConstrains() {
        dateLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self)
            maker.left.equalTo(self)
            maker.width.equalTo(100)
        }
        pictureView.snp.makeConstraints { (maker) in
            maker.left.equalTo(dateLabel.snp.right).offset(16)
            maker.top.equalTo(self)
            maker.bottom.equalTo(self)
            maker.right.equalTo(self).offset(-8)
        }
        
        shopNameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(pictureView).offset(8)
            maker.top.equalTo(pictureView).offset(8)
        }
        arriveLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(shopNameLabel)
            maker.top.equalTo(shopNameLabel.snp.bottom).offset(16)
        }
        leaveLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(shopNameLabel)
            maker.top.equalTo(arriveLabel.snp.bottom).offset(16)
        }
    }
}
