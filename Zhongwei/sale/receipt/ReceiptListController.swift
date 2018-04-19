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

class ReceiptListController:UIViewController, UITableViewDataSource, UITableViewDelegate, TZImagePickerControllerDelegate {
    
    var tableView:UITableView!
    var currentPage:Int = 1
    
    var receiptItems = [ReceiptItem]()
    var presenter:ReceiptPresenter!
    var disposeBag:DisposeBag!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disposeBag = DisposeBag()
        presenter = ReceiptPresenter()
        setupViews()
        setupConstrains()
        refreshData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.disposeBag = nil
    }
    
    func setupViews() {
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "收据管理"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addReceipt))
        self.navigationItem.rightBarButtonItem = addButton
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 120
        tableView.tableFooterView = UIView(frame:.zero)
        tableView.register(ReceiptItemCell.self, forCellReuseIdentifier: "ReceiptItemCell")
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
        presenter.getReceiptList(pageIndex: currentPage, num: 10)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                self.tableView.es.stopPullToRefresh()
                if (result.code == 0) {
                    if let list = result.list {
                        self.receiptItems.removeAll()
                        self.receiptItems = self.receiptItems + list
                        self.tableView.reloadData()
                    }
                }
            }, onCompleted: {
                Log("onCompleted")
            }, onDisposed: {
                Log("onDisposed")
            })
        .disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receiptItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ReceiptItemCell"
        let item = receiptItems[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,for: indexPath) as? ReceiptItemCell else {
            Log("cell is nil")
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
        cell.dateLabel.text = item.createDate
        cell.noteLabel.text = item.notes
        if (item.image!.image!.count != 0 ){
            cell.pictureView.kf.setImage(with: URL(string:item.image?.image?[0] ?? ""))
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ReceiptDetailController()
        vc.receiptItem = receiptItems[indexPath.row]
        vc.preViewController = self
        vc.rowInParent = indexPath.row
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadMore() {
        currentPage = currentPage + 1
        presenter.getReceiptList(pageIndex: currentPage, num: 10)
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
        .disposed(by: disposeBag)
    }
    
    func updataData(row:Int, item:ReceiptItem) {
        receiptItems[row] = item
        tableView.reloadData()
    }
    
    @objc func addReceipt() {
//        let vc:TZImagePickerController = TZImagePickerController.init(maxImagesCount: 6, delegate: self)
//        self.present(vc, animated: true, completion: nil)
        
        let vc = AddReceiptController()
        vc.type = ReceiptItem.add
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleleItem(row:Int) {
        receiptItems.remove(at: row)
        tableView.reloadData()
    }
}
