//
//  ReceiptListController.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import Toaster
import ESPullToRefresh

class ReceiptListController:UIViewController ,UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var searchBar:UISearchBar!
    var tableView:UITableView!
    var currentPage:Int = 1
    
    var receiptItems = [ReceiptItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstrains()
        refreshData()
    }
    
    func setupViews() {
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "收据管理"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addReceipt))
        self.navigationItem.rightBarButtonItem = addButton
        searchBar = UISearchBar()
        tableView = UITableView()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 120
        tableView.register(ReceiptItemCell.self, forCellReuseIdentifier: "ReceiptItemCell")
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
        
        tableView.es.addPullToRefresh {
            self.refreshData()
        }
        tableView.es.addInfiniteScrolling {
            self.loadMore()
        }
    }
    
    func setupConstrains() {
        searchBar.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.view).offset(Size.instance.statusBarHeight + Size.instance.navigationBarHeight)
            maker.left.right.equalTo(self.view)
        }
        
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(searchBar.snp.bottom)
            maker.left.right.equalTo(self.view)
            maker.bottom.equalTo(self.view)
        }
    }
    
    @objc func refreshData() {
        currentPage = 1
        ReceiptPresenter.getReceiptList(pageIndex: currentPage, num: 10)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                self.tableView.es.stopPullToRefresh()
                //self.refreshControl.endRefreshing()
                if (result.code == 0) {
                    self.receiptItems.removeAll()
                    self.receiptItems = self.receiptItems + result.list!
                    Log(result.list)
                    Log(self.receiptItems)
                    self.tableView.reloadData()
                }
            })
    }
    
    func setupData(_ pageIndex:Int, _ num:Int) {
        ReceiptPresenter.getReceiptList(pageIndex: pageIndex, num: num)
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                if (result.code == 0) {
                    self.receiptItems = self.receiptItems + result.list!
                    Log(result.list)
                    Log(self.receiptItems)
                    self.tableView.reloadData()
                }
            })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Log(searchText)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receiptItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ReceiptItemCell"
        let item = receiptItems[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,for: indexPath) as? ReceiptItemCell
        if (cell!.nameLabel == nil) {
            cell!.nameTitle = UILabel()
        }
        if (cell!.phoneTitle == nil) {
            cell!.phoneTitle = UILabel()
        }
        if (cell!.idTitle == nil) {
            cell!.idTitle = UILabel()
        }
        if (cell!.nameLabel == nil) {
            cell!.nameLabel = UILabel()
        }
        if (cell!.phoneLabel == nil) {
            cell!.phoneLabel = UILabel()
        }
        if (cell!.idLabel == nil) {
            cell!.idLabel = UILabel()
        }
        if (cell!.pictureView == nil) {
            cell!.pictureView = UIImageView()
        }
        cell!.nameTitle.text = "店主姓名："
        cell!.phoneTitle.text = "手机号码："
        cell!.idTitle.text = "代销证号："
        cell!.nameLabel.text = item.name
        cell!.phoneLabel.text = item.phone
        cell!.idLabel.text = item.lottery_papers
        cell!.pictureView.contentMode = .scaleAspectFit
        cell!.pictureView.kf.setImage(with: URL(string:item.lottery_papers_image!))
        cell!.selectionStyle = UITableViewCellSelectionStyle.none
        print("------ row:\(indexPath.row), count:\(receiptItems.count)")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ReceiptDetailController()
        vc.receiptItem = receiptItems[indexPath.row]
        vc.preViewController = self
        vc.rowInParent = indexPath.row
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadMore() {
        print("load more")
        currentPage = currentPage + 1
        ReceiptPresenter.getReceiptList(pageIndex: currentPage, num: 10)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                if (result.code == 0) {
                    guard let list = result.list as? [ReceiptItem] else {
                        Toast(text: "无更多数据").show()
                        
                        self.tableView.es.stopLoadingMore()
                        self.currentPage = self.currentPage - 1
                        return
                    }
                    if (result.list!.count > 0) {
                        self.receiptItems = self.receiptItems + result.list!
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
    
    func updataData(row:Int, item:ReceiptItem) {
        receiptItems[row] = item
        tableView.reloadData()
    }
    
    @objc func addReceipt() {
//        let vc = AddReceiptController()
//        vc.type = ReceiptItem.add
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleleItem(row:Int) {
        receiptItems.remove(at: row)
        tableView.reloadData()
    }
}
