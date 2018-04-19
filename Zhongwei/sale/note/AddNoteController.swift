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
    var navigationBarHeight:CGFloat!
    var statusBarHeight:CGFloat!
    var closeButton:UIBarButtonItem!
    var navigationBar:UINavigationBar!
    var editNavigationItem:UINavigationItem!
    var optionButton:UIBarButtonItem!
    var shopId:String?
    var noteItem:NoteItem?
    var dataBackground:UIImageView!
    var textBackground:UIImageView!
    var dateLabel:UILabel!
    var presenter:NotePresenter!
    var disposeBag:DisposeBag!
    
    override func viewDidLoad() {
        disposeBag = DisposeBag()
        presenter = NotePresenter()
        setupViews()
        setupConstrains()
        setupClickEvents()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.disposeBag = nil
    }
    
    func setupViews() {
        self.navigationItem.title = "添加"
        navigationBarHeight = Size.instance.navigationBarHeight
        statusBarHeight = Size.instance.statusBarHeight
        navigationBar = UINavigationBar(frame:CGRect( x:0,y:statusBarHeight, width:self.view.frame.width, height:navigationBarHeight))
        editNavigationItem = UINavigationItem()
        closeButton = UIBarButtonItem(title:"", style:.plain, target:self, action:#selector(close))
        closeButton.image = UIImage(named:"closeButton")
        closeButton.tintColor = UIColor.black
        editNavigationItem.setRightBarButton(closeButton, animated: true)
        navigationBar?.pushItem(editNavigationItem, animated: true)
        self.view.addSubview(navigationBar)
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.title = "添加"
        optionButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(submitNote))
        self.navigationItem.rightBarButtonItem = optionButton
        submitIndicator = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.whiteLarge)
        self.view.addSubview(submitIndicator)
        noteTextView = UITextView()
        noteTextView.backgroundColor = UIColor.clear
        noteTextView.font = UIFont.systemFont(ofSize: 17)
        
        dataBackground = UIImageView(image:UIImage(named:"background_note_date"))
        textBackground = UIImageView(image:UIImage(named:"background_note_text"))
        self.view.addSubview(dataBackground)
        self.view.addSubview(textBackground)
        self.view.addSubview(noteTextView)
        dateLabel = UILabel()
        let now = Date()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = String(timeInterval)
        dateLabel.text = getTime(timeStamp ?? "")
        self.view.addSubview(dateLabel)
        if (type == NoteItem.edit) {
            noteTextView.text = editableItem?.note
            editNavigationItem.title = "编辑"
            dateLabel.text = getTime(editableItem?.createDate ?? "")
        }
    }
    
    func setupConstrains() {
        dataBackground.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.view).offset(Size.instance.statusBarHeight + Size.instance.navigationBarHeight)
            maker.left.equalTo(self.view)
            maker.right.equalTo(self.view)
            maker.height.equalTo(80)
        }
        textBackground.snp.makeConstraints { (maker) in
            maker.top.equalTo(dataBackground.snp.bottom)
            maker.left.equalTo(self.view)
            maker.right.equalTo(self.view)
            maker.bottom.equalTo(self.view).offset(-8)
        }
        noteTextView.snp.makeConstraints { (maker) in
            maker.top.equalTo(textBackground)
            maker.left.equalTo(textBackground).offset(20)
            maker.right.equalTo(textBackground).offset(-20)
            maker.bottom.equalTo(textBackground).offset(-20)
        }
        
        dateLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(dataBackground).offset(30)
            maker.bottom.equalTo(dataBackground).offset(-30)
        }
    }
    
    func setupClickEvents() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    func getTime(_ time:String) -> String {
        var timeString:String
        if (time.count >= 10) {
            timeString = time.subString(start: 0, length: 10)
        } else {
            return ""
        }
        let timeInterval:TimeInterval = TimeInterval(timeString)!
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm yyyy/MM/dd"
        return dateFormatter.string(from: date)
    }
    
    @objc func submitNote() {
        var note = ""
        guard let text = noteTextView.text else{
            Toast(text: "请输入完整信息").show()
            return
        }
        note = text.trimmingCharacters(in: .whitespaces)
        if (!checkNotEmpty(input:note)) {
            Toast(text: "请输入完整信息").show()
            return
        }
        if (type == NoteItem.add) {
            submitIndicator.startAnimating()
            optionButton.isEnabled = false
            presenter.submitNote(note:note, shopId:shopId!)
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
            .disposed(by: self.disposeBag)
        } else if(type == NoteItem.edit) {
            if (note == editableItem?.note) {
                Toast(text: "未做任何修改").show()
                //dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            } else {
                submitIndicator.startAnimating()
                optionButton.isEnabled = false
                presenter.editNote(note:note,noteId:editableItem!.id!)
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
                .disposed(by: self.disposeBag)
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
