//
//  VisitDetailController.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import Toaster
import SnapKit

class VisitDetailController:UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var noteLabel:UITextView!
    var visitItem:VisitItem?
    var scrollView:UIScrollView!
    var preViewController:VisitListController?
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
    
    override func viewDidLoad() {
        setupViews()
        setupConstrains()
    }
    
    func setupViews() {
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "收据详情"
        let optionButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(showOptionList))
        self.navigationItem.rightBarButtonItem = optionButton
        
        noteLabel = UITextView()
        noteLabel.font = UIFont.systemFont(ofSize:17)
        noteLabel.text = visitItem?.notes
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
        //imageUrls = visitItem?.visit_image?.Visit_image
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
    
    override func viewDidLayoutSubviews() {
        let margin:CGFloat = 4
        let itemWH = self.view.frame.width * 0.25
        imageCollectionLayout.itemSize = CGSize(width:itemWH, height:itemWH)
        imageCollectionLayout.minimumInteritemSpacing = margin
        imageCollectionLayout.minimumLineSpacing = margin
    }
    
    func setupData() {
        selectedImages = [UIImage]()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateData()
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
            let vc = AddVisitController()
            vc.type = VisitItem.edit
            vc.editableItem = self.visitItem
            self.present(vc, animated: true, completion: nil)
        }
        let deleteAction = UIAlertAction(title: "删除", style: .default) { (action) in
            VisitPresenter.deleteVisit(id:self.visitItem!.id!)
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
        }
        let cacelAction = UIAlertAction(title: "取消", style:.cancel) { (action) in
            
        }
        optionView.addAction(editAction)
        optionView.addAction(deleteAction)
        optionView.addAction(cacelAction)
        present(optionView, animated: true, completion: nil)
    }
    
    func updateData() {
        VisitPresenter.getDetailWithId(visitItem!.id!)
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                if (result.code == 0) {
                    self.updateView(data:result.data!)
                    self.preViewController?.updataData(row: self.rowInParent!, item: self.visitItem!)
                }
            })
        
    }
    
    func updateView(data:VisitItem) {
        visitItem = data
        noteLabel.text = visitItem?.notes
        //imageUrls = visitItem?.Visit_image?.Visit_image
        imageCollectionView.reloadData()
    }
    
    @objc func close(_ sender:UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
}
