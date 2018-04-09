//
//  GalleryViewController.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/27.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import Toaster

class GalleryViewController:UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, TZImagePickerControllerDelegate{
    
    var shopId:String?
    var imageCollectionLayout:UICollectionViewFlowLayout!
    var imageCollectionView:UICollectionView!
    var imageUrls:[String]!
    var imageIndicator:UIActivityIndicatorView!
    var currentPage:Int = 1
    
    override func viewDidLoad() {
        setupViews()
        setupConstrains()
        refreshData()
    }
    
    func setupViews() {
        imageUrls = [String]()
        imageCollectionLayout = UICollectionViewFlowLayout()
        imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: imageCollectionLayout)
        imageCollectionView.alwaysBounceVertical = true
        imageCollectionView.backgroundColor = UIColor.white
        imageCollectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4)
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        imageCollectionView.keyboardDismissMode = .onDrag
        imageCollectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        imageIndicator = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.whiteLarge)
        self.view.addSubview(imageCollectionView)
        self.view.addSubview(imageIndicator)
        imageCollectionView.es.addPullToRefresh {
            self.refreshData()
        }
        imageCollectionView.es.addInfiniteScrolling {
            self.loadMore()
        }
    }
    
    func setupConstrains() {
        imageCollectionView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self.view)
        }
        imageIndicator.snp.makeConstraints { (maker) in
            maker.center.equalTo(self.view)
        }
    }
    
    override func viewDidLayoutSubviews() {
        let margin:CGFloat = 4
        let itemWH = self.view.frame.width * 0.25
        imageCollectionLayout.itemSize = CGSize(width:itemWH, height:itemWH)
        imageCollectionLayout.minimumInteritemSpacing = margin
        imageCollectionLayout.minimumLineSpacing = margin
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return imageUrls.count + 1 > 6 ? 6 : imageUrls.count + 1
        return imageUrls.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let tapAdd = UITapGestureRecognizer(target: self, action: #selector(addPictures))
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        if (indexPath.row == imageUrls.count) {
            cell.imageView?.image = UIImage(named:"button_add_receipt")
            cell.deleteButton?.isHidden = true
            cell.imageView?.isUserInteractionEnabled = true
            cell.imageView?.addGestureRecognizer(tapAdd)
        } else {
            cell.imageView?.kf.setImage(with: URL(string:imageUrls[indexPath.row]))
            cell.deleteButton?.isHidden = true
            cell.imageView?.isUserInteractionEnabled = false
            cell.imageView?.removeGestureRecognizer(tapAdd)
        }
        //}
        
        cell.deleteButton?.tag = indexPath.row
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(longClick(sender:)))
        cell.addGestureRecognizer(longTap)
        let tapDelete = UITapGestureRecognizer(target: self, action: #selector(deleteClick(sender:)))
        cell.deleteButton?.addGestureRecognizer(tapDelete)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PreviewImageController()
        vc.imageUrl = imageUrls[indexPath.row]
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func addPictures() {
        let vc:TZImagePickerController = TZImagePickerController.init(maxImagesCount: 6, delegate: self)
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func deleteClick(sender:UITapGestureRecognizer) {
        self.imageUrls.remove(at: sender.view!.tag)
        self.imageCollectionView.reloadData()
    }
    
    @objc func longClick(sender:UILongPressGestureRecognizer) {
        if let cell = sender.view as? ImageCell {
            cell.deleteButton?.isHidden = false
        }
    }
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        //selectedImages = selectedImages + photos
        for photo in photos {
                imageIndicator.startAnimating()
                BusinessPresenter.uploadImage(image: photo)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { (result) in
                        self.imageIndicator.stopAnimating()
                        if (result.code == 0) {
                            self.imageUrls.append(result.message!)
                            self.imageIndicator.startAnimating()
                            GalleryPresenter.addImageUrl(shopId:self.shopId!, imageUrl:result.message!)
                                .observeOn(MainScheduler.instance)
                                .subscribe(onNext: { (result) in
                                    self.imageIndicator.stopAnimating()
                                    if (result.code == 0) {
                                    }else {
                                        Toast(text:result.message ?? "").show()
                                    }
                            })
                            self.imageCollectionView.reloadData()
                        } else {
                            Toast(text:result.message ?? "").show()
                        }
                    })
                
            }
        }
    
    @objc func refreshData() {
        currentPage = 1
        GalleryPresenter.getGalleryList(pageIndex: currentPage, num: 6, shopId: shopId!)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                self.imageCollectionView.es.stopPullToRefresh()
                if (result.code == 0) {
                    self.imageUrls.removeAll()
                    self.imageUrls = self.imageUrls + result.data!
                    self.imageCollectionView.reloadData()
                } else {
                    Toast(text: result.message ?? "").show()
                }
            })
    }
    
    func loadMore() {
        print("load more")
        currentPage = currentPage + 1
        GalleryPresenter.getGalleryList(pageIndex: currentPage, num: 6, shopId: shopId!)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                if (result.code == 0) {
                    guard let list = result.data as? [String] else {
                        Toast(text: "无更多数据").show()

                        self.imageCollectionView.es.stopLoadingMore()
                        self.currentPage = self.currentPage - 1
                        return
                    }
                    if (result.data!.count > 0) {
                        self.imageUrls = self.imageUrls + result.data!
                        self.imageCollectionView.reloadData()
                        self.imageCollectionView.es.stopLoadingMore()
                    } else {
                        Toast(text: "无更多数据").show()
                        self.imageCollectionView.es.stopLoadingMore()
                        self.currentPage = self.currentPage - 1
                    }
                }
            })
    }
    
    func setShopId(id:String) {
        shopId = id
    }
}
