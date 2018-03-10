//
//  RegisterViewController.swift
//  Zhongwei
//
//  Created by eesee on 2018/2/27.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift

class RegisterViewController:UIViewController{
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var sendCodeButton: UIButton!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    
    @IBAction func backToLogin(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var remainingTime:Int = 60 {
        willSet {
            DispatchQueue.main.async {
                self.sendCodeButton.setTitle("\(self.remainingTime)秒后重新获取", for: .normal)
                if (newValue <= 0) {
                    self.sendCodeButton.setTitle("获取验证码", for: .normal)
                    self.isCounting = false
                }
            }
            
        }
    }
    
    var isCounting = false {
        willSet {
            if newValue {
                self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
                self.remainingTime = 60
            } else {
                self.timer.invalidate()
                self.timer = nil
            }
            DispatchQueue.main.async {
                self.sendCodeButton.isEnabled = !newValue
            }
        }
    }
    
    @objc func updateTime() {
        remainingTime -= 1
    }
    
    
    var timer:Timer!
    
    @IBAction func register(_ sender: Any) {
        if (!checkInput()) {
            return
        }
        let phoneNum:String = phoneTextField.text as! String
        let password:String = passwordTextField.text as! String
        let code:String = codeTextField.text as! String
        UserPresenter.phoneNumRegister(phone:phoneNum, password:password, code:code)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                if (result.code == 0) {
                    //alert(viewController: self, title: "提示", message: result.message ?? "")
                    let alertView = UIAlertController(title:"提示", message:result.message ?? "", preferredStyle:.alert)
                    let confirm = UIAlertAction(title:"去登录", style:.default) {
                        action -> Void in
                        //self.navigationController?.popViewController(animated: true)
                        self.dismiss(animated: true, completion: nil)
                    }
                    alertView.addAction(confirm)
                    self.present(alertView,animated: true,completion: nil)
                    //self.dismiss(animated: true, completion: nil)
                } else {
                    alert(viewController: self, title: "提示", message: result.message ?? "")
                }
            })
        
        
    }
    
    func checkInput() -> Bool {
        if (!checkPhoneNum() || !checkCode() || !checkPasswordContent()) {
            return false
        } else {
            return true
        }
    }
    
    func checkPhoneNum() -> Bool{
        let phoneNum = phoneTextField.text
        if (phoneNum == nil || phoneNum! == "") {
            alert(viewController: self, title: "提示", message: "请输入手机号")
            return false
        } else {
            if (phoneNum!.count != 11) {
                alert(viewController: self, title: "提示", message: "手机号格式不正确")
                return false
            } else {
                return true
            }
        }
    }
    
    func checkCode() -> Bool {
        let code = codeTextField.text
        if (code == nil || code! == "") {
            alert(viewController: self, title: "提示", message: "请输入验证码")
            return false
        } else {
            return true
        }
    }
    
    func checkPasswordContent() -> Bool {
        let password = passwordTextField.text
        let confirmPassword = confirmPasswordText.text
        if (password == nil || password! == "" || confirmPassword == nil || confirmPassword! == "") {
            alert(viewController: self, title: "提示", message: "请输入密码")
            return false
        } else {
            if (password! != confirmPassword!) {
                alert(viewController: self, title: "提示", message: "两次输入密码不一致")
                return false
            } else {
                return true
            }
        }
        
    }
    
    @IBAction func sendCode(_ sender: Any) {
        let phoneNum = phoneTextField.text
        if (phoneNum == nil || phoneNum! == "") {
            alert(viewController: self, title: "提示", message: "请输入手机号")
        } else {
            let alertView = UIAlertController(title:"确认手机号码", message:"我们将发送验证码短信到下面的号码：\(phoneNum!)", preferredStyle:.alert)
            let cancel = UIAlertAction(title:"取消", style:.cancel)
            let confirm = UIAlertAction(title:"确定", style:.default){
                action in
                UserPresenter.sendVerificationCode(phone:phoneNum!)
                .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { (result) in
                        if (result.code == 0) {
                            alert(viewController: self, title: "提示", message:result.message ?? "")
                        } else {
                            alert(viewController: self, title: "提示", message:result.message ?? "")
                            self.startTiming()
                        }
                    })
            }
            alertView.addAction(cancel)
            alertView.addAction(confirm)
            present(alertView,animated: true,completion: nil)
        }
    }
    
    func startTiming(){
        isCounting = true
    }
    
    override func viewDidLoad() {
        sendCodeButton.setTitle("获取验证码", for: .normal)
        passwordTextField.isSecureTextEntry = true
        confirmPasswordText.isSecureTextEntry = true
    }
}
