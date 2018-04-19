//
//  LoginViewController.swift
//  Zhongwei
//
//  Created by eesee on 2018/2/27.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import Toaster

class LoginViewController:UIViewController,UITextFieldDelegate{
    
    var isPasswordLogin:Bool = true
    var app:AppDelegate!
    var loginIndicator:UIActivityIndicatorView!
    var keyboardHeight:CGFloat?
    var timer:Timer!
    var presenter:UserPresenter!
    var disposeBag:DisposeBag!
    
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
                self.sendCodeButton.isUserInteractionEnabled = !newValue
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disposeBag = DisposeBag()
        presenter = UserPresenter()
        app = UIApplication.shared.delegate as! AppDelegate
        setupViews()
        setupConstrains()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //self.disposeBag = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupViews() {
        sendCodeButton.isHidden = true
        phoneTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        var tap = UITapGestureRecognizer(target:self,action:#selector(sendCode))
        sendCodeButton.addGestureRecognizer(tap)
        loginIndicator = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.gray)
        self.view.addSubview(loginIndicator)
        
    }
    
    func setupConstrains() {
        loginIndicator.snp.makeConstraints { (maker) in
            maker.center.equalTo(loginButton)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(note:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden(note:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onPhoneTextfieldChanged(note:)), name: NSNotification.Name.UITextFieldTextDidChange, object: self.phoneTextField)
    }
    
    override func viewDidLayoutSubviews() {
        phoneInputBox.bottomBorder(width: 0.5, borderColor: UIColor(red:0xbf/255,green:0xbf/255, blue:0xbf/255,alpha:1))
        passwordInputBox.bottomBorder(width: 0.5, borderColor: UIColor(red:0xbf/255,green:0xbf/255, blue:0xbf/255,alpha:1))
    }
    
    @objc func sendCode(_ sender: Any) {
        var phoneNum = phoneTextField.text
        if (phoneNum == nil || phoneNum! == "") {
            Zhongwei.alert(viewController: self, title: "提示", message: "请输入手机号")
        } else {
            let alertView = UIAlertController(title:"确认手机号码", message:"我们将发送验证码短信到下面的号码：\(phoneNum!)", preferredStyle:.alert)
            let cancel = UIAlertAction(title:"取消", style:.cancel)
            let confirm = UIAlertAction(title:"确定", style:.default){
                action in
                phoneNum = phoneNum?.trimmingCharacters(in: .whitespaces)
                self.presenter.sendVerificationCode(phone:phoneNum!)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { (result) in
                        if (result.code == 0) {
                            Toast(text:"发送成功").show()
                            self.startTiming()
                        } else {
                            Zhongwei.alert(viewController: self, title: "提示", message:result.message ?? "")
                        }
                    })
                .disposed(by: self.disposeBag)
            }
            alertView.addAction(cancel)
            alertView.addAction(confirm)
            present(alertView,animated: true,completion: nil)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func updateTime() {
        remainingTime -= 1
    }
    
    func startTiming(){
        isCounting = true
    }
    
    @IBAction func changeLoginWay(_ sender: Any) {
        if (isPasswordLogin) {
            passwordLabel.text = "验证码"
            passwordTextField.placeholder = "请填写验证码"
            passwordTextField.isSecureTextEntry = false
            changeButton.setTitle("用密码登录", for: .normal)
            sendCodeButton.isHidden = false
            isPasswordLogin = false
        } else {
            passwordLabel.text = "密码"
            passwordTextField.placeholder = "请填写密码"
            changeButton.setTitle("用短信验证码登录", for: .normal)
            sendCodeButton.isHidden = true
            isPasswordLogin = true
        }
    }
    
    @IBAction func login(_ sender: Any) {
        self.view.endEditing(true)
        var phoneNum = phoneTextField.text
        var password = passwordTextField.text
        if (phoneNum == nil || phoneNum == "" || password == nil || password == "") {
            alert(title:"提示", message:"请输入完整信息")
        } else {
            loginIndicator.startAnimating()
            loginButton.isEnabled = false
            phoneNum = phoneNum?.trimmingCharacters(in: .whitespaces)
            password = password?.trimmingCharacters(in: .whitespaces)
            if (isPasswordLogin) {
                presenter.passwordLogin(phone:phoneNum!, password:password!)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { (result) in
                        self.loginIndicator.stopAnimating()
                        self.loginButton.isEnabled = true
                        if (result.code == 0) {
                            Toast(text: "登录成功").show()
                            //Zhongwei.alert(viewController: self, title: "提示", message: result.message ?? "")
                            self.app.globalData?.phoneNum = phoneNum!
                            storePhoneNum(phoneNum!)
                            //self.navigationController?.popViewController(animated: true)
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            Toast(text: "登录失败：\(result.message ?? "")").show()
                        }
                    })
                .disposed(by: self.disposeBag)
            } else {
                presenter.codeLogin(phone:phoneNum!, code:password!)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { (result) in
                        self.loginIndicator.stopAnimating()
                        self.loginButton.isEnabled = true
                        if (result.code == 0) {
                            Toast(text: "登录成功").show()
                            //Zhongwei.alert(viewController: self, title: "提示", message: result.message ?? "")
                            self.app.globalData?.phoneNum = phoneNum!
                            storePhoneNum(phoneNum!)
                            //self.navigationController?.popViewController(animated: true)
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            Toast(text: "登录失败：\(result.message ?? "")").show()
                        }
                    })
                .disposed(by: self.disposeBag)
            }
        }
    }
    
    func alert(title:String, message:String) {
        let alertView = UIAlertController(title:title, message:message, preferredStyle:.alert)
        let cancel = UIAlertAction(title:"确定", style:.cancel)
        alertView.addAction(cancel)
        present(alertView,animated: true,completion: nil)
    }
    
}




