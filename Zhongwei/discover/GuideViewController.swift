//
//  GuideViewController.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/6.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import SnapKit

class GuideViewController:UIViewController {
    
    var scrollView: UIScrollView!
    var imageView:UIImageView?
    
    override func viewDidLoad() {
        scrollView = UIScrollView(frame:CGRect(x:0, y:44,width:self.view.frame.width, height:self.view.frame.height))
        //scrollView.frame = self.view.bounds
        imageView = UIImageView(image:UIImage(named:"guide"))
        scrollView.contentSize = imageView!.bounds.size
        self.view.addSubview(scrollView)
        scrollView.addSubview(imageView!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
}
