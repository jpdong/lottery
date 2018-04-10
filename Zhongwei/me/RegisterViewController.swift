//
//  RegisterViewController.swift
//  Zhongwei
//
//  Created by eesee on 2018/2/27.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import Toaster

class RegisterViewController:UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var sendCodeButton: UIButton!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var phoneInputBox: UIView!
    @IBOutlet weak var codeInputBox: UIView!
    @IBOutlet weak var passwordInputBox: UIView!
    @IBOutlet weak var confirmInputBox: UIView!
    
    var registerIndicator:UIActivityIndicatorView!
    var keyboardHeight:CGFloat?
    var timer:Timer!
    
    
    
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
    
    override func viewDidLoad() {
        setupViews()
        setupConstrains()
    }
    
    func setupViews() {
        sendCodeButton.setTitle("获取验证码", for: .normal)
        phoneTextField.delegate = self
        codeTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        confirmPasswordText.isSecureTextEntry = true
        confirmPasswordText.delegate = self
        registerIndicator = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.gray)
        self.view.addSubview(registerIndicator)
    }
    
    func setupConstrains() {
        registerIndicator.snp.makeConstraints { (maker) in
            maker.center.equalTo(registerButton)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLayoutSubviews() {
        phoneInputBox.bottomBorder(width: 0.5, borderColor: UIColor(red:0xbf/255,green:0xbf/255, blue:0xbf/255,alpha:1))
        codeInputBox.bottomBorder(width: 0.5, borderColor: UIColor(red:0xbf/255,green:0xbf/255, blue:0xbf/255,alpha:1))
        passwordInputBox.bottomBorder(width: 0.5, borderColor: UIColor(red:0xbf/255,green:0xbf/255, blue:0xbf/255,alpha:1))
        confirmInputBox.bottomBorder(width: 0.5, borderColor: UIColor(red:0xbf/255,green:0xbf/255, blue:0xbf/255,alpha:1))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(note:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden(note:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onPhoneTextfieldChanged(note:)), name: NSNotification.Name.UITextFieldTextDidChange, object: self.phoneTextField)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardShow(note:Notification) {
        guard let userInfo = note.userInfo else {
            return
        }
        guard let keyboardRect = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        keyboardHeight = keyboardRect.height
        if (!Size.instance.isiPhoneX) {
            UIView.animate(withDuration:0.5) {
                self.view.transform = CGAffineTransform.init(translationX: 0, y: -keyboardRect.height * 0.5)
            }
        }
    }
    
    @objc func keyboardHidden(note:Notification) {
        if (!Size.instance.isiPhoneX) {
            UIView.animate(withDuration:0.5) {
                self.view.transform = CGAffineTransform.init(translationX: 0, y: 0)
            }
        }
    }
    
    @objc func onPhoneTextfieldChanged(note:Notification) {
        guard let _: UITextRange = phoneTextField.markedTextRange else{
            let cursorPostion = phoneTextField.offset(from: phoneTextField.endOfDocument,
                                                      to: phoneTextField.selectedTextRange!.end)
            let pattern = "[^0-9]"
            var str = phoneTextField.text!.pregReplace(pattern: pattern, with: "")
            if str.count > 11 {
                str = String(str.prefix(11))
            }
            phoneTextField.text = str
            let targetPostion = phoneTextField.position(from: phoneTextField.endOfDocument,offset: cursorPostion)!
            phoneTextField.selectedTextRange = phoneTextField.textRange(from: targetPostion,to: targetPostion)
            return
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    @objc func updateTime() {
        remainingTime -= 1
    }
    
    @IBAction func backToLogin(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func register(_ sender: Any) {
        self.view.endEditing(true)
        if (!checkInput()) {
            return
        }
        var phoneNum:String = phoneTextField.text as! String
        var password:String = passwordTextField.text as! String
        var code:String = codeTextField.text as! String
        phoneNum = phoneNum.trimmingCharacters(in: .whitespaces)
        password = password.trimmingCharacters(in: .whitespaces)
        registerIndicator.startAnimating()
        registerButton.isEnabled = false
        UserPresenter.phoneNumRegister(phone:phoneNum, password:password, code:code)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                self.registerIndicator.stopAnimating()
                self.registerButton.isEnabled = true
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
                    Toast(text: "注册失败：\(result.message)").show()
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
        var password = passwordTextField.text
        var confirmPassword = confirmPasswordText.text
        if (password == nil || password! == "" || confirmPassword == nil || confirmPassword! == "") {
            alert(viewController: self, title: "提示", message: "请输入密码")
            return false
        } else {
            password = password?.trimmingCharacters(in: .whitespaces)
            confirmPassword = confirmPassword?.trimmingCharacters(in: .whitespaces)
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
                            Toast(text: "发送成功").show()
                            self.startTiming()
                        } else {
                            alert(viewController: self, title: "提示", message:result.message ?? "")
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
}
