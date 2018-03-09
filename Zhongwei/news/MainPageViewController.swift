//
//  MainPageViewController.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/8.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift

class MainPageViewController:UIViewController , SliderGalleryControllerDelegate{
    
    var mainScrollView:UIScrollView!
    let screenWidth = UIScreen.main.bounds.width
    var slideGallery:SliderGalleryController!
    var firstRowView:UIView!
    var secondRowView:UIView!
    var recentNewsView:BigboardView!
    var welfareActivity:SmallboardView!
    var hotNewsView:SmallboardView!
    var isShopRegistered:Bool = false
    var navigationBarHeight:CGFloat?
    var statusBarHeight:CGFloat?
    var navigationBar:UINavigationBar!
    var mainNavigationItem:UINavigationItem!
    var mainNavigationController:UINavigationController!
    
    var shopOwnerButton,customerManagerButton,pointMallButton,saleManagerButton,customerButton, scanPrizeButton:ImageClickView!
    //var imageClickButtons:[ImageClickView] = [shopOwner,customerManager,pointMall,saleManager,customer, scanPrize]
    
    var images = ["http://img4q.duitang.com/uploads/item/201503/18/20150318230437_Pxnk3.jpeg",
                  "http://img4.duitang.com/uploads/item/201501/31/20150131234424_WRJGa.jpeg",
                  "http://img5.duitang.com/uploads/item/201502/11/20150211095858_nmRV8.jpeg",
                  "http://cdnq.duitang.com/uploads/item/201506/11/20150611213132_HPecm.jpeg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkRegisterBusinessState()
        setupViews()
        setupConstrains()
        setupClickEvents()
    }
    
    func setupViews() {
        mainNavigationController = UINavigationController()
        self.addChildViewController(mainNavigationController)
        navigationBarHeight = Size.instance.navigationBarHeight
        statusBarHeight = Size.instance.statusBarHeight
        navigationBar = UINavigationBar(frame:CGRect( x:0,y:Size.instance.statusBarHeight, width:self.view.frame.width, height:Size.instance.navigationBarHeight))
        mainNavigationItem = UINavigationItem()
        navigationBar.pushItem(mainNavigationItem, animated: false)
        mainNavigationItem.title = "首页"
        self.view.addSubview(navigationBar!)
        mainScrollView = UIScrollView(frame:self.view.bounds)
        slideGallery = SliderGalleryController()
        slideGallery.delegate = self
        slideGallery.view.backgroundColor = UIColor.red
        //slideGallery.view.frame = CGRect(x:0, y:88, width:screenWidth, height:334)
        addChildViewController(slideGallery)
        mainScrollView.addSubview(slideGallery.view)
        
        shopOwnerButton = ImageClickView()
        shopOwnerButton.contentTitle.text = "零售店主"
        shopOwnerButton.contentImage.image = UIImage(named:"shopOwner")
        
        customerManagerButton = ImageClickView()
        customerManagerButton.contentTitle.text = "客户经理"
        customerManagerButton.contentImage.image = UIImage(named:"shopOwner")
        
        pointMallButton = ImageClickView()
        pointMallButton.contentTitle.text = "积分商城"
        pointMallButton.contentImage.image = UIImage(named:"shopOwner")
        
        firstRowView = UIView()
        //firstRowView.backgroundColor = UIColor.green
        firstRowView.addSubview(shopOwnerButton)
        firstRowView.addSubview(customerManagerButton)
        firstRowView.addSubview(pointMallButton)
        mainScrollView.addSubview(firstRowView)
        
        saleManagerButton = ImageClickView()
        saleManagerButton.contentTitle.text = "访销经理"
        saleManagerButton.contentImage.image = UIImage(named:"shopOwner")
        
        customerButton = ImageClickView()
        customerButton.contentTitle.text = "消费者"
        customerButton.contentImage.image = UIImage(named:"shopOwner")
        
        scanPrizeButton = ImageClickView()
        scanPrizeButton.contentTitle.text = "扫码兑奖"
        scanPrizeButton.contentImage.image = UIImage(named:"shopOwner")
        
        secondRowView = UIView()
        //secondRowView.backgroundColor = UIColor.green
        secondRowView.addSubview(saleManagerButton)
        secondRowView.addSubview(customerButton)
        secondRowView.addSubview(scanPrizeButton)
        mainScrollView.addSubview(secondRowView)
        
        recentNewsView = BigboardView()
        recentNewsView.contentTitle.text = "最新资讯"
        recentNewsView.contentMessage.text = "test"
        recentNewsView.contentImage.backgroundColor = UIColor.green
        
        welfareActivity = SmallboardView()
        welfareActivity.contentTitle.text = "公益活动"
        welfareActivity.contentMessage.text = "test"
        welfareActivity.contentImage.backgroundColor = UIColor.green
        
        hotNewsView = SmallboardView()
        hotNewsView.contentTitle.text = "热点新闻"
        hotNewsView.contentMessage.text = "test"
        hotNewsView.contentImage.backgroundColor = UIColor.green
        
        mainScrollView.addSubview(recentNewsView)
        mainScrollView.addSubview(welfareActivity)
        mainScrollView.addSubview(hotNewsView)
        
        self.view.addSubview(mainScrollView)
    }
    
