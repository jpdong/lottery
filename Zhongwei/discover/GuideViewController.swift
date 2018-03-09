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
    var navigationBar:UINavigationBar!
    var guideNavigationItem:UINavigationItem!
    var navigationBarHeight:CGFloat?
    var statusBarHeight:CGFloat?
    
    override func viewDidLoad() {
        
        setupViews()
        setupConstrains()
    }
    
    func setupViews() {
        self.view.backgroundColor = UIColor.white
        navigationBarHeight = Size.instance.navigationBarHeight
        statusBarHeight = Size.instance.statusBarHeight
        navigationBar = UINavigationBar(frame:CGRect( x:0,y:Size.instance.statusBarHeight, width:self.view.frame.width, height:Size.instance.navigationBarHeight))
        guideNavigationItem = UINavigationItem()
        let closeButton = UIBarButtonItem(title:"", style:.plain, target:self, action:#selector(close))
        closeButton.image = UIImage(named:"closeButton")
        guideNavigationItem.setRightBarButton(closeButton, animated: true)
        navigationBar?.pushItem(guideNavigationItem, animated: true)
        self.view.addSubview(navigationBar!)
        //scrollView = UIScrollView(frame:self.view.bounds)
        scrollView = UIScrollView(frame:CGRect(x:0,y:statusBarHeight! + navigationBarHeight! + 20,width:self.view.frame.width,height:self.view.frame.height))
        //scrollView.frame = self.view.bounds
        imageView = UIImageView(image:UIImage(named:"guide"))
        scrollView.contentSize = imageView!.bounds.size
        self.view.addSubview(scrollView)
        scrollView.addSubview(imageView!)
    }
    
    func setupConstrains() {
//        scrollView.snp.makeConstraints { (maker) in
//            maker.top.equalTo(navigationBar.snp.bottom)
//            maker.width.equalTo(self.view)
//            maker.left.right.equalTo(self.view)
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @objc func close(_ sender:UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
}
