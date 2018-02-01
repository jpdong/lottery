//
//  UserViewController.swift
//  Zhongwei
//
//  Created by eesee on 2018/2/1.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class UserViewController:UITableViewController{
    
    @IBOutlet var userInfoCell: UserInfoCell!
    @IBOutlet var messageInfoCell: MessageView!
    //@IBOutlet var logoutCell: UITableViewCell!
    
    var unionid:String?
    var app:AppDelegate?
    var hasLogin:Bool = false
    
    override func viewDidLoad() {
        app = UIApplication.shared.delegate as! AppDelegate
        app?.globalData?.unionid = getCacheUnionid()
        app?.globalData?.headImgUrl = getCacheImgUrl()
        app?.globalData?.nickName = getCacheName()
        self.tableView.tableFooterView = UIView(frame:.zero)
        userInfoCell.accessoryType = .disclosureIndicator
        messageInfoCell.accessoryType = .disclosureIndicator
        //logoutCell.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(logout)))
        //logoutCell.isHidden = true
        setupUserInfo()
    }
    
    func setupUserInfo() -> Bool{
        unionid = app?.globalData?.unionid
        if (unionid != nil && unionid! != "" && userInfoCell != nil){
            hasLogin = true
            let imgUrl = app?.globalData?.headImgUrl
            let nickName = app?.globalData?.nickName
            let url = URL(string:imgUrl!)
            userInfoCell.headImageView.kf.setImage(with: url)
            //userInfoCell.headImageView.isHidden = false
            userInfoCell.nickNameLabel.text = nickName
            userInfoCell.accessoryType = .disclosureIndicator
            return true
        } else {
            return false
        }
    }
    
    @objc func logout(_ sender: Any) {
        app?.globalData?.unionid = ""
        let userDefaults = UserDefaults.standard
        userDefaults.set("", forKey: "unionid")
        userDefaults.synchronize()
        hasLogin = false
        clearUserInfo()
    }
    
    func clearUserInfo(){
        hasLogin = false
        userInfoCell.headImageView.image = UIImage(named:"noUser")
        userInfoCell.nickNameLabel.text = "点击登录"
        messageInfoCell.number.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUserInfo()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "login":
            var loginView = segue.destination as! WeiChatLogin
            loginView.isLogin = hasLogin
            break
        default:
            break
        }
    }
}

class UserInfoCell:UITableViewCell {
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class FeatureItem{
    
    public static let userInfo = 1
    public static let messageInfo = 2
    
    var title:String?
    var type:Int?
    
    init(title:String, type:Int) {
        self.title = title
        self.type = type
    }
    
}
