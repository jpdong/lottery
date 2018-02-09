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
    @IBOutlet var logoutCell: UITableViewCell!
    
    @IBOutlet weak var aboutInfoCell: UITableViewCell!
    
    @IBOutlet weak var messageNumLabel: UILabel!

    var unionid:String?
    var app:AppDelegate?
    var hasLogin:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageNumLabel.layer.cornerRadius = messageNumLabel.bounds.size.width / 2
        app = UIApplication.shared.delegate as! AppDelegate
        app?.globalData?.unionid = getCacheUnionid()!
        app?.globalData?.headImgUrl = getCacheImgUrl()!
        app?.globalData?.nickName = getCacheName()!
        self.tableView.tableFooterView = UIView(frame:.zero)
        //userInfoCell.accessoryType = .disclosureIndicator
        messageInfoCell.accessoryType = .disclosureIndicator
        aboutInfoCell.accessoryType = .disclosureIndicator
        logoutCell.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(logout)))
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
            logoutCell.isHidden = false
            userInfoCell.accessoryType = .none
            return true
        } else {
            userInfoCell.accessoryType = .disclosureIndicator
            logoutCell.isHidden = true
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
        userInfoCell.accessoryType = .disclosureIndicator
        userInfoCell.headImageView.image = UIImage(named:"noUser")
        userInfoCell.nickNameLabel.text = "点击登录"
        //messageInfoCell.number.isHidden = true
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if (indexPath.section == 0 && hasLogin){
            return nil
        } else {
            return indexPath
        }
    }
    
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        var view = UIView(frame:CGRect(x:0,y:0,width:UIScreen.main.bounds.width, height:20))
//        view.backgroundColor = UIColor.
//        return view
//    }
    
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
