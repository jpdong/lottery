//
//  DetailViewController.swift
//  Zhongwei
//
//  Created by eesee on 2018/1/25.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class DetailViewController:WebViewController{
    
    var detailUrl:String?
    var type:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (type == 1){
        loadUrl(url: detailUrl!)
        }
    }
}
