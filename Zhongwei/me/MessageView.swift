//
//  MessageView.swift
//  Zhongwei
//
//  Created by eesee on 2018/1/31.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class MessageView:UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var number: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
