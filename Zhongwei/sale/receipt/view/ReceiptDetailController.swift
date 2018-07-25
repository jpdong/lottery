//
//  ReceiptDetailController.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import Toaster
import SnapKit

class ReceiptDetailController:UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var noteLabel:UITextView!
    var receiptItem:ReceiptItem?
    var scrollView:UIScrollView!
    var preViewController:ReceiptListController?
    var rowInParent:Int?
    var navigationBarHeight:CGFloat?
    var statusBarHeight:CGFloat?
    var closeButton:UIBarButtonItem!
    var navigationBar:UINavigationBar!
    var editNavigationItem:UINavigationItem!
    var selectedImages:[UIImage]!
    var imageCollectionLayout:UICollectionViewFlowLayout!
    var imageCollectionView:UICollectionView!
    var imageUrls:[String]!
    var presenter:ReceiptPresenter!
    var disposeBag:DisposeBag!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disposeBag = DisposeBag()
        presenter = ReceiptPresenter()
        setupViews()
        setupConstrains()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //self.disposeBag = nil
    }
    
    override func viewDidLayoutSubviews() {
        let margin:CGFloat = 4
        let itemWH = self.view.frame.width * 0.25
        imageCollectionLayout.itemSize = CGSize(width:itemWH, height:itemWH)
        imageCollectionLayout.minimumInteritemSpacing = margin
        imageCollectionLayout.minimumLineSpacing = margin
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateData()
    }
    
    func setupViews() {
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "收据详情"
        let optionButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(showOptionList))
        self.navigationItem.rightBarButtonItem = optionButton
        
        noteLabel = UITextView()
        noteLabel.font = UIFont.systemFont(ofSize:17)
        noteLabel.text = receiptItem?.notes
        noteLabel.isEditable = false
        
        imageCollectionLayout = UICollectionViewFlowLayout()
        imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: imageCollectionLayout)
        imageCollectionView.alwaysBounceVertical = true
         imageCollectionView.backgroundColor = UIColor.white
        imageCollectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4)
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        imageCollectionView.keyboardDismissMode = .onDrag
        imageCollectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        self.view.addSubview(imageCollectionView)
        //imageCollectionView.backgroundColor = UIColor.green
        imageUrls = receiptItem?.image?.image
        self.view.addSubview(noteLabel)
    }
    
    func setupConstrains() {
        noteLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.view).offset(Size.instance.statusBarHeight + Size.instance.navigationBarHeight)
            maker.left.equalTo(self.view).offset(16)
            maker.right.equalTo(self.view).offset(-8)
            maker.height.equalTo(self.view.frame.height * 0.3)
        }
        imageCollectionView.snp.makeConstraints { (maker) in
            maker.top.equalTo(noteLabel.snp.bottom)
            maker.left.equalTo(self.view).offset(16)
            maker.right.equalTo(self.view).offset(-8)
            maker.bottom.equalTo(self.view)
            
        }
    }
    
    func setupData() {
        selectedImages = [UIImage]()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else {
            return UICollectionViewCell()
        }
        cell.imageView?.kf.setImage(with: URL(string:imageUrls[indexPath.row]))
        cell.deleteButton?.isHidden = true
        cell.imageView?.isUserInteractionEnabled = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PreviewImageController()
        vc.imageUrl = imageUrls[indexPath.row]
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func showOptionList() {
        let optionView = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "编辑", style: .default) { (action) in
            let vc = AddReceiptController()
            vc.type = ReceiptItem.edit
            vc.editableItem = self.receiptItem
            self.present(vc, animated: true, completion: nil)
        }
        let deleteAction = UIAlertAction(title: "删除", style: .default) { (action) in
            self.presenter.deleteReceipt(id:self.receiptItem!.id!)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (result) in
                    if (result.code == 0) {
                        Toast(text: "删除成功").show()
                        self.preViewController?.deleleItem(row:self.rowInParent!)
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        Toast(text:"删除失败：\(result.message ?? "")").show()
                    }
                })
            .disposed(by: self.disposeBag)
        }
        let cacelAction = UIAlertAction(title: "取消", style:.cancel) { (action) in
            
        }
        optionView.addAction(editAction)
        optionView.addAction(deleteAction)
        optionView.addAction(cacelAction)
        present(optionView, animated: true, completion: nil)
    }
    
    func updateData() {
        presenter.getDetailWithId(receiptItem!.id!)
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                if (result.code == 0) {
                    if let data = result.data {
                        self.updateView(data:data)
                    }
                    self.preViewController?.updataData(row: self.rowInParent!, item: self.receiptItem!)
                }
            })
        .disposed(by: disposeBag)
        
    }
    
    func updateView(data:ReceiptItem) {
        receiptItem = data
        noteLabel.text = receiptItem?.notes
        imageUrls = receiptItem?.image?.image
        imageCollectionView.reloadData()
    }
    
    @objc func close(_ sender:UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
}
