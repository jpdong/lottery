//
//  BusinessItemView.swift
//  Zhongwei
//
//  Created by eesee on 2018/1/30.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class BusinessItemView:UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupViews()
    }
    
    func setupViews() {
        
    }
}
