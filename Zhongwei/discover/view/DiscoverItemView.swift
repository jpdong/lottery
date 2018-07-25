//
//  DiscoverItemView.swift
//  Zhongwei
//
//  Created by eesee on 2018/1/25.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class DiscoverItemView:UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
