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
        noteLabel.font = UIFont.systemFont(ofSize:15)
        dateLabel.font = UIFont.systemFont(ofSize:15)
        
        addSubview(noteLabel)
        addSubview(dateLabel)
    }
    
    func setupConstrains() {
        noteLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self)
            maker.left.equalTo(self)
            maker.right.equalTo(self)
        }
        dateLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(noteLabel)
            maker.top.equalTo(noteLabel.snp.bottom).offset(8)
        }
    }
}
