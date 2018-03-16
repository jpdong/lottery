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
        //setupViews()
        //setupConstrains()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupConstrains()
    }
    
    func setupViews() {
//        nameTitle = UILabel()
//        //nameTitle.text = "店主姓名："
//        phoneTitle = UILabel()
//        //phoneTitle.text = "手机号码："
//        idTitle = UILabel()
//        //idTitle.text = "代销证号："
//        pictureView = UIImageView()
//        nameLabel = UILabel()
//        nameLabel.text = ""
//        phoneLabel = UILabel()
//        phoneLabel.text = ""
//        idLabel = UILabel()
//        idLabel.text = ""
        
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
            maker.centerY.equalTo(self)
            maker.left.equalTo(self)
            maker.width.equalTo(self.frame.width * 0.3)
        }
        
        nameTitle.snp.makeConstraints { (maker) in
            maker.left.equalTo(pictureView.snp.right)
            maker.width.equalTo(100)
            maker.top.equalTo(self)
        }
        phoneTitle.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameTitle)
            maker.width.equalTo(100)
            maker.top.equalTo(nameTitle.snp.bottom)
        }
        idTitle.snp.makeConstraints { (maker) in
            maker.width.equalTo(100)
            maker.left.equalTo(nameTitle)
            maker.top.equalTo(phoneTitle.snp.bottom)
        }
        
        
        nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameTitle.snp.right)
            maker.top.equalTo(self)
        }
        phoneLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(nameLabel.snp.bottom)
            maker.left.equalTo(nameLabel)
        }
        idLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(phoneLabel.snp.bottom)
            maker.left.equalTo(nameLabel)
        }
    }
}
