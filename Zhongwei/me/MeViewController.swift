//
//  MeViewController.swift
//  Zhongwei
//
//  Created by eesee on 2018/1/26.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class MeViewController:UIViewController{
    
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    var unionid:String?
    var app:AppDelegate?
    
    @IBAction func logout(_ sender: Any) {
        app?.globalData?.unionid = ""
        let userDefaults = UserDefaults.standard
        userDefaults.set("", forKey: "unionid")
        userDefaults.synchronize()
    }
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "我"
        app = UIApplication.shared.delegate as! AppDelegate
        app?.globalData?.unionid = getCacheUnionid()
        app?.globalData?.headImgUrl = getCacheImgUrl()
        app?.globalData?.nickName = getCacheName()
    }
    
    func setupUserInfo(){
        unionid = app?.globalData?.unionid
        if (unionid != nil && unionid! != ""){
            let imgUrl = app?.globalData?.headImgUrl
            let nickName = app?.globalData?.nickName
            let url = URL(string:imgUrl!)
            headImageView.kf.setImage(with: url)
            nickNameLabel.text = nickName
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Log("viewDidAppear")
        setupUserInfo()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Log("viewDidDisAppear")
    }
    
    
}
