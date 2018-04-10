//
//  PreviewImageController.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/23.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class PreviewImageController:UIViewController {
    
    var navigationBarHeight:CGFloat!
    var statusBarHeight:CGFloat!
    var closeButton:UIBarButtonItem!
    var navigationBar:UINavigationBar!
    var editNavigationItem:UINavigationItem!
    var imageUrl:String?
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        navigationBarHeight = Size.instance.navigationBarHeight
        statusBarHeight = Size.instance.statusBarHeight
        navigationBar = UINavigationBar(frame:CGRect( x:0,y:statusBarHeight, width:self.view.frame.width, height:navigationBarHeight))
        editNavigationItem = UINavigationItem()
        editNavigationItem.title = "预览"
        closeButton = UIBarButtonItem(title:"", style:.plain, target:self, action:#selector(close))
        closeButton.image = UIImage(named:"closeButton")
        closeButton.tintColor = UIColor.black
        editNavigationItem.setRightBarButton(closeButton, animated: true)
        navigationBar?.pushItem(editNavigationItem, animated: true)
        self.view.addSubview(navigationBar)
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.kf.setImage(with: URL(string:imageUrl ?? ""))
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(navigationBar.snp.bottom)
            maker.bottom.left.right.equalTo(self.view)
        }
    }
    
    @objc func close(_ sender:UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
}
