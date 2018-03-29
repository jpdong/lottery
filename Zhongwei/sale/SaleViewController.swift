//
//  SaleViewController.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/22.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import Toaster

class SaleViewController:UIViewController {
    
    var certificateItem:SaleItemView!
    var receiptItem:SaleItemView!
    var visitItem:SaleItemView!
    var diaryItem:SaleItemView!
    
    override func viewDidLoad() {
        setupViews()
        setupConstrains()
        setupEvents()
    }
    
    func setupViews() {
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "访销经理"
        
        certificateItem = SaleItemView()
        certificateItem.imageView.image = UIImage(named:"background_certificate")
        certificateItem.titleLabel.text = "代销证管理"
        self.view.addSubview(certificateItem)
        
        receiptItem = SaleItemView()
        receiptItem.imageView.image = UIImage(named:"background_receipt")
        receiptItem.titleLabel.text = "收据管理"
        self.view.addSubview(receiptItem)
        
        visitItem = SaleItemView()
        visitItem.imageView.image = UIImage(named:"background_visit")
        visitItem.titleLabel.text = "店铺走访"
        self.view.addSubview(visitItem)
        
        diaryItem = SaleItemView()
        diaryItem.imageView.image = UIImage(named:"background_diary")
        diaryItem.titleLabel.text = "工作日志"
        self.view.addSubview(diaryItem)
    }
    
    func setupConstrains() {
        certificateItem.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.view).offset(Size.instance.statusBarHeight + Size.instance.navigationBarHeight + 8)
            maker.left.equalTo(self.view).offset(16)
            maker.right.equalTo(self.view).offset(-16)
            maker.height.equalTo(self.view.frame.height * 0.2)
        }
        receiptItem.snp.makeConstraints { (maker) in
            maker.top.equalTo(certificateItem.snp.bottom).offset(8)
            maker.left.equalTo(self.view).offset(16)
            maker.right.equalTo(self.view).offset(-16)
            maker.height.equalTo(self.view.frame.height * 0.2)
        }
        visitItem.snp.makeConstraints { (maker) in
            maker.top.equalTo(receiptItem.snp.bottom).offset(8)
            maker.left.equalTo(self.view).offset(16)
            maker.right.equalTo(self.view).offset(-16)
            maker.height.equalTo(self.view.frame.height * 0.2)
        }
        diaryItem.snp.makeConstraints { (maker) in
            maker.top.equalTo(visitItem.snp.bottom).offset(8)
            maker.left.equalTo(self.view).offset(16)
            maker.right.equalTo(self.view).offset(-16)
            maker.height.equalTo(self.view.frame.height * 0.2)
        }
    }
    
    func setupEvents() {
        certificateItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCertificate)))
        receiptItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showReceipt)))
        visitItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showVisit)))
        diaryItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDiary)))
    }
    
    @objc func showCertificate() {
        let vc = CertificateListController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showReceipt() {
        let vc = ReceiptListController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showVisit() {
        //Toast(text:"功能暂未开放").show()
        let vc = VisitListController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showDiary() {
        Toast(text:"功能暂未开放").show()
//        let vc = CertificateListController()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}

class SaleItemView:UIView {
    var imageView:UIImageView!
    var titleLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstrains()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupConstrains()
    }
    
    func setupViews() {
        imageView = UIImageView()
        titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        addSubview(titleLabel)
    }
    
    func setupConstrains() {
        imageView.snp.makeConstraints { (maker) in
            maker.top.bottom.right.left.equalTo(self)
        }
        titleLabel.snp.makeConstraints { (maker) in
            maker.center.equalTo(self)
        }
    }
    
}
