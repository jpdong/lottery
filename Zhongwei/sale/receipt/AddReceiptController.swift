//
//  AddReceiptController.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import Toaster

class AddReceiptController:UIViewController {
    
    var nameInputBox:TextInputBoxView!
    var phoneInputBox:TextInputBoxView!
    var idInputBox:TextInputBoxView!
    var imageInputBox:ImageInputBoxView!
    var submitButton:UIButton!
    var submitIndicator:UIActivityIndicatorView!
    var imageIndicator:UIActivityIndicatorView!
    var imageUrl:String?
    var type:Int = 2
    var editableItem:ReceiptItem?
    var navigationBarHeight:CGFloat?
    var statusBarHeight:CGFloat?
    var closeButton:UIBarButtonItem!
    var navigationBar:UINavigationBar!
    var editNavigationItem:UINavigationItem!
    
    override func viewDidLoad() {
        setupViews()
        setupConstrains()
        setupClickEvents()
    }
    
    func setupViews() {
        navigationBarHeight = Size.instance.navigationBarHeight
        statusBarHeight = Size.instance.statusBarHeight
        navigationBar = UINavigationBar(frame:CGRect( x:0,y:statusBarHeight!, width:self.view.frame.width, height:navigationBarHeight!))
        editNavigationItem = UINavigationItem()
        closeButton = UIBarButtonItem(title:"", style:.plain, target:self, action:#selector(close))
        closeButton.image = UIImage(named:"closeButton")
        closeButton.tintColor = UIColor.black
      
        editNavigationItem.setRightBarButton(closeButton, animated: true)
        
        navigationBar?.pushItem(editNavigationItem, animated: true)
        self.view.addSubview(navigationBar!)
        
        self.view.backgroundColor = UIColor.white
        
        nameInputBox = TextInputBoxView()
        nameInputBox.titleLable.text = "店主姓名"
        nameInputBox.textField.placeholder = "请输入店主姓名"
        
        phoneInputBox = TextInputBoxView()
        phoneInputBox.titleLable.text = "手机号码"
        phoneInputBox.textField.placeholder = "请输入店主手机号"
        //phoneInputBox.backgroundColor = UIColor.yellow
        
        idInputBox = TextInputBoxView()
        idInputBox.titleLable.text = "代销证号"
        idInputBox.textField.placeholder = "请输入证件号"
        
        imageInputBox = ImageInputBoxView()
        imageInputBox.titleLabel.text = "代销证照片"
        imageInputBox.imageView.image = UIImage(named:"tobacco_card")
        imageInputBox.isUserInteractionEnabled = true
        
        
        submitButton = UIButton()
        submitButton.setTitle("保存", for: .normal)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.backgroundColor = UIColor(red:0x2e/255,green:0x6e/255,blue:0x55/255,alpha:1)
        
        submitIndicator = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.gray)
        imageIndicator = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.whiteLarge)
        
        self.view.addSubview(nameInputBox)
        self.view.addSubview(phoneInputBox)
        self.view.addSubview(idInputBox)
        self.view.addSubview(imageInputBox)
        self.view.addSubview(submitButton)
        self.view.addSubview(submitIndicator)
        self.view.addSubview(imageIndicator)
        
