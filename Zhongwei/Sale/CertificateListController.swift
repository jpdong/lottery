//
//  CertificateListController.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift

class CertificateListController:UIViewController ,UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var searchBar:UISearchBar!
    var tableView:UITableView!
    
    var certificateItems = [CertificateItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstrains()
        setupData()
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
        tableView.register(CertificateItemCell.self, forCellReuseIdentifier: "CertificateItemCell")
        tableView.tableFooterView = UIView(frame:.zero)
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
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
    
    func setupData() {
        CertificatePresenter.getCertificateList(pageIndex: 1, num: 2)
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,for: indexPath) as! CertificateItemCell
        let item = certificateItems[indexPath.row]
        cell.nameLabel = UILabel()
        cell.nameLabel.text = item.name
        cell.phoneLabel = UILabel()
        cell.phoneLabel.text = item.phone
        cell.idLabel = UILabel()
        cell.idLabel.text = item.lottery_papers
        cell.pictureView = UIImageView()
        cell.pictureView.contentMode = .scaleAspectFit
        cell.pictureView.kf.setImage(with: URL(string:item.lottery_papers_image!))
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CertificateDetailController() as! CertificateDetailController
        vc.certificateItem = certificateItems[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func addCertificate() {
        let vc = AddCertificateController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
