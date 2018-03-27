//
//  AddNoteController.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import Toaster

class AddNoteController:UIViewController {
    
    
    var submitIndicator:UIActivityIndicatorView!
    var type:Int = NoteItem.add
    var editableItem:NoteItem?
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
        self.navigationItem.title = "添加"
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
        
        
        self.view.addSubview(submitIndicator)
        
        if (type == NoteItem.edit) {
            
            editNavigationItem.title = "编辑"
        }
    }
    
    func setupConstrains() {
        
        submitIndicator.snp.makeConstraints { (maker) in
            
        }
    }
    
    func setupClickEvents() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLayoutSubviews() {
        }
    
    
    
    @objc func submitNote() {
        
//        if (!checkNotNil(input:name, phone, id!,imageUrl)) {
//            Toast(text: "请输入完整信息").show()
//            return
//        }
//        name = name!.trimmingCharacters(in: .whitespaces)
//        phone = phone!.trimmingCharacters(in: .whitespaces)
//        id = id!.trimmingCharacters(in: .whitespaces)
//        if (!checkNotEmpty(input:name!,phone!,id!,imageUrl!)) {
//            Toast(text: "请输入完整信息").show()
//            return
//        }
//        if (type == NoteItem.add) {
//            submitIndicator.startAnimating()
//            submitButton.isEnabled = false
//            NotePresenter.submitNote(name!, phone!, id!, imageUrl!)
//                .observeOn(MainScheduler.instance)
//                .subscribe(onNext: { (result) in
//                    self.submitIndicator.stopAnimating()
//                    self.submitButton.isEnabled = true
//                    if(result.code == 0) {
//                        Toast(text: "添加成功").show()
//                        self.navigationController?.popViewController(animated: true)
//                    } else {
//                        Toast(text: result.message).show()
//                    }
//                })
//        } else if(type == NoteItem.edit) {
//            if (name! == editableItem?.name! && phone! == editableItem?.phone! && id! == editableItem?.lottery_papers! && imageUrl! == editableItem?.lottery_papers_image!) {
//                Toast(text: "未做任何修改").show()
//                dismiss(animated: true, completion: nil)
//            } else {
//                submitIndicator.startAnimating()
//                submitButton.isEnabled = false
//                NotePresenter.editNote(name!, phone!, id!, imageUrl!, editableItem!.id!)
//                .observeOn(MainScheduler.instance)
//                    .subscribe(onNext: { (result) in
//                        self.submitIndicator.stopAnimating()
//                        self.submitButton.isEnabled = true
//                        if(result.code == 0) {
//                            Toast(text: "修改成功").show()
//                            self.dismiss(animated: true, completion: nil)
//                        } else {
//                            Toast(text: result.message).show()
//                        }
//                    })
//            }
//        }
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