        if (type == ReceiptItem.edit) {
            nameInputBox.textField.text = editableItem?.name
            phoneInputBox.textField.text = editableItem?.phone
            idInputBox.textField.text = editableItem?.lottery_papers
            imageUrl = editableItem?.lottery_papers_image
            imageInputBox.imageView.kf.setImage(with: URL(string:imageUrl!))
        }
    }
    
    func setupConstrains() {
        nameInputBox.snp.makeConstraints { (maker) in
            maker.height.equalTo(60)
            maker.top.equalTo(self.view).offset(Size.instance.statusBarHeight + Size.instance.navigationBarHeight)
            maker.left.equalTo(self.view).offset(16)
            maker.right.equalTo(self.view)
        }
        phoneInputBox.snp.makeConstraints { (maker) in
            maker.height.equalTo(60)
            maker.top.equalTo(nameInputBox.snp.bottom)
            maker.left.equalTo(self.view).offset(16)
            maker.width.equalTo(self.view)
        }
        idInputBox.snp.makeConstraints { (maker) in
            maker.height.equalTo(60)
            maker.top.equalTo(phoneInputBox.snp.bottom)
            maker.left.equalTo(self.view).offset(16)
            maker.width.equalTo(self.view)
        }
        imageInputBox.snp.makeConstraints { (maker) in
            maker.height.equalTo(200)
            maker.top.equalTo(idInputBox.snp.bottom)
            maker.left.equalTo(self.view).offset(16)
            maker.width.equalTo(self.view)
        }
        submitButton.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.view)
            maker.top.equalTo(imageInputBox.snp.bottom).offset(40)
            maker.height.equalTo(50)
            maker.width.greaterThanOrEqualTo(240)
            maker.left.equalTo(self.view).offset(16)
            maker.right.equalTo(self.view).offset(-16)
        }
        imageIndicator.snp.makeConstraints { (maker) in
            maker.center.equalTo(imageInputBox.imageView)
        }
        submitIndicator.snp.makeConstraints { (maker) in
            maker.center.equalTo(submitButton)
        }
    }
    
    func setupClickEvents() {
        var imageInputTap = UITapGestureRecognizer(target: self, action: #selector(getReceiptPicture))
        imageInputBox.addGestureRecognizer(imageInputTap)
        submitButton.addTarget(self, action: #selector(submitReceipt), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLayoutSubviews() {
        phoneInputBox.bottomBorder(width: 0.5, borderColor: UIColor(red:0xbf/255,green:0xbf/255, blue:0xbf/255,alpha:1))
        nameInputBox.bottomBorder(width: 0.5, borderColor: UIColor(red:0xbf/255,green:0xbf/255, blue:0xbf/255,alpha:1))
        idInputBox.bottomBorder(width: 0.5, borderColor: UIColor(red:0xbf/255,green:0xbf/255, blue:0xbf/255,alpha:1))
    }
    
    @objc func getReceiptPicture() {
        var vc = AipGeneralVC.viewController { (image) in
            DispatchQueue.main.async {
                self.imageInputBox.imageView.image = image
                self.imageIndicator.startAnimating()
                BusinessPresenter.uploadImage(image:image!)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { (result) in
                        self.imageIndicator.stopAnimating()
                        if(result.code == 0) {
                            self.imageUrl = result.message
                        } else {
                            Toast(text: "图片上传失败").show()
                        }
                    })
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.present(vc!, animated: true, completion: nil)
    }
    
    @objc func submitReceipt() {
        var name = nameInputBox.textField.text
        var phone = phoneInputBox.textField.text
        var id = idInputBox.textField.text
        if (!checkNotNil(input:name, phone, id!,imageUrl)) {
            Toast(text: "请输入完整信息").show()
            return
        }
        name = name!.trimmingCharacters(in: .whitespaces)
        phone = phone!.trimmingCharacters(in: .whitespaces)
        id = id!.trimmingCharacters(in: .whitespaces)
        if (!checkNotEmpty(input:name!,phone!,id!,imageUrl!)) {
            Toast(text: "请输入完整信息").show()
            return
        }
        if (type == ReceiptItem.add) {
            submitIndicator.startAnimating()
            submitButton.isEnabled = false
            ReceiptPresenter.submitReceipt(name!, phone!, id!, imageUrl!)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (result) in
                    self.submitIndicator.stopAnimating()
                    self.submitButton.isEnabled = true
                    if(result.code == 0) {
                        Toast(text: "添加成功").show()
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        Toast(text: result.message).show()
                    }
                })
        } else if(type == ReceiptItem.edit) {
            if (name! == editableItem?.name! && phone! == editableItem?.phone! && id! == editableItem?.lottery_papers! && imageUrl! == editableItem?.lottery_papers_image!) {
                Toast(text: "未做任何修改").show()
                dismiss(animated: true, completion: nil)
            } else {
                submitIndicator.startAnimating()
                submitButton.isEnabled = false
                ReceiptPresenter.editReceipt(name!, phone!, id!, imageUrl!, editableItem!.id!)
                .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { (result) in
                        self.submitIndicator.stopAnimating()
                        self.submitButton.isEnabled = true
                        if(result.code == 0) {
                            Toast(text: "修改成功").show()
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            Toast(text: result.message).show()
                        }
                    })
            }
        }
    }
    
    @objc func close(_ sender:UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkNotNil(input:String?...) -> Bool{
        var result = true
        input.forEach { (item) in
            if (item == nil) {
                result = false
            }
        }
        return result
    }
    
    func checkNotEmpty(input:String...) -> Bool{
        var result = true
        input.forEach { (item) in
            if (item.isEmpty) {
                result = false
            }
        }
        return result
    }
    
    func checkImageNotNil(image:UIImage) -> Bool{
        if (image == nil) {
            return false
        } else {
            return true
        }
    }
}
