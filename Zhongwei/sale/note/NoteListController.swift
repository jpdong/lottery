//
//  NoteListController.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import Toaster
import ESPullToRefresh

class NoteListController:UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView:UITableView!
    var currentPage:Int = 1
    var noteItems = [NoteItem]()
    var addNoteButton:UIView!
    var buttonImageView:UIImageView!
    var shopId:String?
    var addNoteLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstrains()
        setupEvents()
        refreshData()
    }
    
    func setupViews() {
        self.view.backgroundColor = UIColor.white
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.register(NoteItemCell.self, forCellReuseIdentifier: "NoteItemCell")
        addNoteButton = UIView()
        //addNoteButton.backgroundColor = UIColor.gray
        addNoteLabel = UILabel()
        addNoteLabel.text = "添加备注"
        addNoteLabel.font = UIFont.systemFont(ofSize: 10)
        addNoteLabel.textColor = UIColor.gray
        buttonImageView = UIImageView(image:UIImage(named:"button_add_note"))
        addNoteButton.addSubview(buttonImageView)
        addNoteButton.addSubview(addNoteLabel)
        self.view.addSubview(addNoteButton)
        self.view.addSubview(tableView)
        
        tableView.es.addPullToRefresh {
            self.refreshData()
        }
        tableView.es.addInfiniteScrolling {
            self.loadMore()
        }
    }
    
    func setupConstrains() {
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.view)
            maker.left.right.equalTo(self.view)
            maker.bottom.equalTo(addNoteButton.snp.top)
        }
        addNoteButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(tableView.snp.bottom)
            maker.bottom.left.right.equalTo(self.view)
            maker.height.equalTo(50)
        }
        buttonImageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(addNoteButton).offset(8)
            maker.centerX.equalTo(addNoteButton)
            maker.width.height.equalTo(20)
        }
        addNoteLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(buttonImageView.snp.bottom)
            maker.centerX.equalTo(addNoteButton)
            maker.height.equalTo(20)
        }
    }
    
    func setupEvents() {
        let addNoteTap = UITapGestureRecognizer(target: self, action: #selector(addNote))
        addNoteButton.addGestureRecognizer(addNoteTap)
        
    }
    
    @objc func refreshData() {
        currentPage = 1
        NotePresenter.getNoteList(pageIndex: currentPage, num: 10,shopId:shopId!)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                self.tableView.es.stopPullToRefresh()
                if (result.code == 0) {
                    self.noteItems.removeAll()
                    self.noteItems = self.noteItems + result.list!
                    Log(result.list)
                    Log(self.noteItems)
                    self.tableView.reloadData()
                }
            })
    }
    
    func setupData(_ pageIndex:Int, _ num:Int) {
        NotePresenter.getNoteList(pageIndex: pageIndex, num: num,shopId:shopId!)
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                if (result.code == 0) {
                    self.noteItems = self.noteItems + result.list!
                    Log(result.list)
                    Log(self.noteItems)
                    self.tableView.reloadData()
                }
            })
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Log(noteItems.count)
        return noteItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "NoteItemCell"
        let item = noteItems[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,for: indexPath) as? NoteItemCell else {
            return UITableViewCell()
        }
        if (cell.noteLabel == nil) {
            cell.noteLabel = UILabel()
        }
        if (cell.dateLabel == nil) {
            cell.dateLabel = UILabel()
        }
        Log(cell.dateLabel.text)
        cell.dateLabel.text = getTime(item.create_date!) ?? ""
        cell.noteLabel.text = item.question
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
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
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = NoteDetailController()
        vc.noteItem = noteItems[indexPath.row]
        vc.preViewController = self
        vc.rowInParent = indexPath.row
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadMore() {
        print("load more")
        currentPage = currentPage + 1
        NotePresenter.getNoteList(pageIndex: currentPage, num: 10,shopId:shopId!)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                if (result.code == 0) {
                    guard let list = result.list as? [NoteItem] else {
                        Toast(text: "无更多数据").show()
                        self.tableView.es.stopLoadingMore()
                        self.currentPage = self.currentPage - 1
                        return
                    }
                    if (result.list!.count > 0) {
                        self.noteItems = self.noteItems + result.list!
                        self.tableView.reloadData()
                        self.tableView.es.stopLoadingMore()
                    } else {
                        Toast(text: "无更多数据").show()
                        self.tableView.es.stopLoadingMore()
                        self.currentPage = self.currentPage - 1
                    }
                }
            })
    }
    
    func updataData(row:Int, item:NoteItem) {
        noteItems[row] = item
        tableView.reloadData()
    }
    
    func setShopId(id:String) {
        shopId = id
    }
    
    @objc func addNote() {
        let vc = AddNoteController()
        vc.type = NoteItem.add
        vc.shopId = shopId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleleItem(row:Int) {
        noteItems.remove(at: row)
        tableView.reloadData()
    }
}
