//
//  MainPageViewController.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/8.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import Toaster

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
    var recentNewsId:String?
    var welfareActivityId:String?
    var hotNewsId:String?
    var tabBarHeight:CGFloat?
    var buttonWidth:CGFloat?
    
    var shopOwnerButton,customerManagerButton,pointMallButton,saleManagerButton,customerButton, scanPrizeButton:ImageClickView!
    //var imageClickButtons:[ImageClickView] = [shopOwner,customerManager,pointMall,saleManager,customer, scanPrize]
    
    var images:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //checkRegisterBusinessState()
        setupViews()
        setupConstrains()
        setupClickEvents()
        updateBoardView()
    }
    
    func setupViews() {
        //hidesBottomBarWhenPushed = true
        self.view.backgroundColor = UIColor.white
        buttonWidth = self.view.frame.width / 6
        tabBarHeight = Size.instance.tabBarHeight
        mainNavigationController = UINavigationController()
        self.addChildViewController(mainNavigationController)
        navigationBarHeight = Size.instance.navigationBarHeight
        statusBarHeight = Size.instance.statusBarHeight
        navigationBar = UINavigationBar(frame:CGRect( x:0,y:Size.instance.statusBarHeight, width:self.view.frame.width, height:Size.instance.navigationBarHeight))
        mainNavigationItem = UINavigationItem()
        navigationBar.pushItem(mainNavigationItem, animated: false)
        mainNavigationItem.title = "首页"
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationItem.title = "首页"
        self.navigationBar.tintColor = UIColor.black
        self.view.addSubview(navigationBar!)
        mainScrollView = UIScrollView(frame:self.view.bounds)
        //mainScrollView.backgroundColor = UIColor.gray
        images = [String]()
        images?.append("http://yan.eeseetech.cn/upload/image/20180309/20180309142321.png")
        slideGallery = SliderGalleryController()
        slideGallery.delegate = self
        //slideGallery.view.backgroundColor = UIColor.red
        
        //slideGallery.view.frame = CGRect(x:0, y:88, width:screenWidth, height:334)
        addChildViewController(slideGallery)
        mainScrollView.addSubview(slideGallery.view)
        
        shopOwnerButton = ImageClickView()
        shopOwnerButton.contentTitle.text = "零售店主"
        shopOwnerButton.contentImage.image = UIImage(named:"main_shopowner")
        
        customerManagerButton = ImageClickView()
        customerManagerButton.contentTitle.text = "客户经理"
        customerManagerButton.contentImage.image = UIImage(named:"main_customerManager")
        
        pointMallButton = ImageClickView()
        pointMallButton.contentTitle.text = "公益分商城"
        pointMallButton.contentImage.image = UIImage(named:"main_pointMall")
        
        firstRowView = UIView()
        //firstRowView.backgroundColor = UIColor.white
        //firstRowView.backgroundColor = UIColor.green
        firstRowView.addSubview(shopOwnerButton)
        firstRowView.addSubview(customerManagerButton)
        firstRowView.addSubview(pointMallButton)
        mainScrollView.addSubview(firstRowView)
        
        saleManagerButton = ImageClickView()
        saleManagerButton.contentTitle.text = "访销经理"
        saleManagerButton.contentImage.image = UIImage(named:"main_saleManager")
        
        customerButton = ImageClickView()
        customerButton.contentTitle.text = "消费者"
        customerButton.contentImage.image = UIImage(named:"main_customer")
        
        scanPrizeButton = ImageClickView()
        scanPrizeButton.contentTitle.text = "扫码兑奖"
        scanPrizeButton.contentImage.image = UIImage(named:"main_scan")
        
        secondRowView = UIView()
        //secondRowView.backgroundColor = UIColor.white
        secondRowView.addSubview(saleManagerButton)
        secondRowView.addSubview(customerButton)
        secondRowView.addSubview(scanPrizeButton)
        mainScrollView.addSubview(secondRowView)
        
        recentNewsView = BigboardView()
        recentNewsView.contentTitle.text = "最新资讯"
        recentNewsView.contentMessage.text = "离线状态，请检查网络"
        
        
        //recentNewsView.contentImage.backgroundColor = UIColor.green
        
        welfareActivity = SmallboardView()
        welfareActivity.contentTitle.text = "公益活动"
        welfareActivity.contentMessage.text = "离线状态，请检查网络"
        
        
        //welfareActivity.contentImage.backgroundColor = UIColor.green
        
        hotNewsView = SmallboardView()
        hotNewsView.contentTitle.text = "热点新闻"
        hotNewsView.contentMessage.text = "离线状态，请检查网络"
        
        //hotNewsView.contentImage.backgroundColor = UIColor.green
        
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
            maker.bottom.equalTo(recentNewsView).offset(tabBarHeight!)
        }
        slideGallery.view.snp.makeConstraints { (maker) in
            maker.top.equalTo(mainScrollView)
            maker.width.equalTo(mainScrollView)
            maker.height.equalTo(self.view.frame.width * 0.5)
        }
        
        firstRowView.snp.makeConstraints { (maker) in
            maker.width.equalTo(mainScrollView)
            maker.height.equalTo(buttonWidth! * 1.5)
            maker.top.equalTo(slideGallery.view.snp.bottom).offset(20)
            maker.left.right.equalTo(mainScrollView)
        }
        
        shopOwnerButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(firstRowView.snp.left).offset(40)
            maker.width.equalTo(buttonWidth!)
            maker.bottom.equalTo(firstRowView)
            maker.centerY.equalTo(firstRowView)
            //maker.right.equalTo(customerManagerButton.snp.left).offset(40)
        }
        
        customerManagerButton.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(firstRowView)
            maker.width.equalTo(buttonWidth!)
            maker.bottom.equalTo(firstRowView)
            maker.centerY.equalTo(firstRowView.snp.centerY)
        }
        
        pointMallButton.snp.makeConstraints { (maker) in
            maker.right.equalTo(firstRowView.snp.right).offset(-40)
            //maker.left.equalTo(customerManagerButton.snp.right).offset(40)
            maker.width.equalTo(buttonWidth!)
            maker.bottom.equalTo(firstRowView)
            maker.centerY.equalTo(firstRowView)
        }
        
        secondRowView.snp.makeConstraints { (maker) in
            maker.width.equalTo(mainScrollView)
            maker.height.equalTo(buttonWidth! * 1.5)
            maker.top.equalTo(firstRowView.snp.bottom)
            maker.left.right.equalTo(mainScrollView)
        }
        
        saleManagerButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(secondRowView.snp.left).offset(40)
            maker.width.equalTo(buttonWidth!)
            maker.bottom.equalTo(secondRowView)
            maker.centerY.equalTo(secondRowView)
            //maker.right.equalTo(customerManagerButton.snp.left).offset(40)
        }
        
        customerButton.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(secondRowView)
            maker.width.equalTo(buttonWidth!)
            maker.bottom.equalTo(secondRowView)
            maker.centerY.equalTo(secondRowView.snp.centerY)
        }
        
        scanPrizeButton.snp.makeConstraints { (maker) in
            maker.right.equalTo(secondRowView.snp.right).offset(-40)
            //maker.left.equalTo(customerManagerButton.snp.right).offset(40)
            maker.width.equalTo(buttonWidth!)
            maker.bottom.equalTo(secondRowView)
            maker.centerY.equalTo(secondRowView)
        }
        
        recentNewsView.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(self.view.frame.width * 0.5)
            maker.left.equalTo(mainScrollView)
            maker.top.equalTo(secondRowView.snp.bottom)
        }
        
        welfareActivity.snp.makeConstraints { (maker) in
            maker.width.equalTo(self.view.frame.width * 0.5)
            maker.height.equalTo(self.view.frame.width * 0.25)
            maker.top.equalTo(secondRowView.snp.bottom)
            maker.left.equalTo(recentNewsView.snp.right)
        }
        
        hotNewsView.snp.makeConstraints { (maker) in
            maker.width.equalTo(self.view.frame.width * 0.5)
            maker.height.equalTo(self.view.frame.width * 0.25)
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
        let recentNewsTap  = UITapGestureRecognizer(target: self, action: #selector(showRecentNews))
        recentNewsView.addGestureRecognizer(recentNewsTap)
        recentNewsView.isUserInteractionEnabled = true
        let welfareActivityTap  = UITapGestureRecognizer(target: self, action: #selector(showWelfareActivity))
        welfareActivity.addGestureRecognizer(welfareActivityTap)
        welfareActivity.isUserInteractionEnabled = true
        let hotNewsTap  = UITapGestureRecognizer(target: self, action: #selector(showHotNews))
        hotNewsView.addGestureRecognizer(hotNewsTap)
        hotNewsView.isUserInteractionEnabled = true
    }
    
    @objc func showRecentNews() {
        showDetailArticle(id: recentNewsView.contentId)
    }
    
    @objc func showWelfareActivity() {
        showDetailArticle(id: welfareActivity.contentId)
    }
    
    @objc func showHotNews() {
        showDetailArticle(id: hotNewsView.contentId)
    }
    
    func showDetailArticle(id:String?) {
        guard let articleId = id else {
            Toast(text: "网络错误").show()
            return
        }
        MainPresenter.getArticleWithId(articleId)
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                if (result.code == 0) {
                    let vc = ClosableWebView()
                    vc.url = result.data
                    self.present(vc, animated: true, completion: nil)
                }
            })
    }
    
    override func viewDidLayoutSubviews() {
        mainScrollView.contentSize = CGSize(width:self.view.frame.width,height:recentNewsView.frame.maxY + 2 * tabBarHeight!)
        //welfareActivity.bottomBorder(width: 1, borderColor: UIColor.black)
        //recentNewsView.rightBorder(width: 1, borderColor: UIColor.black)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Log("viewDidAppear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //checkRegisterBusinessState()
        updateBannerView()
        updateBoardView()
    }
    
    func updateBannerView() {
        MainPresenter.updateBannerContent()
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                if (result.code == 0) {
                    self.images = result.imageUrls
                    self.slideGallery.reloadData()
                }
            })
    }
    
    func updateBoardView() {
        MainPresenter.updateBoardContent()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                if (result.code == 0) {
                    var boardViews = [BoardView]()
                    boardViews.append(self.recentNewsView)
                    boardViews.append(self.welfareActivity)
                    boardViews.append(self.hotNewsView)
                    for index in 0...2 {
                        boardViews[index].contentMessage.text = result.articles![index].title
                        boardViews[index].contentImage.kf.setImage(with: URL(string:result.articles![index].thumb!))
                        boardViews[index].contentId = result.articles![index].id
                    }
                } else {
                    Log(result.message)
                }
            })
        
    }
    
    func galleryDataSource() -> [String] {
        return images!
    }
    
    func galleryScrollerViewSize() -> CGSize {
        return CGSize(width:screenWidth, height: self.view.frame.width * 0.5)
    }
    
    @objc func onOwnerClick() {
        print("onOwnerClick")
        BusinessPresenter.checkBusinessRegisterState()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                if (result.code == 0) {
                    self.isShopRegistered = true
                    let sb = UIStoryboard(name:"Business",bundle:nil)
                    let vc = sb.instantiateViewController(withIdentifier: "BusinessDetailView") as! BusinessDetailView
                    vc.type = BusinessItem.shop
                    self.present(vc, animated: true, completion: nil)
                } else if (result.code == 2){
                    self.isShopRegistered = false
                    let sb = UIStoryboard(name:"Business",bundle:nil)
                    let vc = sb.instantiateViewController(withIdentifier: "IDCardViewController") as! IDCardViewController
                    self.present(vc, animated: true, completion: nil)
                } else {
                    Toast(text: result.message).show()
                }
            })
