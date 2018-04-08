//
//  NoteItemCell.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class NoteItemCell:UITableViewCell {
    
    var noteLabel:UILabel!
    var dateLabel:UILabel!
    
    
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
        noteLabel.font = UIFont.systemFont(ofSize:16)
        dateLabel.font = UIFont.systemFont(ofSize:14)
        dateLabel.textColor = UIColor.gray
        addSubview(noteLabel)
        addSubview(dateLabel)
    }
    
    func setupConstrains() {
        noteLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self).offset(8)
            maker.left.equalTo(self).offset(16)
            maker.right.equalTo(self).offset(-8)
        }
        dateLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(noteLabel)
            maker.top.equalTo(noteLabel.snp.bottom).offset(8)
        }
    }
}
