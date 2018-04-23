//
//  IDCardViewController.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/2.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import SnapKit
import RxSwift

class IDCardViewController:UIViewController , UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    static let front:Int = 0
    static let back:Int = 1
    static let tobacco:Int = 2
    
    var closeButton:UIBarButtonItem!
    var navigationBar:UINavigationBar!
    var idcardFirstStepImage:UIImageView!
    var idcardSecondStepImage:UIImageView!
    var idcardFrontImage:UIImageView!
    var idcardBackImage:UIImageView!
    var tobaccoCardImage:UIImageView!
    var scrollView:UIScrollView!
    var nextStepButton:UIButton!
    var guideBackground:UIImageView!
    var picker:UIImagePickerController!
    var currentImage:Int = front
    var frontImageSetup:Bool = false
    var backImageSetup:Bool = false
    var tobaccoImageSetup:Bool = false
    var frontImageUrl:String?
    var backImageUrl:String?
    var tobaccoImageUrl:String?
    var frontImageIndicator:UIActivityIndicatorView!
    var backImageIndicator:UIActivityIndicatorView!
    var tobaccoImageIndicator:UIActivityIndicatorView!
    var navigationBarHeight:CGFloat?
    var statusBarHeight:CGFloat?
    var presenter:BusinessPresenter!
    var disposeBag:DisposeBag!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disposeBag = DisposeBag()
        presenter = BusinessPresenter()
        setupViews()
        setupConstrains()
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width:self.view.frame.width,height:nextStepButton.frame.maxY + 2 * Size.instance.tabBarHeight)
    }
    
    func setupViews() {
        navigationBarHeight = Size.instance.navigationBarHeight
        statusBarHeight = Size.instance.statusBarHeight
        picker = UIImagePickerController()
        picker.delegate = self
        scrollView = UIScrollView()
        nextStepButton = UIButton()
        nextStepButton.setTitle("去填写", for: .normal)
        nextStepButton.setTitleColor(UIColor.white, for: .normal)
        nextStepButton.backgroundColor = UIColor(red:0,green:0x6d/255,blue:0x55/255, alpha:1)
        nextStepButton.layer.cornerRadius = 5
        nextStepButton.addTarget(self, action: #selector(nextStep), for: UIControlEvents.touchUpInside)
        
        navigationBar = UINavigationBar(frame:CGRect( x:0,y:statusBarHeight!, width:self.view.frame.width, height:navigationBarHeight!))
        closeButton = UIBarButtonItem(title:"", style:.plain, target:self, action:#selector(close))
        closeButton.image = UIImage(named:"closeButton")
        navigationItem.setRightBarButton(closeButton, animated: true)
        navigationBar?.pushItem(navigationItem, animated: true)
        
        self.view.addSubview(scrollView)
        self.view.addSubview(navigationBar!)
        
        guideBackground = UIImageView()
        guideBackground.image = UIImage(named:"idcard_background")
        guideBackground.contentMode = .scaleAspectFit
        scrollView.addSubview(guideBackground)
        
        idcardFirstStepImage = UIImageView()
        idcardFirstStepImage.image = UIImage(named:"idcard_first")
        idcardFirstStepImage.contentMode = .scaleAspectFit
        scrollView.addSubview(idcardFirstStepImage)
        
        idcardSecondStepImage = UIImageView()
        idcardSecondStepImage.image = UIImage(named:"idcard_second")
        idcardSecondStepImage.contentMode = .scaleAspectFit
        scrollView.addSubview(idcardSecondStepImage)
        
        idcardFrontImage = UIImageView()
        idcardFrontImage.image = UIImage(named:"idcard_front")
        idcardFrontImage.contentMode = .scaleAspectFit
        idcardFrontImage.isUserInteractionEnabled = true
        var frontImageTap = UITapGestureRecognizer(target: self, action: #selector(getFrontIDCardPicture))
        idcardFrontImage.addGestureRecognizer(frontImageTap)
        let localFrontUrl = getCacheFrontIDCardImageUrl()
        if (localFrontUrl != "") {
            frontImageUrl = localFrontUrl
            idcardFrontImage.kf.setImage(with: URL(string:localFrontUrl))
            frontImageSetup = true
        }
        scrollView.addSubview(idcardFrontImage)
        
        idcardBackImage = UIImageView()
        idcardBackImage.image = UIImage(named:"idcard_back")
        idcardBackImage.contentMode = .scaleAspectFit
        idcardBackImage.isUserInteractionEnabled = true
        var backImageTap = UITapGestureRecognizer(target: self, action: #selector(getBackIDCardPicture))
        idcardBackImage.addGestureRecognizer(backImageTap)
        let localBackUrl = getCacheBackIDCardImageUrl()
        if (localBackUrl != "") {
            backImageUrl = localBackUrl
            idcardBackImage.kf.setImage(with: URL(string:localBackUrl))
            backImageSetup = true
        }
        
        tobaccoCardImage = UIImageView()
        tobaccoCardImage.image = UIImage(named:"tobacco_card")
        tobaccoCardImage.contentMode = .scaleAspectFit
        tobaccoCardImage.isUserInteractionEnabled = true
        var tobaccoCardTap = UITapGestureRecognizer(target: self, action: #selector(getTobaccoCardPicture))
        tobaccoCardImage.addGestureRecognizer(tobaccoCardTap)
        let localTobaccoCardUrl = getCacheTobaccoCardImageUrl()
        if (localTobaccoCardUrl != "") {
            tobaccoImageUrl = localTobaccoCardUrl
            tobaccoCardImage.kf.setImage(with: URL(string:localTobaccoCardUrl))
            tobaccoImageSetup = true
        }
        scrollView.addSubview(tobaccoCardImage)
        scrollView.addSubview(idcardBackImage)
        scrollView.addSubview(nextStepButton)
        
        frontImageIndicator = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.whiteLarge)
        backImageIndicator = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.whiteLarge)
        tobaccoImageIndicator = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.whiteLarge)
        self.view.addSubview(frontImageIndicator)
        self.view.addSubview(backImageIndicator)
        self.view.addSubview(tobaccoImageIndicator)
    }
    
    func setupConstrains() {
        idcardFirstStepImage.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(scrollView)
            maker.width.equalTo(119)
            maker.top.equalTo(scrollView).offset(20)
        }
        
        idcardFrontImage.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(scrollView)
            maker.width.equalTo(231)
            maker.height.equalTo(144)
            maker.top.equalTo(idcardFirstStepImage.snp.bottom).offset(20)
        }
        
        idcardBackImage.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(scrollView)
            maker.width.equalTo(231)
            maker.height.equalTo(144)
            maker.top.equalTo(idcardFrontImage.snp.bottom).offset(8)
        }
        
        tobaccoCardImage.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(scrollView)
            maker.width.equalTo(231)
            maker.height.equalTo(144)
            maker.top.equalTo(idcardBackImage.snp.bottom).offset(8)
        }
        
        idcardSecondStepImage.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(scrollView)
            maker.width.equalTo(162)
            maker.top.equalTo(tobaccoCardImage.snp.bottom).offset(40)
        }
        
        nextStepButton.snp.makeConstraints { (maker) in
            maker.height.equalTo(50)
            maker.width.greaterThanOrEqualTo(240)
            maker.centerX.equalTo(scrollView)
            maker.left.equalTo(scrollView).offset(40)
            maker.right.equalTo(scrollView).offset(-40)
            maker.top.equalTo(idcardSecondStepImage.snp.bottom).offset(40)
        }
        
        scrollView.snp.makeConstraints { (maker) in
            maker.width.equalTo(self.view)
            maker.height.greaterThanOrEqualTo(self.view)
            maker.top.equalTo(navigationBar.snp.bottom)
            maker.bottom.equalTo(nextStepButton)
        }
        
        guideBackground.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(self.view)
        }
        
        frontImageIndicator.snp.makeConstraints { (maker) in
            maker.center.equalTo(idcardFrontImage)
        }
        
        backImageIndicator.snp.makeConstraints { (maker) in
            maker.center.equalTo(idcardBackImage)
        }
        
        tobaccoImageIndicator.snp.makeConstraints { (maker) in
            maker.center.equalTo(tobaccoCardImage)
        }
        
    }
    
    @objc func getFrontIDCardPicture() {
//        currentImage = IDCardViewController.front
//        picker.sourceType = UIImagePickerControllerSourceType.camera
//        self.present(picker, animated: true, completion: nil)
        
        var vc = AipCaptureCardVC.viewController(with: CardType.idCardFont) { (image) in
            DispatchQueue.main.async {
                self.idcardFrontImage.image = image
                self.frontImageIndicator.startAnimating()
                self.presenter.uploadImage(image:image!)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { (result) in
                        self.frontImageIndicator.stopAnimating()
                        if(result.code == 0) {
                            self.frontImageUrl = result.message
                            self.frontImageSetup = true
                        } else {
                            Zhongwei.alert(viewController: self, title: "提示", message: "图片上传失败")
                        }
                    })
                .disposed(by: self.disposeBag)
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.present(vc!, animated: true, completion: nil)
    }
    
    @objc func getBackIDCardPicture() {
//        currentImage = IDCardViewController.back
//        picker.sourceType = UIImagePickerControllerSourceType.camera
//        self.present(picker, animated: true, completion: nil)
        
        var vc = AipCaptureCardVC.viewController(with: CardType.idCardBack) { (image) in
            DispatchQueue.main.async {
                self.idcardBackImage.image = image
                self.backImageIndicator.startAnimating()
                self.presenter.uploadImage(image:image!)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { (result) in
                        self.backImageIndicator.stopAnimating()
                        if(result.code == 0) {
                            self.backImageUrl = result.message
                            self.backImageSetup = true
                        } else {
                            Zhongwei.alert(viewController: self, title: "提示", message: "图片上传失败")
                        }
                    })
                .disposed(by: self.disposeBag)
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.present(vc!, animated: true, completion: nil)
    }
    
    @objc func getTobaccoCardPicture() {
//        currentImage = IDCardViewController.tobacco
//        picker.sourceType = UIImagePickerControllerSourceType.camera
//        self.present(picker, animated: true, completion: nil)
        
        var vc = AipGeneralVC.viewController { (image) in
            DispatchQueue.main.async {
                self.tobaccoCardImage.image = image
                self.tobaccoImageIndicator.startAnimating()
                self.presenter.uploadImage(image:image!)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { (result) in
                        self.tobaccoImageIndicator.stopAnimating()
                        if(result.code == 0) {
                            self.tobaccoImageUrl = result.message
                            self.tobaccoImageSetup = true
                        } else {
                            Zhongwei.alert(viewController: self, title: "提示", message: "图片上传失败")
                        }
                    })
                .disposed(by: self.disposeBag)
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.present(vc!, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        var image:UIImage!
        //image = info[UIImagePickerControllerEditedImage] as! UIImage
        image = info[UIImagePickerControllerOriginalImage] as! UIImage
        if (currentImage == IDCardViewController.front) {
            idcardFrontImage.image = image
            frontImageIndicator.startAnimating()
            self.presenter.uploadImage(image:image)
            .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (result) in
                    self.frontImageIndicator.stopAnimating()
                    if(result.code == 0) {
                        self.frontImageUrl = result.message
                        self.frontImageSetup = true
                    } else {
                        Zhongwei.alert(viewController: self, title: "提示", message: "图片上传失败")
                    }
                })
            .disposed(by: self.disposeBag)
            
        } else if (currentImage == IDCardViewController.back) {
            idcardBackImage.image = image
            backImageIndicator.startAnimating()
            presenter.uploadImage(image:image)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (result) in
                    self.backImageIndicator.stopAnimating()
                    if(result.code == 0) {
                        self.backImageUrl = result.message
                        self.backImageSetup = true
                    } else {
                        Zhongwei.alert(viewController: self, title: "提示", message: "图片上传失败")
                    }
                })
            .disposed(by: self.disposeBag)
        } else if (currentImage == IDCardViewController.tobacco) {
            tobaccoCardImage.image = image
            tobaccoImageIndicator.startAnimating()
            presenter.uploadImage(image:image)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (result) in
                    self.tobaccoImageIndicator.stopAnimating()
                    if(result.code == 0) {
                        self.tobaccoImageUrl = result.message
                        self.tobaccoImageSetup = true
                    } else {
                        Zhongwei.alert(viewController: self, title: "提示", message: "图片上传失败")
                    }
                })
            .disposed(by: self.disposeBag)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func nextStep() {
        if (!checkPictures()) {
            Zhongwei.alert(viewController: self, title: "提示", message: "请先拍摄身份证")
            return
        }
        storeIDCardImageUrl(front:frontImageUrl!, back:backImageUrl!)
        storeTobaccoCardImageUrl(cardUrl: tobaccoImageUrl!)
        presenter.uploadImageUrls(front:frontImageUrl!, back:backImageUrl!,tobacco: tobaccoImageUrl!)
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                if (result.code == 0) {
                    let sb = UIStoryboard(name:"Business",bundle:nil)
                    let vc = sb.instantiateViewController(withIdentifier: "BusinessDetailView") as! BusinessDetailView
                    vc.type = BusinessItem.shop
                    self.present(vc, animated: true, completion: nil)
                }else {
                   Zhongwei.alert(viewController: self, title: "提示", message: "图片上传失败")
                }
            })
        .disposed(by: self.disposeBag)
    }
    
    func checkPictures() -> Bool {
        if (frontImageSetup && backImageSetup && frontImageUrl != nil && backImageUrl != nil && tobaccoImageSetup && tobaccoImageUrl != nil) {
            return true
        } else {
            return false
        }
    }
    
    @objc func close(_ sender:UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
