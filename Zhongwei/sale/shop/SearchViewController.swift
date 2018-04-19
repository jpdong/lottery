//
//  SearchViewController.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/26.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import Toaster
import ESPullToRefresh

class SearchViewController:UIViewController ,UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    static let search = 1
    static let history = 2
    
    var searchBar:UISearchBar!
    var tableView:UITableView!
    var currentPage:Int = 1
    var currentHistoryPage:Int = 1
    var historyHeaderView:UIView!
    var listType:Int = SearchViewController.history
    var historyTitle:UILabel!
    var deleteHistoryButton:UIImageView!
    var presenter:ShopPresenter!
    var disposeBag:DisposeBag!
    
    var currentKey:String = "" {
        willSet {
            if (newValue == "") {
                self.tableView.tableHeaderView = historyHeaderView
                self.showHistory()
                listType = SearchViewController.history
            }
        }
    }
    
    var shopItems = [ShopItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disposeBag = DisposeBag()
        presenter = ShopPresenter()
        setupViews()
        setupConstrains()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.disposeBag = nil
    }
    
    func setupViews() {
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "选择店铺"
        searchBar = UISearchBar()
        tableView = UITableView()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 120
        tableView.tableFooterView = UIView(frame:.zero)
        tableView.register(ShopItemCell.self, forCellReuseIdentifier: "ShopItemCell")
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
        historyHeaderView = UIView(frame:CGRect(x:0,y:0, width:self.view.frame.width, height:50))
        historyTitle = UILabel()
        historyTitle.textColor = UIColor.gray
        historyTitle.text = "访问历史"
        deleteHistoryButton = UIImageView()
        deleteHistoryButton.contentMode = .scaleAspectFit
        deleteHistoryButton.image = UIImage(named:"button_delete_history")
        deleteHistoryButton.isUserInteractionEnabled = true
        deleteHistoryButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteHistory)))
        historyHeaderView.addSubview(historyTitle)
        historyHeaderView.addSubview(deleteHistoryButton)
        tableView.tableHeaderView = historyHeaderView
        showHistory()
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
        historyTitle.snp.makeConstraints { (maker) in
            maker.left.equalTo(historyHeaderView).offset(16)
            maker.centerY.equalTo(historyHeaderView)
        }
        deleteHistoryButton.snp.makeConstraints { (maker) in
            maker.right.equalTo(historyHeaderView).offset(-16)
            maker.centerY.equalTo(historyHeaderView)
            maker.width.height.equalTo(20)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Log(searchText)
        if (searchText == "") {
            tableView.es.removeRefreshFooter()
            return
        }
        
        tableView.es.addInfiniteScrolling {
            self.loadMore()
        }
        listType = SearchViewController.search
        tableView.tableHeaderView = UIView(frame:.zero)
        currentPage = 1
        presenter.searchShopList(pageIndex: currentPage, num: 10, key:searchText)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                if (result.code == 0) {
                    self.shopItems.removeAll()
                    self.shopItems = self.shopItems + result.list!
                    Log(result.list)
                    Log(self.shopItems)
                    self.tableView.reloadData()
                }
            })
        .disposed(by: disposeBag)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ShopItemCell"
        let item = shopItems[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,for: indexPath) as? ShopItemCell else {
            return UITableViewCell()
        }
        if (cell.shopLabel == nil) {
            cell.shopLabel = UILabel()
        }
        if (cell.shopInfoView == nil) {
            cell.shopInfoView = ShopInfoView()
        }
        cell.shopLabel.text = item.club_name ?? ""
        cell.shopInfoView.nameLabel.text = item.name ?? ""
        cell.shopInfoView.phoneLabel.text = item.phone ?? ""
        cell.shopInfoView.addressLabel.text = item.address ?? ""
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AddVisitRecordController()
        vc.shopItem = shopItems[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadMore() {
        print("load more")
        if (listType == SearchViewController.search) {
        currentPage = currentPage + 1
        presenter.searchShopList(pageIndex: currentPage, num: 10, key:currentKey)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                if (result.code == 0) {
                    guard let list = result.list as? [CertificateItem] else {
                        Toast(text: "无更多数据").show()
                        self.tableView.es.stopLoadingMore()
                        self.currentPage = self.currentPage - 1
                        return
                    }
                    if (list.count > 0) {
                        self.shopItems = self.shopItems + result.list!
                        self.tableView.reloadData()
                        self.tableView.es.stopLoadingMore()
                    } else {
                        Toast(text: "无更多数据").show()
                        self.tableView.es.stopLoadingMore()
                        self.currentPage = self.currentPage - 1
                    }
                }
            })
            .disposed(by: disposeBag)
        }
    }
    
    func showHistory() {
        presenter.getDBShopHistory(pageIndex: currentHistoryPage, num: 10)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                if (result.code == 0) {
                    self.shopItems.removeAll()
                    self.shopItems = self.shopItems + result.list!
                    Log(self.shopItems)
                    self.tableView.reloadData()
                }
            })
        .disposed(by: disposeBag)
    }
    
    func updataData(row:Int, item:ShopItem) {
        shopItems[row] = item
        tableView.reloadData()
    }
    
    @objc func deleteHistory() {
        CoreDataHelper.instance.deleteHistory()
        shopItems.removeAll()
        tableView.reloadData()
    }
    
    @objc func addCertificate() {
        let vc = AddCertificateController()
        vc.type = CertificateItem.add
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleleItem(row:Int) {
        shopItems.remove(at: row)
        tableView.reloadData()
    }
}

