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
    
    var noteTextView:UITextView!
    var submitIndicator:UIActivityIndicatorView!
    var type:Int = NoteItem.add
    var editableItem:NoteItem?
    var navigationBarHeight:CGFloat?
    var statusBarHeight:CGFloat?
    var closeButton:UIBarButtonItem!
    var navigationBar:UINavigationBar!
    var editNavigationItem:UINavigationItem!
    var optionButton:UIBarButtonItem!
    var shopId:String?
    var noteItem:NoteItem?
    
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
        
        self.navigationItem.title = "添加"
        optionButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(submitNote))
        self.navigationItem.rightBarButtonItem = optionButton
        submitIndicator = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.whiteLarge)
        self.view.addSubview(submitIndicator)
        noteTextView = UITextView()
        self.view.addSubview(noteTextView)
        
        if (type == NoteItem.edit) {
            noteTextView.text = editableItem?.question
            editNavigationItem.title = "编辑"
        }
    }
    
    func setupConstrains() {
        noteTextView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.view).offset(Size.instance.statusBarHeight + Size.instance.navigationBarHeight)
            maker.left.right.bottom.equalTo(self.view)
        }
        submitIndicator.snp.makeConstraints { (maker) in
            maker.center.equalTo(self.view)
        }
    }
    
    func setupClickEvents() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    
    
    @objc func submitNote() {
        var note = noteTextView.text
        
        if (!checkNotNil(input:note)) {
            Toast(text: "请输入完整信息").show()
            return
        }
        note = note!.trimmingCharacters(in: .whitespaces)
        if (!checkNotEmpty(input:note!)) {
            Toast(text: "请输入完整信息").show()
            return
        }
        if (type == NoteItem.add) {
            submitIndicator.startAnimating()
            optionButton.isEnabled = false
            NotePresenter.submitNote(note:note!, shopId:shopId!)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (result) in
                    self.submitIndicator.stopAnimating()
                    self.optionButton.isEnabled = true
                    if(result.code == 0) {
                        Toast(text: "添加成功").show()
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        Toast(text: result.message).show()
                    }
                })
        } else if(type == NoteItem.edit) {
            if (note! == editableItem?.question) {
                Toast(text: "未做任何修改").show()
                //dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            } else {
                submitIndicator.startAnimating()
                optionButton.isEnabled = false
                NotePresenter.editNote(note:note!,noteId:editableItem!.id!)
                .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { (result) in
                        self.submitIndicator.stopAnimating()
                        self.optionButton.isEnabled = true
                        if(result.code == 0) {
                            Toast(text: "修改成功").show()
                            //self.dismiss(animated: true, completion: nil)
                            self.navigationController?.popViewController(animated: true)
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
