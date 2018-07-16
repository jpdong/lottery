//
//  CustomerServiceNavigationController.swift
//  Zhongwei
//
//  Created by eesee on 2018/4/18.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class ServiceNavigationController:UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let source = QYSource()
        source.title = "客服"
        source.urlString = "https://8.163.com/"
        let vc:QYSessionViewController = QYSDK.shared().sessionViewController()
        vc.sessionTitle = "客服"
        vc.source = source
        self.pushViewController(vc, animated: true)
        
    }
}
