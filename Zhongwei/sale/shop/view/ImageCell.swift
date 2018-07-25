//
//  ReceiptImageCell.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/20.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class ImageCell:UICollectionViewCell {
    
    var imageView:UIImageView?
    var deleteButton:UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
        setupConstrains()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstrains()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupConstrains()
    }
    
    func setupViews() {
        //backgroundColor = UIColor.yellow
        imageView = UIImageView()
        imageView?.contentMode = .scaleAspectFit
        deleteButton = UIImageView(image:UIImage(named:"button_delete_receipt"))
        deleteButton?.isUserInteractionEnabled = true
        deleteButton?.contentMode = .scaleAspectFit
        addSubview(imageView!)
        addSubview(deleteButton!)
    }
    
    func setupConstrains() {
        imageView!.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self)
        }
        deleteButton!.snp.makeConstraints { (maker) in
            maker.top.right.equalTo(self)
            maker.width.height.equalTo(25)
        }
    }
}
