//
//  VisitListController.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import Toaster
import ESPullToRefresh

class VisitListController:UIViewController, UITableViewDataSource, UITableViewDelegate, TZImagePickerControllerDelegate {
    
    var tableView:UITableView!
    var currentPage:Int = 1
    
    var visitItems = [VisitItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstrains()
        refreshData()
    }
    
    func setupViews() {
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "走访记录"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addVisit))
        self.navigationItem.rightBarButtonItem = addButton
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 120
        tableView.register(VisitItemCell.self, forCellReuseIdentifier: "VisitItemCell")
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
            maker.top.equalTo(self.view).offset(Size.instance.statusBarHeight + Size.instance.navigationBarHeight)
            maker.left.right.equalTo(self.view)
            maker.bottom.equalTo(self.view)
        }
    }
    
    @objc func refreshData() {
        currentPage = 1
        VisitPresenter.getVisitList(pageIndex: currentPage, num: 10)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                self.tableView.es.stopPullToRefresh()
                //self.refreshControl.endRefreshing()
                if (result.code == 0) {
                    self.visitItems.removeAll()
                    self.visitItems = self.visitItems + result.list!
                    Log(result.list)
                    Log(self.visitItems)
                    self.tableView.reloadData()
                }
            })
    }
    
    func setupData(_ pageIndex:Int, _ num:Int) {
        VisitPresenter.getVisitList(pageIndex: pageIndex, num: num)
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                if (result.code == 0) {
                    self.visitItems = self.visitItems + result.list!
                    Log(result.list)
                    Log(self.visitItems)
                    self.tableView.reloadData()
                }
            })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visitItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "VisitItemCell"
        let item = visitItems[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,for: indexPath) as? VisitItemCell else {
            return UITableViewCell()
        }
        if (cell.dateLabel == nil) {
            cell.dateLabel = UILabel()
        }
        if (cell.noteLabel == nil) {
            cell.noteLabel = UILabel()
        }
        
        if (cell.pictureView == nil) {
            cell.pictureView = UIImageView()
        }
        cell.dateLabel.text = item.create_date
        cell.noteLabel.text = item.notes
//        if (item.Visit_image!.Visit_image!.count != 0 ){
//            cell.pictureView.kf.setImage(with: URL(string:item.Visit_image!.Visit_image![0]))
//        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = VisitDetailController()
//        vc.visitItem = visitItems[indexPath.row]
//        vc.preViewController = self
//        vc.rowInParent = indexPath.row
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadMore() {
        print("load more")
        currentPage = currentPage + 1
        VisitPresenter.getVisitList(pageIndex: currentPage, num: 10)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                if (result.code == 0) {
                    guard let list = result.list as? [VisitItem] else {
                        Toast(text: "无更多数据").show()
                        
                        self.tableView.es.stopLoadingMore()
                        self.currentPage = self.currentPage - 1
                        return
                    }
                    if (result.list!.count > 0) {
                        self.visitItems = self.visitItems + result.list!
                        self.tableView.reloadData()
                        self.tableView.es.stopLoadingMore()
                    } else {
                        Toast(text: "无更多数据").show()
                        self.tableView.es.stopLoadingMore()
                        self.currentPage = self.currentPage - 1
                        //self.tableView.scrollToRow(at: IndexPath(), at:UITableViewScrollPosition.middle, animated: true)
                    }
                }
            })
    }
    
    func updataData(row:Int, item:VisitItem) {
        visitItems[row] = item
        tableView.reloadData()
    }
    
    @objc func addVisit() {
//        let vc:TZImagePickerController = TZImagePickerController.init(maxImagesCount: 6, delegate: self)
//        self.present(vc, animated: true, completion: nil)
        
        if (true) {
            let vc = SearchViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = AddVisitRecordController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    
    
    
    
    func deleleItem(row:Int) {
        visitItems.remove(at: row)
        tableView.reloadData()
    }
}