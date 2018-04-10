//
//  CertificateListController.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import Toaster
import ESPullToRefresh

class CertificateListController:UIViewController ,UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var searchBar:UISearchBar!
    var tableView:UITableView!
    var refreshControl:UIRefreshControl!
    var loadMoreView:UIView!
    var loadMoreEnable = true
    var currentPage:Int = 1
    
    var certificateItems = [CertificateItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstrains()
        refreshData()
    }
    
    func setupViews() {
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "代销证管理"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCertificate))
        self.navigationItem.rightBarButtonItem = addButton
        searchBar = UISearchBar()
        tableView = UITableView()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 120
        tableView.tableFooterView = UIView(frame:.zero)
        tableView.register(CertificateItemCell.self, forCellReuseIdentifier: "CertificateItemCell")
        setupLoadMoreView()
        //tableView.tableFooterView = loadMoreView
        //refreshControl = UIRefreshControl()
        //refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        //refreshControl.attributedTitle = NSAttributedString(string:"下拉刷新数据")
        //tableView.addSubview(refreshControl)
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
        
        tableView.es.addPullToRefresh {
            self.refreshData()
        }
        tableView.es.addInfiniteScrolling {
            self.loadMore()
        }
    }
    
    func setupLoadMoreView() {
        loadMoreView = UIView(frame:CGRect(x:0, y:tableView.contentSize.height, width:tableView.bounds.size.width, height:60))
        loadMoreView.autoresizingMask = UIViewAutoresizing.flexibleWidth
        loadMoreView.backgroundColor = UIColor.green
        let indicator = UIActivityIndicatorView(activityIndicatorStyle:.gray)
        indicator.startAnimating()
        loadMoreView.addSubview(indicator)
        indicator.snp.makeConstraints { (maker) in
            maker.center.equalTo(loadMoreView)
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
        CertificatePresenter.getCertificateList(pageIndex: currentPage, num: 10)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                self.tableView.es.stopPullToRefresh()
                //self.refreshControl.endRefreshing()
                if (result.code == 0) {
                    self.certificateItems.removeAll()
                    self.certificateItems = self.certificateItems + result.list!
                    Log(result.list)
                    Log(self.certificateItems)
                    self.tableView.reloadData()
                }
            })
    }
    
    func setupData(_ pageIndex:Int, _ num:Int) {
        CertificatePresenter.getCertificateList(pageIndex: pageIndex, num: num)
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                self.refreshControl.endRefreshing()
                if (result.code == 0) {
                    self.certificateItems = self.certificateItems + result.list!
                    Log(result.list)
                    Log(self.certificateItems)
                    self.tableView.reloadData()
                }
            })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Log(searchText)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return certificateItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CertificateItemCell"
        let item = certificateItems[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,for: indexPath) as? CertificateItemCell else {
            Log("cell is nil")
            return UITableViewCell()
        }
        if (cell.nameLabel == nil) {
            cell.nameTitle = UILabel()
        }
        if (cell.phoneTitle == nil) {
            cell.phoneTitle = UILabel()
        }
        if (cell.idTitle == nil) {
            cell.idTitle = UILabel()
        }
        if (cell.nameLabel == nil) {
            cell.nameLabel = UILabel()
        }
        if (cell.phoneLabel == nil) {
            cell.phoneLabel = UILabel()
        }
        if (cell.idLabel == nil) {
            cell.idLabel = UILabel()
        }
        if (cell.pictureView == nil) {
            cell.pictureView = UIImageView()
        }
        cell.nameTitle.text = "店主姓名："
        cell.phoneTitle.text = "手机号码："
        cell.idTitle.text = "代销证号："
        cell.nameLabel.text = item.name
        cell.phoneLabel.text = item.phone
        cell.idLabel.text = item.certificateId
        cell.pictureView.contentMode = .scaleAspectFit
        cell.pictureView.kf.setImage(with: URL(string:item.certificateImage ?? ""))
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CertificateDetailController()
        vc.certificateItem = certificateItems[indexPath.row]
        vc.preViewController = self
        vc.rowInParent = indexPath.row
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadMore() {
        print("load more")
        currentPage = currentPage + 1
        loadMoreEnable = false
        CertificatePresenter.getCertificateList(pageIndex: currentPage, num: 10)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                if (result.code == 0) {
                    guard let list = result.list as? [CertificateItem] else {
                        Toast(text: "无更多数据").show()
                        self.loadMoreEnable = true
                        self.tableView.es.stopLoadingMore()
                        self.currentPage = self.currentPage - 1
                        return
                    }
                    if (list.count > 0) {
                        self.certificateItems = self.certificateItems + list
                        self.tableView.reloadData()
                        self.loadMoreEnable = true
                        self.tableView.es.stopLoadingMore()
                    } else {
                        Toast(text: "无更多数据").show()
                        self.tableView.es.stopLoadingMore()
                        self.loadMoreEnable = true
                        self.currentPage = self.currentPage - 1
                        //self.tableView.scrollToRow(at: IndexPath(), at:UITableViewScrollPosition.middle, animated: true)
                    }
                }
            })
    }
    
    func updataData(row:Int, item:CertificateItem) {
        certificateItems[row] = item
        tableView.reloadData()
    }
    
    @objc func addCertificate() {
        let vc = AddCertificateController()
        vc.type = CertificateItem.add
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleleItem(row:Int) {
        certificateItems.remove(at: row)
        tableView.reloadData()
    }
}
