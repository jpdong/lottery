//
//  AddReceiptController.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import Toaster

class AddReceiptController:UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, TZImagePickerControllerDelegate {
    
    var textField:UITextField!
    var submitButton:UIButton!
    var submitIndicator:UIActivityIndicatorView!
    var imageIndicator:UIActivityIndicatorView!
    var imageUrl:String?
    var type:Int = 2
    var editableItem:ReceiptItem?
    var navigationBarHeight:CGFloat?
    var statusBarHeight:CGFloat?
    var closeButton:UIBarButtonItem!
    var navigationBar:UINavigationBar!
    var editNavigationItem:UINavigationItem!
    
    var selectedImages:[UIImage]!
    var imageCollectionLayout:UICollectionViewFlowLayout!
    var imageCollectionView:UICollectionView!
    
    override func viewDidLoad() {
        setupViews()
        setupConstrains()
        setupClickEvents()
        setupData()
    }
    
    func setupViews() {
        navigationBarHeight = Size.instance.navigationBarHeight
        statusBarHeight = Size.instance.statusBarHeight
        navigationBar = UINavigationBar(frame:CGRect( x:0,y:statusBarHeight!, width:self.view.frame.width, height:navigationBarHeight!))
        editNavigationItem = UINavigationItem()
        closeButton = UIBarButtonItem(title:"", style:.plain, target:self, action:#selector(close))
        closeButton.image = UIImage(named:"closeButton")
        closeButton.tintColor = UIColor.black
        editNavigationItem.setRightBarButton(closeButton, animated: true)
        navigationBar?.pushItem(editNavigationItem, animated: true)
        self.view.addSubview(navigationBar!)
        self.view.backgroundColor = UIColor.white
        
        textField = UITextField()
        textField.placeholder = "请输入备注信息"
        
        imageCollectionLayout = UICollectionViewFlowLayout()
        imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: imageCollectionLayout)
        imageCollectionView.alwaysBounceVertical = true
        imageCollectionView.backgroundColor = UIColor(red: 244 / 255.0, green: 244 / 255.0, blue: 244 / 255.0, alpha: 1)
        imageCollectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4)
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        imageCollectionView.keyboardDismissMode = .onDrag
        imageCollectionView.register(ReceiptImageCell.self, forCellWithReuseIdentifier: "ReceiptImageCell")
        self.view.addSubview(imageCollectionView)
        //imageCollectionView.backgroundColor = UIColor.green
        
        submitButton = UIButton()
        submitButton.setTitle("保存", for: .normal)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.backgroundColor = UIColor(red:0x2e/255,green:0x6e/255,blue:0x55/255,alpha:1)
        
        submitIndicator = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.gray)
        imageIndicator = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.whiteLarge)
        
        self.view.addSubview(textField)
        self.view.addSubview(submitButton)
        self.view.addSubview(submitIndicator)
        self.view.addSubview(imageIndicator)
        
        if (type == ReceiptItem.edit) {
            
        }
    }
    
    func setupConstrains() {
        textField.snp.makeConstraints { (maker) in
            maker.top.left.right.equalTo(self.view)
            maker.height.equalTo(self.view.frame.height * 0.3)
        }
        imageCollectionView.snp.makeConstraints { (maker) in
            maker.top.equalTo(textField.snp.bottom)
            maker.left.right.equalTo(self.view)
            maker.bottom.equalTo(submitButton.snp.top)
            
        }
        submitButton.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.view)
            maker.bottom.equalTo(self.view)
            //maker.top.equalTo(imageCollectionView.snp.bottom).offset(40)
            maker.height.equalTo(50)
            maker.width.greaterThanOrEqualTo(240)
            maker.left.equalTo(self.view).offset(16)
            maker.right.equalTo(self.view).offset(-16)
        }
