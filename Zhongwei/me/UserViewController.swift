//
//  UserViewController.swift
//  Zhongwei
//
//  Created by eesee on 2018/2/1.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift

class UserViewController:UITableViewController{
    
    @IBOutlet var userInfoCell: UserInfoCell!
    @IBOutlet var messageInfoCell: MessageView!
    @IBOutlet var logoutCell: UITableViewCell!
    
    @IBOutlet weak var aboutInfoCell: UITableViewCell!
    
    @IBOutlet weak var messageNumLabel: UILabel!

    var unionid:String?
    var app:AppDelegate?
    var hasLogin:Bool = false
    var sid:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageNumLabel.layer.cornerRadius = messageNumLabel.bounds.size.width / 2
        app = UIApplication.shared.delegate as! AppDelegate
        app?.globalData?.unionid = getCacheUnionid()!
        app?.globalData?.headImgUrl = getCacheImgUrl()!
        app?.globalData?.nickName = getCacheName()!
        app?.globalData?.sid = getCacheSid()!
        self.tableView.tableFooterView = UIView(frame:.zero)
        //userInfoCell.accessoryType = .disclosureIndicator
        messageInfoCell.accessoryType = .disclosureIndicator
        messageNumLabel.isHidden = true
        aboutInfoCell.accessoryType = .disclosureIndicator
        logoutCell.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(logout)))
        //setupUserInfo()
        //checkUser()
    }
    
    func checkUser() -> Bool {
        Log("")
        sid = app?.globalData?.sid
        var result:Bool = false
        if (sid != nil && sid! != "" && userInfoCell != nil){
            Log("sid:\(sid!)")
            Presenter.checkSid(sid:sid!)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (result) in
                    if (result.code == 0) {
                        let phoneNum = self.app?.globalData?.phoneNum
                        self.userInfoCell.nickNameLabel.text = phoneNum
                    } else {
                        self.logout()
                    }
                })
            hasLogin = true
            logoutCell.isHidden = false
            userInfoCell.accessoryType = .none
            return true
        } else {
            userInfoCell.accessoryType = .disclosureIndicator
            logoutCell.isHidden = true
            return false
        }
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
    
    @objc func logout() {
        app?.globalData?.sid = ""
        let userDefaults = UserDefaults.standard
        userDefaults.set("", forKey: "sid")
        userDefaults.synchronize()
        hasLogin = false
        clearUserInfo()
    }
    
    func clearUserInfo(){
        hasLogin = false
        userInfoCell.accessoryType = .disclosureIndicator
        userInfoCell.headImageView.image = UIImage(named:"noUser")
        userInfoCell.nickNameLabel.text = "点击登录账号"
        logoutCell.isHidden = true
        //messageInfoCell.number.isHidden = true
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if (indexPath.section == 0 && hasLogin){
            return nil
        } else if(indexPath.section == 1 && indexPath.row == 0 && !hasLogin){
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
        //setupUserInfo()
        checkUser()
        Log("user view")
        self.tabBarItem.badgeValue = "4"
        self.tabBarController?.childViewControllers[3].tabBarItem.badgeValue = "5"
        UserPresenter.updateMessages()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (messageResult) in
                if (messageResult.code == 0) {
                    var num = messageResult.messageList?.count
                    if (num! > 0) {
                    self.messageNumLabel.text = String(describing:messageResult.messageList!.count)
                        self.messageNumLabel.isHidden = false
                    } else {
                        self.messageNumLabel.isHidden = true
                    }
                }
            })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.hidesBottomBarWhenPushed = true
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segue.identifier! {
//        case "login":
//            var loginView = segue.destination as! WeiChatLogin
//            loginView.isLogin = hasLogin
//            break
//        default:
//            break
//        }
//    }
    
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
