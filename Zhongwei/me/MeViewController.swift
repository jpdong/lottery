//
//  MeViewController.swift
//  Zhongwei
//
//  Created by eesee on 2018/1/26.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift

class MeViewController:UIViewController{
    
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var featureTableView: UITableView!
    @IBOutlet weak var messageInfoCell: MessageView!
    @IBOutlet weak var userInfoCell: UserInfoCell!
    
    var unionid:String?
    var sid:String?
    var app:AppDelegate?
    
//    var userInfoItem:FeatureItem? = FeatureItem(title:"点击登录", type:FeatureItem.userInfo)
//    var messageInfoItem:FeatureItem? = FeatureItem(title:"消息", type:FeatureItem.messageInfo)
//    var featureItems:Dictionary<Int,FeatureItem>?
    
    @IBAction func logout(_ sender: Any) {
        app?.globalData?.sid = ""
        let userDefaults = UserDefaults.standard
        userDefaults.set("", forKey: "sid")
        userDefaults.synchronize()
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "我"
        app = UIApplication.shared.delegate as! AppDelegate
        app?.globalData?.unionid = getCacheUnionid()!
        app?.globalData?.headImgUrl = getCacheImgUrl()!
        app?.globalData?.nickName = getCacheName()!
        featureTableView.tableFooterView = UIView(frame:.zero)
        if (checkUser()) {
            logoutButton.isHidden = false
        } else {
            logoutButton.isHidden = true
        }
    }
    
    func checkUser() -> Bool {
        Log("")
        sid = app?.globalData?.sid
        if (sid != nil && sid! != "" && userInfoCell != nil){
            Log("sid:\(sid!)")
            Presenter.checkSid(sid:sid!)
            .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (result) in
                    
                })
            let phoneNum = app?.globalData?.phoneNum
            userInfoCell.nickNameLabel.text = phoneNum
            return true
        } else {
            return false
        }
    }
    
    func setupUserInfo() -> Bool{
        unionid = app?.globalData?.unionid
        if (unionid != nil && unionid! != "" && userInfoCell != nil){
            let imgUrl = app?.globalData?.headImgUrl
            let nickName = app?.globalData?.nickName
            let url = URL(string:imgUrl!)
            userInfoCell.headImageView.kf.setImage(with: url)
            userInfoCell.nickNameLabel.text = nickName
            return true
        } else {
            return false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Log("viewDidAppear")
        checkUser()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Log("viewDidDisAppear")
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let item = featureItems![indexPath.section]
//        Log("listItem:\(item)")
//        let cell:UITableViewCell? = UITableViewCell()
//        if (item!.type == FeatureItem.messageInfo){
//            let identify = "MessageCell"
//            messageInfoCell = tableView.dequeueReusableCell(withIdentifier: identify, for: indexPath) as! MessageView
//            messageInfoCell.title.text = item?.title
//            messageInfoCell.accessoryType = .disclosureIndicator
//            return messageInfoCell
//        } else if (item!.type == FeatureItem.userInfo) {
//            let identify = "UserInfoCell"
//            userInfoCell = tableView.dequeueReusableCell(withIdentifier: identify, for: indexPath) as! UserInfoCell
//            userInfoCell.nickNameLabel.text = item?.title
//            userInfoCell.accessoryType = .disclosureIndicator
//            return userInfoCell
//        }
//        return cell!
//    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if (indexPath.row == 0) {
//            return 128
//        } else {
//            return 64
//        }
//    }
}

//class UserInfoCell:UITableViewCell {
//    @IBOutlet weak var headImageView: UIImageView!
//    @IBOutlet weak var nickNameLabel: UILabel!
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
//}
//
//class FeatureItem{
//
//    public static let userInfo = 1
//    public static let messageInfo = 2
//
//    var title:String?
//    var type:Int?
//
//    init(title:String, type:Int) {
//        self.title = title
//        self.type = type
//    }
//
//}

