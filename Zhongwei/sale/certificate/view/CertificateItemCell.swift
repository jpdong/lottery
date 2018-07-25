//
//  CertificateItemCell.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class CertificateItemCell:UITableViewCell {
    var pictureView: UIImageView!
    var nameLabel:UILabel!
    var phoneLabel:UILabel!
    var idLabel:UILabel!
    var nameTitle:UILabel!
    var phoneTitle:UILabel!
    var idTitle:UILabel!
    
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
        nameTitle.font = UIFont.systemFont(ofSize:15)
        phoneTitle.font = UIFont.systemFont(ofSize:15)
        idTitle.font = UIFont.systemFont(ofSize:15)
        nameLabel.font = UIFont.systemFont(ofSize:15)
        phoneLabel.font = UIFont.systemFont(ofSize:15)
        idLabel.font = UIFont.systemFont(ofSize:15)
        addSubview(nameTitle)
        addSubview(phoneTitle)
        addSubview(idTitle)
        
        addSubview(pictureView)
        addSubview(nameLabel)
        addSubview(phoneLabel)
        addSubview(idLabel)
    }
    
    func setupConstrains() {
        pictureView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self).offset(8)
            maker.bottom.equalTo(self).offset(-8)
            maker.left.equalTo(self).offset(16)
            maker.width.equalTo(self.frame.width * 0.3)
        }
        
        nameTitle.snp.makeConstraints { (maker) in
            maker.left.equalTo(pictureView.snp.right).offset(16)
            maker.width.equalTo(80)
            maker.top.equalTo(pictureView).offset(8)
        }
        phoneTitle.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameTitle)
            maker.width.equalTo(nameTitle)
            maker.top.equalTo(nameTitle.snp.bottom).offset(8)
        }
        idTitle.snp.makeConstraints { (maker) in
            maker.width.equalTo(nameTitle)
            maker.left.equalTo(nameTitle)
            maker.top.equalTo(phoneTitle.snp.bottom).offset(8)
        }
        
        
        nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameTitle.snp.right)
            maker.top.equalTo(nameTitle)
        }
        phoneLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(phoneTitle)
            maker.left.equalTo(nameLabel)
        }
        idLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(idTitle)
            maker.left.equalTo(nameLabel)
        }
    }
}
