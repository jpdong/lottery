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
        tableView.register(ReceiptItemCell.self, forCellReuseIdentifier: "NoteItemCell")
        addNoteButton = UIView()
        addNoteButton.backgroundColor = UIColor.green
        buttonImageView = UIImageView(image:UIImage(named:""))
        addNoteButton.addSubview(buttonImageView)
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
            maker.height.equalTo(60)
        }
    }
    
    func setupEvents() {
        let addNoteTap = UITapGestureRecognizer(target: self, action: #selector(addNote))
        addNoteButton.addGestureRecognizer(addNoteTap)
        
    }
    
    @objc func refreshData() {
        currentPage = 1
        NotePresenter.getNoteList(pageIndex: currentPage, num: 10)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                self.tableView.es.stopPullToRefresh()
                //self.refreshControl.endRefreshing()
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
        NotePresenter.getNoteList(pageIndex: pageIndex, num: num)
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
        return noteItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "NoteItemCell"
        let item = noteItems[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,for: indexPath) as? NoteItemCell else {
            return UITableViewCell()
        }
        if (cell.titleLabel == nil) {
            cell.titleLabel = UILabel()
        }
        if (cell.dateLabel == nil) {
            cell.dateLabel = UILabel()
        }
//        cell.dateLabel.text = item.create_date
//        cell.noteLabel.text = item.notes
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
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
        NotePresenter.getNoteList(pageIndex: currentPage, num: 10)
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
    
    @objc func addNote() {
        let vc = AddNoteController()
        vc.type = NoteItem.add
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleleItem(row:Int) {
        noteItems.remove(at: row)
        tableView.reloadData()
    }
}
