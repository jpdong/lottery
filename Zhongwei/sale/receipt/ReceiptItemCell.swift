//
//  CertificateItemCell.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class ReceiptItemCell:UITableViewCell {
    var pictureView: UIImageView!
    var dateLabel:UILabel!
    var noteLabel:UILabel!
    
    
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
        addSubview(pictureView)
        addSubview(dateLabel)
        addSubview(noteLabel)
    }
    
    func setupConstrains() {
        pictureView.snp.makeConstraints { (maker) in
            maker.left.top.bottom.equalTo(self)
            maker.width.equalTo(self.frame.width * 0.3)
            
        }
        
        dateLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(pictureView.snp.right)
            maker.top.equalTo(self)
        }
        noteLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(dateLabel)
            maker.top.equalTo(dateLabel.snp.bottom)
        }
    }
}