    func setupConstrains() {
        
        mainScrollView.snp.makeConstraints { (maker) in
            maker.top.equalTo(navigationBar.snp.bottom)
            maker.width.equalTo(self.view)
            maker.height.greaterThanOrEqualTo(self.view)
        }
        slideGallery.view.snp.makeConstraints { (maker) in
            maker.top.equalTo(mainScrollView)
            maker.width.equalTo(mainScrollView)
            maker.height.equalTo(200)
        }
        
        firstRowView.snp.makeConstraints { (maker) in
            maker.width.equalTo(mainScrollView)
            maker.height.equalTo(100)
            maker.top.equalTo(slideGallery.view.snp.bottom).offset(20)
            maker.left.right.equalTo(mainScrollView)
        }
        
        shopOwnerButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(firstRowView.snp.left).offset(40)
            maker.width.equalTo(50)
            maker.bottom.equalTo(firstRowView)
            maker.centerY.equalTo(firstRowView)
            //maker.right.equalTo(customerManagerButton.snp.left).offset(40)
        }
        
        customerManagerButton.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(firstRowView)
            maker.width.equalTo(50)
            maker.bottom.equalTo(firstRowView)
            maker.centerY.equalTo(firstRowView.snp.centerY)
        }
        
        pointMallButton.snp.makeConstraints { (maker) in
            maker.right.equalTo(firstRowView.snp.right).offset(-40)
            //maker.left.equalTo(customerManagerButton.snp.right).offset(40)
            maker.width.equalTo(50)
            maker.bottom.equalTo(firstRowView)
            maker.centerY.equalTo(firstRowView)
        }
        
        secondRowView.snp.makeConstraints { (maker) in
            maker.width.equalTo(mainScrollView)
            maker.height.equalTo(100)
            maker.top.equalTo(firstRowView.snp.bottom)
            maker.left.right.equalTo(mainScrollView)
        }
        
        saleManagerButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(secondRowView.snp.left).offset(40)
            maker.width.equalTo(50)
            maker.bottom.equalTo(secondRowView)
            maker.centerY.equalTo(secondRowView)
            //maker.right.equalTo(customerManagerButton.snp.left).offset(40)
        }
        
        customerButton.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(secondRowView)
            maker.width.equalTo(50)
            maker.bottom.equalTo(secondRowView)
            maker.centerY.equalTo(secondRowView.snp.centerY)
        }
        
        scanPrizeButton.snp.makeConstraints { (maker) in
            maker.right.equalTo(secondRowView.snp.right).offset(-40)
            //maker.left.equalTo(customerManagerButton.snp.right).offset(40)
            maker.width.equalTo(50)
            maker.bottom.equalTo(secondRowView)
            maker.centerY.equalTo(secondRowView)
        }
        
        recentNewsView.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(180)
            maker.left.equalTo(mainScrollView)
            maker.top.equalTo(secondRowView.snp.bottom)
        }
        
        welfareActivity.snp.makeConstraints { (maker) in
            maker.width.equalTo(180)
            maker.height.equalTo(90)
            maker.top.equalTo(secondRowView.snp.bottom)
            maker.left.equalTo(recentNewsView.snp.right)
        }
        
        hotNewsView.snp.makeConstraints { (maker) in
            maker.width.equalTo(180)
            maker.height.equalTo(90)
            maker.top.equalTo(welfareActivity.snp.bottom)
            maker.left.equalTo(recentNewsView.snp.right)
        }
    }
    
    func setupClickEvents() {
        //shopOwnerButton,customerManagerButton,pointMallButton,saleManagerButton,customerButton, scanPrizeButton
        let shopOwnerClick = UITapGestureRecognizer(target: self, action: #selector(onOwnerClick))
        shopOwnerButton.addGestureRecognizer(shopOwnerClick)
        let customerManagerClick = UITapGestureRecognizer(target: self, action: #selector(onCustomerManagerButton))
        customerManagerButton.addGestureRecognizer(customerManagerClick)
        let pointMallClick = UITapGestureRecognizer(target: self, action: #selector(onPointMallButton))
        pointMallButton.addGestureRecognizer(pointMallClick)
        let saleManagerClick = UITapGestureRecognizer(target: self, action: #selector(onSaleManagerButton))
        saleManagerButton.addGestureRecognizer(saleManagerClick)
        let customerClick = UITapGestureRecognizer(target: self, action: #selector(onCustomerButton))
        customerButton.addGestureRecognizer(customerClick)
        let scanPrizeClick = UITapGestureRecognizer(target: self, action: #selector(onScanPrizeButton))
        scanPrizeButton.addGestureRecognizer(scanPrizeClick)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mainScrollView.contentSize = CGSize(width:self.view.frame.width,height:self.view.frame.height + 100)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    func galleryDataSource() -> [String] {
        return images
    }
    
    func galleryScrollerViewSize() -> CGSize {
        return CGSize(width:screenWidth, height: 200)
    }
    
    @objc func onOwnerClick() {
        print("onOwnerClick")
        if (!isShopRegistered){
            let sb = UIStoryboard(name:"Business",bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "IDCardViewController") as! IDCardViewController
            self.present(vc, animated: true, completion: nil)
        } else {
            let sb = UIStoryboard(name:"Business",bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "BusinessDetailView") as! BusinessDetailView
            vc.type = BusinessItem.shop
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func onCustomerManagerButton() {
        print("onCustomerManagerButton")
//        let sb = UIStoryboard(name:"Business",bundle:nil)
//        let vc = sb.instantiateViewController(withIdentifier: "BusinessViewController") as! BusinessViewController
        let vc = CustomerManagerList()
        self.present(vc, animated: true, completion: nil)
        print("onCustomerManagerButton finish")
    }
    
    @objc func onPointMallButton() {
        print("onPointMallButton")
        BusinessPresenter.getPointMallUrl()
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                var vc:ClosableWebView = ClosableWebView()
                vc.url = result
                self.present(vc, animated: true, completion: nil)
            })
    }
    
    @objc func onSaleManagerButton() {
        print("onSaleManagerButton")
        MainPresenter.getRecentNews()
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                
            })
    }
    
    @objc func onCustomerButton() {
        print("onCustomerButton")
    }
    
    @objc func onScanPrizeButton() {
        print("onScanPrizeButton")
        var vc:UIViewController = GuideViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    func checkRegisterBusinessState() {
        BusinessPresenter.checkBusinessRegisterState()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                if (result.code == 0) {
                    self.isShopRegistered = true
                } else {
                    self.isShopRegistered = false
                }
            })
    }
    
}
