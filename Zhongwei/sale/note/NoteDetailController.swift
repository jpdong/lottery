//
//  NoteDetailController.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import Toaster
import SnapKit

class NoteDetailController:UIViewController {
    var nameInputBox:TextInfoBoxView!
    var phoneInputBox:TextInfoBoxView!
    var idInputBox:TextInfoBoxView!
    var imageInputBox:ImageInputBoxView!
    var addressInfoBox:TextInfoBoxView!
    var submitButton:UIButton!
    var submitIndicator:UIActivityIndicatorView!
    var imageIndicator:UIActivityIndicatorView!
    var imageUrl:String?
    var noteItem:NoteItem?
    var scrollView:UIScrollView!
    var preViewController:NoteListController?
    var rowInParent:Int?
    
    override func viewDidLoad() {
        setupViews()
        setupConstrains()
        setupClickEvents()
    }
    
    func setupViews() {
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.title = "代销证详情"
        let optionButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(showOptionList))
        self.navigationItem.rightBarButtonItem = optionButton
        scrollView = UIScrollView(frame:self.view.bounds)

        nameInputBox = TextInfoBoxView()
        nameInputBox.titleLabel.text = "店主姓名"
        nameInputBox.messageLabel.text = noteItem?.name

        phoneInputBox = TextInfoBoxView()
        phoneInputBox.titleLabel.text = "手机号码"
        phoneInputBox.messageLabel.text = noteItem?.phone

        idInputBox = TextInfoBoxView()
        idInputBox.titleLabel.text = "代销证号"
        idInputBox.messageLabel.text = noteItem?.lottery_papers

        addressInfoBox = TextInfoBoxView()
        addressInfoBox.titleLabel.text = "店铺地址"
        addressInfoBox.messageLabel.text = noteItem?.address

        imageInputBox = ImageInputBoxView()
        imageInputBox.titleLabel.text = "代销证照片"
        imageInputBox.imageView.kf.setImage(with: URL(string:noteItem!.lottery_papers_image!))
        
        scrollView.addSubview(nameInputBox)
        scrollView.addSubview(phoneInputBox)
        scrollView.addSubview(idInputBox)
        scrollView.addSubview(addressInfoBox)
        scrollView.addSubview(imageInputBox)
        
        self.view.addSubview(scrollView)
    }
    
    func setupConstrains() {
        scrollView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.view).offset(Size.instance.statusBarHeight + Size.instance.navigationBarHeight)
            maker.left.right.equalTo(self.view)
            maker.width.equalTo(self.view)
            maker.height.greaterThanOrEqualTo(self.view)
            maker.bottom.equalTo(imageInputBox)
        }
        nameInputBox.snp.makeConstraints { (maker) in
            maker.height.equalTo(60)
            maker.top.equalTo(scrollView)
            maker.left.equalTo(scrollView).offset(16)
            maker.width.equalTo(scrollView)
        }
        phoneInputBox.snp.makeConstraints { (maker) in
            maker.height.equalTo(60)
            maker.top.equalTo(nameInputBox.snp.bottom)
            maker.left.equalTo(scrollView).offset(16)
            maker.width.equalTo(scrollView)
        }
        idInputBox.snp.makeConstraints { (maker) in
            maker.height.equalTo(60)
            maker.top.equalTo(phoneInputBox.snp.bottom)
            maker.left.equalTo(scrollView).offset(16)
            maker.width.equalTo(scrollView)
        }
        addressInfoBox.snp.makeConstraints { (maker) in
            maker.height.equalTo(60)
            maker.top.equalTo(idInputBox.snp.bottom)
            maker.left.equalTo(scrollView).offset(16)
            maker.right.equalTo(self.view).offset(-8)
        }
        imageInputBox.snp.makeConstraints { (maker) in
            maker.height.equalTo(200)
            maker.top.equalTo(addressInfoBox.snp.bottom)
            maker.left.equalTo(scrollView).offset(16)
            maker.right.equalTo(self.view)
        }
        
    }
    
    func setupClickEvents() {

    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateData()
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width:self.view.frame.width, height:imageInputBox.frame.maxY + imageInputBox.frame.height)
        scrollView.setNeedsLayout()
        scrollView.layoutIfNeeded()
        phoneInputBox.bottomBorder(width: 0.5, borderColor: UIColor(red:0xbf/255,green:0xbf/255, blue:0xbf/255,alpha:1))
        nameInputBox.bottomBorder(width: 0.5, borderColor: UIColor(red:0xbf/255,green:0xbf/255, blue:0xbf/255,alpha:1))
        idInputBox.bottomBorder(width: 0.5, borderColor: UIColor(red:0xbf/255,green:0xbf/255, blue:0xbf/255,alpha:1))
        addressInfoBox.bottomBorder(width: 0.5, borderColor: UIColor(red:0xbf/255,green:0xbf/255, blue:0xbf/255,alpha:1))
    }
    
    @objc func showOptionList() {
        let optionView = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "编辑", style: .default) { (action) in
            let vc = AddNoteController()
            vc.type = NoteItem.edit
            vc.editableItem = self.noteItem
            self.present(vc, animated: true, completion: nil)
        }
        let deleteAction = UIAlertAction(title: "删除", style: .default) { (action) in
            NotePresenter.deleteNote(id:self.noteItem!.id!)
            .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (result) in
                    if (result.code == 0) {
                        Toast(text: "删除成功").show()
                        self.preViewController?.deleleItem(row:self.rowInParent!)
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        Toast(text:"删除失败：\(result.message)")
                    }
                })
        }
        let cacelAction = UIAlertAction(title: "取消", style:.cancel) { (action) in
            
        }
        optionView.addAction(editAction)
        optionView.addAction(deleteAction)
        optionView.addAction(cacelAction)
        present(optionView, animated: true, completion: nil)
    }
    
    func updateData() {
        NotePresenter.getDetailWithId(noteItem!.id!)
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                if (result.code == 0) {
                    self.updateView(data:result.data!)
                    self.preViewController?.updataData(row: self.rowInParent!, item: self.noteItem!)
                }
            })
        
    }
    
    func updateView(data:NoteItem) {
        noteItem = data
        nameInputBox.messageLabel.text = data.name
        phoneInputBox.messageLabel.text = data.phone
        idInputBox.messageLabel.text = data.lottery_papers
        addressInfoBox.messageLabel.text = data.address
        imageInputBox.imageView.kf.setImage(with: URL(string:data.lottery_papers_image!))
    }
    
}
