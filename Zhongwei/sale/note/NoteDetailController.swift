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
    
    var noteTextView:UITextView!
    var noteItem:NoteItem?
    var scrollView:UIScrollView!
    var preViewController:NoteListController?
    var rowInParent:Int?
    var dataBackground:UIImageView!
    var textBackground:UIImageView!
    var dateLabel:UILabel!
    
    override func viewDidLoad() {
        setupViews()
        setupConstrains()
        setupClickEvents()
    }
    
    func setupViews() {
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "详情"
        let optionButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(showOptionList))
        self.navigationItem.rightBarButtonItem = optionButton
        scrollView = UIScrollView(frame:self.view.bounds)
        dataBackground = UIImageView(image:UIImage(named:"background_note_date"))
        textBackground = UIImageView(image:UIImage(named:"background_note_text"))
        noteTextView = UITextView()
        noteTextView.isEditable = false
        noteTextView.backgroundColor = UIColor.clear
        noteTextView.font = UIFont.systemFont(ofSize: 17)
        noteTextView.text = noteItem?.note
        dateLabel = UILabel()
        dateLabel.text = getTime(noteItem?.createDate ?? "")
        
        self.view.addSubview(dataBackground)
        self.view.addSubview(textBackground)
        self.view.addSubview(noteTextView)
        self.view.addSubview(dateLabel)
        //self.view.addSubview(scrollView)
    }
    
    func setupConstrains() {
//        scrollView.snp.makeConstraints { (maker) in
//            maker.top.equalTo(self.view).offset(Size.instance.statusBarHeight + Size.instance.navigationBarHeight)
//            maker.left.right.equalTo(self.view)
//            maker.width.equalTo(self.view)
//            maker.height.greaterThanOrEqualTo(self.view)
//            maker.bottom.equalTo(noteTextView)
//        }
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
    
    override func viewWillAppear(_ animated: Bool) {
        updateData()
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width:self.view.frame.width, height:noteTextView.frame.maxY + noteTextView.frame.height)
        scrollView.setNeedsLayout()
        scrollView.layoutIfNeeded()
        
    }
    
    @objc func showOptionList() {
        let optionView = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "编辑", style: .default) { (action) in
            let vc = AddNoteController()
            vc.type = NoteItem.edit
            vc.editableItem = self.noteItem
            //self.present(vc, animated: true, completion: nil)
            self.navigationController?.pushViewController(vc, animated: true)
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
                    if let data = result.data {
                        self.updateView(data:data)
                        self.preViewController?.updataData(row: self.rowInParent!, item: self.noteItem!)
                    }
                }
            })
        
    }
    
    func updateView(data:NoteItem) {
        noteItem = data
        noteTextView.text = noteItem?.note
        
    }
    
}
