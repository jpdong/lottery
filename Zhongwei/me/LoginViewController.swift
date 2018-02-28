//
//  LoginViewController.swift
//  Zhongwei
//
//  Created by eesee on 2018/2/27.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift

extension UIView {
    
    private func drawBorder(rect:CGRect,color:UIColor){
        let line = UIBezierPath(rect: rect)
        let lineShape = CAShapeLayer()
        lineShape.path = line.cgPath
        lineShape.fillColor = color.cgColor
        self.layer.addSublayer(lineShape)
    }
    
    public func buttomBorder(width:CGFloat,borderColor:UIColor){
        let rect = CGRect(x: 0, y: self.frame.size.height-width, width: self.frame.size.width, height: width)
        drawBorder(rect: rect, color: borderColor)
    }
}

class LoginViewController:UIViewController{
    
    var isPasswordLogin:Bool = true
    
    @IBOutlet weak var phoneInputBox: UIView!
    
    @IBOutlet weak var passwordInputBox: UIView!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var sendCodeButton: UILabel!
    
    @IBOutlet weak var changeButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var remainingTime:Int = 60 {
        willSet {
            DispatchQueue.main.async {
                self.sendCodeButton.text = "\(self.remainingTime)秒后重新获取"
                if (newValue <= 0) {
                    self.sendCodeButton.text = "获取验证码"
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
    
    @IBAction func changeLoginWay(_ sender: Any) {
        if (isPasswordLogin) {
            passwordLabel.text = "验证码"
            changeButton.setTitle("用密码登录", for: .normal)
            sendCodeButton.isHidden = false
            isPasswordLogin = false
        } else {
            passwordLabel.text = "密码"
            changeButton.setTitle("用短信验证码登录", for: .normal)
            sendCodeButton.isHidden = true
            isPasswordLogin = true
        }
    }
    
    @IBAction func login(_ sender: Any) {
        let phoneNum = phoneTextField.text
        let password = passwordTextField.text
        if (phoneNum == nil || phoneNum == "" || password == nil || password == "") {
            alert(title:"提示", message:"请输入完整信息")
        } else {
            if (isPasswordLogin) {
                Presenter.passwordLogin(phone:phoneNum!, password:password!)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { (result) in
                        if (result.code == 0) {
                            Zhongwei.alert(viewController: self, title: "提示", message: result.message ?? "")
                        } else {
                            Zhongwei.alert(viewController: self, title: "提示", message: result.message ?? "")
                        }
                    })
            } else {
                Presenter.codeLogin(phone:phoneNum!, code:password!)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { (result) in
                        if (result.code == 0) {
                            Zhongwei.alert(viewController: self, title: "提示", message: result.message ?? "")
                        } else {
                            Zhongwei.alert(viewController: self, title: "提示", message: result.message ?? "")
                        }
                    })
            }
        }
    }
    
    func alert(title:String, message:String) {
        let alertView = UIAlertController(title:title, message:message, preferredStyle:.alert)
        let cancel = UIAlertAction(title:"确定", style:.cancel)
        alertView.addAction(cancel)
        present(alertView,animated: true,completion: nil)
    }
    
    override func viewDidLoad() {
        phoneInputBox.buttomBorder(width: 1, borderColor: UIColor.green)
        passwordInputBox.buttomBorder(width: 1, borderColor: UIColor.green)
        sendCodeButton.isHidden = true
        sendCodeButton.addGestureRecognizer()
    }
}


