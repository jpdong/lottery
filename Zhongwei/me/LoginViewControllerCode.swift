//
//  LoginViewControllerCode.swift
//  Zhongwei
//
//  Created by eesee on 2018/2/27.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import SnapKit

class LoginViewControllerCode:UIViewController{
    
    var logoImageView:UIImageView?
    var phoneLabel:UILabel?
    var passwordLabel:UILabel?
    var phoneTextField:UITextField?
    var passwordTextField:UITextField?
    var phoneInputBox:UIView?
    var passwordInputBox:UIView?
    var sendCodeButton:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        self.view.backgroundColor = UIColor.white
        logoImageView = UIImageView()
        logoImageView!.image = UIImage(named:"logo")
        phoneLabel = UILabel()
        phoneLabel!.text = "手机号"
        passwordLabel = UILabel()
        passwordLabel!.text = "密码"
        phoneTextField = UITextField()
        passwordTextField = UITextField()
        phoneInputBox = UIView()
        passwordInputBox = UIView()
        //phoneInputBox!.backgroundColor = UIColor.green
        //phoneLabel?.backgroundColor = UIColor.orange
        phoneTextField?.borderStyle = UITextBorderStyle.roundedRect
        passwordTextField?.borderStyle = UITextBorderStyle.roundedRect
        sendCodeButton = UILabel()
        sendCodeButton?.font = UIFont(name:sendCodeButton!.font.fontName,size:13)
        sendCodeButton!.text = "获取验证码"
        
        self.view.addSubview(logoImageView!)
        self.view.addSubview(phoneInputBox!)
        self.view.addSubview(passwordInputBox!)
        phoneInputBox!.addSubview(phoneLabel!)
        passwordInputBox!.addSubview(passwordLabel!)
        phoneInputBox!.addSubview(phoneTextField!)
        passwordInputBox!.addSubview(passwordTextField!)
        passwordInputBox!.addSubview(sendCodeButton!)
        //phoneLabel!.sizeToFit()
        
        logoImageView!.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.view.center)
            maker.width.height.equalTo(80)
            maker.top.equalTo(self.view).offset(50)
        }
        
        phoneInputBox!.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(10)
            maker.right.equalTo(self.view).offset(-10)
            maker.height.equalTo(40)
            maker.top.equalTo(logoImageView!.snp.bottom).offset(50)
        }
        
        phoneLabel!.snp.makeConstraints { (maker) in
            maker.width.equalTo(52)
            //maker.height.equalTo(35)
            maker.left.equalTo(phoneInputBox!)
            maker.centerY.equalTo(phoneInputBox!)
        }
        
        phoneTextField!.snp.makeConstraints { (maker) in
            //maker.width.equalTo(40)
            //maker.height.equalTo(35)
            maker.width.equalTo(passwordTextField!)
            maker.left.equalTo(phoneLabel!.snp.right).offset(10)
            //maker.right.equalTo(phoneInputBox!.snp.right).offset(-10)
            maker.centerY.equalTo(phoneInputBox!)
        }
        
        passwordInputBox!.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(10)
            maker.right.equalTo(self.view).offset(-10)
            maker.height.equalTo(40)
            maker.top.equalTo(phoneInputBox!.snp.bottom).offset(10)
        }
        
        passwordLabel!.snp.makeConstraints { (maker) in
            maker.width.equalTo(52)
            //maker.height.equalTo(35)
            maker.left.equalTo(passwordInputBox!)
            maker.centerY.equalTo(passwordInputBox!)
        }
        
        passwordTextField!.snp.makeConstraints { (maker) in
            //maker.width.equalTo(40)
            //maker.height.equalTo(35)
            maker.left.equalTo(passwordLabel!.snp.right).offset(10)
            maker.right.equalTo(sendCodeButton!.snp.left).offset(-10)
            maker.centerY.equalTo(passwordInputBox!)
        }
        
        sendCodeButton!.snp.makeConstraints { (maker) in
            maker.width.equalTo(77)
            maker.centerY.equalTo(passwordInputBox!)
            maker.right.equalTo(passwordInputBox!.snp.right).offset(-10)
        }
        
        
    }
}
