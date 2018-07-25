//
//  UserNavigationController.swift
//  Zhongwei
//
//  Created by eesee on 2018/4/18.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class UserNavigationController:UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = UIColor.black
        let sb = UIStoryboard(name:"Me",bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "UserViewController") as! UserViewController
        pushViewController(vc, animated: true)
    }
}
