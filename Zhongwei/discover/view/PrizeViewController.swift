//
//  PrizeViewController.swift
//  Zhongwei
//
//  Created by eesee on 2018/2/5.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class PrizeViewController:UIViewController {
    
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var prizeButton: UIButton!
    var app:AppDelegate?
    
    
    override func viewDidLoad() {
        scanButton.layer.cornerRadius = 5
        prizeButton.layer.cornerRadius = 5
        app = UIApplication.shared.delegate as! AppDelegate
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
}
