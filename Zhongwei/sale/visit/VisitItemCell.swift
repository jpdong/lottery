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
    var arriveTitle:UILabel!
    var leaveTitle:UILabel!
    
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
        dateLabel.numberOfLines = 0
        dateLabel.contentMode = .center
        arriveTitle.textColor = UIColor.gray
        arriveLabel.textColor = UIColor.gray
        leaveTitle.textColor = UIColor.gray
        leaveLabel.textColor = UIColor.gray
        arriveTitle.font = UIFont.systemFont(ofSize: 15)
        arriveLabel.font = UIFont.systemFont(ofSize: 15)
        leaveTitle.font = UIFont.systemFont(ofSize: 15)
        leaveLabel.font = UIFont.systemFont(ofSize: 15)
        addSubview(pictureView)
        addSubview(dateLabel)
        addSubview(shopNameLabel)
        addSubview(arriveLabel)
        addSubview(leaveLabel)
        addSubview(arriveTitle)
        addSubview(leaveTitle)
    }
    
    func setupConstrains() {
        dateLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self)
            maker.left.equalTo(self).offset(8)
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
            maker.top.equalTo(pictureView).offset(16)
        }
        arriveTitle.snp.makeConstraints { (maker) in
            maker.left.equalTo(shopNameLabel)
            maker.top.equalTo(shopNameLabel.snp.bottom).offset(16)
            maker.width.equalTo(80)
        }
        leaveTitle.snp.makeConstraints { (maker) in
            maker.left.equalTo(arriveTitle)
            maker.top.equalTo(arriveTitle.snp.bottom).offset(8)
            maker.width.equalTo(100)
        }
        arriveLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(arriveTitle.snp.right).offset(8)
            maker.top.equalTo(arriveTitle)
        }
        leaveLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(arriveLabel)
            maker.top.equalTo(leaveTitle)
        }
    }
}