//        if (!isShopRegistered){
//            let sb = UIStoryboard(name:"Business",bundle:nil)
//            let vc = sb.instantiateViewController(withIdentifier: "IDCardViewController") as! IDCardViewController
//            self.present(vc, animated: true, completion: nil)
//        } else {
//            let sb = UIStoryboard(name:"Business",bundle:nil)
//            let vc = sb.instantiateViewController(withIdentifier: "BusinessDetailView") as! BusinessDetailView
//            vc.type = BusinessItem.shop
//            self.present(vc, animated: true, completion: nil)
//        }
    }
    
    @objc func onCustomerManagerButton() {
        print("onCustomerManagerButton")
//        let vc = CustomerManagerList()
//        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
        let sb = UIStoryboard(name:"Business",bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "BusinessDetailView") as! BusinessDetailView
        vc.type = BusinessItem.manager
        self.present(vc, animated: true, completion: nil)
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
        let vc = CertificateListController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        //Toast(text: "功能暂未开放").show()
    }
    
    @objc func onCustomerButton() {
        print("onCustomerButton")
        let vc = ReceiptListController()
        self.navigationController?.pushViewController(vc, animated: true)
        //Toast(text: "功能暂未开放").show()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.hidesBottomBarWhenPushed = true
    }
    
    
    
}