//        imageIndicator.snp.makeConstraints { (maker) in
//            maker.center.equalTo(imageInputBox.imageView)
//        }
        submitIndicator.snp.makeConstraints { (maker) in
            maker.center.equalTo(submitButton)
        }
    }
    
    override func viewDidLayoutSubviews() {
        let margin:CGFloat = 4
        let itemWH = (self.view.frame.width - 2 * margin - 4) / 3 - margin
        imageCollectionLayout.itemSize = CGSize(width:itemWH, height:itemWH)
        imageCollectionLayout.minimumInteritemSpacing = margin
        imageCollectionLayout.minimumLineSpacing = margin
        //imageCollectionView.setCollectionViewLayout(<#T##layout: UICollectionViewLayout##UICollectionViewLayout#>, animated: <#T##Bool#>)
        
    }
    
    func setupData() {
        selectedImages = [UIImage]()
    }
    
    func setupClickEvents() {
        var imageInputTap = UITapGestureRecognizer(target: self, action: #selector(getReceiptPicture))
   
        submitButton.addTarget(self, action: #selector(submitReceipt), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count + 1 > 6 ? 6 : selectedImages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tapAdd = UITapGestureRecognizer(target: self, action: #selector(addPictures))
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReceiptImageCell", for: indexPath) as! ReceiptImageCell
        if (selectedImages.count < 6 && indexPath.row == selectedImages.count) {
            cell.imageView?.image = UIImage(named:"button_add_receipt")
            cell.deleteButton?.isHidden = true
            cell.addGestureRecognizer(tapAdd)
        } else {
            cell.imageView?.image = selectedImages[indexPath.row]
            cell.deleteButton?.isHidden = false
            cell.removeGestureRecognizer(tapAdd)
        }
        cell.deleteButton?.tag = indexPath.row
        let tapDelete = UITapGestureRecognizer(target: self, action: #selector(deleteClick))
        cell.deleteButton?.addGestureRecognizer(tapDelete)
        return cell
    }
    
    @objc func deleteClick(sender:UIImageView) {
        print("delete click")
        selectedImages.remove(at: sender.tag)
        imageCollectionView.performBatchUpdates({
            let indexPath = NSIndexPath(row: sender.tag, section: 0)
        }) { (finish) in
            self.imageCollectionView.reloadData()
        }
        
    }
    
    @objc func addPictures() {
        let vc:TZImagePickerController = TZImagePickerController.init(maxImagesCount: 6, delegate: self)
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func getReceiptPicture() {
        let vc = AipGeneralVC.viewController { (image) in
            DispatchQueue.main.async {
                self.imageIndicator.startAnimating()
                BusinessPresenter.uploadImage(image:image!)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { (result) in
                        self.imageIndicator.stopAnimating()
                        if(result.code == 0) {
                            self.imageUrl = result.message
                        } else {
                            Toast(text: "图片上传失败").show()
                        }
                    })
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.present(vc!, animated: true, completion: nil)
    }
    
    @objc func submitReceipt() {
        var text = textField.text
        var input:String!
        if let text = textField.text {
            input = text.trimmingCharacters(in: .whitespaces)
            if (input == "") {
                input = "无备注信息"
            }
        } else {
            input = "无备注信息"
        }
        if (type == ReceiptItem.add) {
            submitIndicator.startAnimating()
            submitButton.isEnabled = false
//            ReceiptPresenter.submitReceipt(name!, phone!, id!, imageUrl!)
//                .observeOn(MainScheduler.instance)
//                .subscribe(onNext: { (result) in
//                    self.submitIndicator.stopAnimating()
//                    self.submitButton.isEnabled = true
//                    if(result.code == 0) {
//                        Toast(text: "添加成功").show()
//                        self.navigationController?.popViewController(animated: true)
//                    } else {
//                        Toast(text: result.message).show()
//                    }
//                })
        } else if(type == ReceiptItem.edit) {
//            if (name! == editableItem?.name! && phone! == editableItem?.phone! && id! == editableItem?.lottery_papers! && imageUrl! == editableItem?.lottery_papers_image!) {
//                Toast(text: "未做任何修改").show()
//                dismiss(animated: true, completion: nil)
//            } else {
//                submitIndicator.startAnimating()
//                submitButton.isEnabled = false
//                ReceiptPresenter.editReceipt(name!, phone!, id!, imageUrl!, editableItem!.id!)
//                .observeOn(MainScheduler.instance)
//                    .subscribe(onNext: { (result) in
//                        self.submitIndicator.stopAnimating()
//                        self.submitButton.isEnabled = true
//                        if(result.code == 0) {
//                            Toast(text: "修改成功").show()
//                            self.dismiss(animated: true, completion: nil)
//                        } else {
//                            Toast(text: result.message).show()
//                        }
//                    })
//            }
        }
    }
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        selectedImages = selectedImages + photos
        imageCollectionView.reloadData()
        
    }
    
    @objc func close(_ sender:UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkNotNil(input:String?...) -> Bool{
        var result = true
        input.forEach { (item) in
            if (item == nil) {
                result = false
            }
        }
        return result
    }
    
    func checkNotEmpty(input:String...) -> Bool{
        var result = true
        input.forEach { (item) in
            if (item.isEmpty) {
                result = false
            }
        }
        return result
    }
    
    func checkImageNotNil(image:UIImage) -> Bool{
        if (image == nil) {
            return false
        } else {
            return true
        }
    }
}
