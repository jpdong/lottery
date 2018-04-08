//
//  AddVisitController.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/15.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import Toaster
import CoreLocation
import PagingMenuController

class AddVisitRecordController:UIViewController,CLLocationManagerDelegate {
    var imageView:UIImageView!
    var shopView:UIView!
    var shopNameLabel:UILabel!
    var shopInfoView:ShopInfoView!
    var signButtonView:SignButtonView!
    var signLocationView:SignLocationView!
    
    var scrollView:UIScrollView!
    var locationManager:CLLocationManager!
    var longitude:Double = 0
    var latitude:Double = 0
    var onSigning = false
    
    var shopItem:ShopItem?
    var shopId:String?
    var pageMenuController:PagingMenuController!
    var timer:Timer!
    
    var isCounting = false {
        willSet {
            if newValue {
                self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
                
            } else {
                self.timer.invalidate()
                //self.timer = nil
            }
            
        }
    }
    
    @objc func updateTime() {
        let now = Date()
        let timeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        let duration = timeStamp - Int(getSigningTime())!
        print("\(duration/3600):\(duration/60):\(duration%60)")
        DispatchQueue.main.async {
            self.signButtonView.timeLabel.text = "\(duration/3600):\(duration/60):\(duration%60)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstrains()
        setupClickEvents()
        setupData()
    }
    
    func setupViews() {
        self.navigationItem.title = "走访店铺"
        self.view.backgroundColor = UIColor(red: 0xf1/255, green: 0xf2/255, blue: 0xf5/255, alpha: 1)
        var chooseShopButton = UIBarButtonItem(title: "切换店铺", style: .done, target: self, action: #selector(chooseShop))
        self.navigationItem.rightBarButtonItem = chooseShopButton
        scrollView = UIScrollView(frame:self.view.bounds)
        imageView = UIImageView(image:UIImage(named:"background_shop"))
        imageView.contentMode = .scaleAspectFill
        shopNameLabel = UILabel()
        shopInfoView = ShopInfoView()
        signButtonView = SignButtonView()
        
        //signButtonView.layer.masksToBounds = true
        //signButtonView.layer.cornerRadius = 50
        signLocationView = SignLocationView()
        shopView = UIView()
        shopView.layer.cornerRadius = 10
        shopView.backgroundColor = UIColor.white
        shopView.addSubview(shopNameLabel)
        shopView.addSubview(shopInfoView)
        shopView.addSubview(signButtonView)
        shopView.addSubview(signLocationView)
        
        self.view.addSubview(imageView)
        self.view.addSubview(shopView)
        //self.view.addSubview(scrollView)
        
        shopView.addSubview(shopNameLabel)
        shopView.addSubview(shopInfoView)
        shopView.addSubview(signButtonView)
        shopView.addSubview(signLocationView)
        
        let options = PagingMenuOptions()
        if let shopItem = shopItem {
            options.setShopId(id:shopItem.club_id!)
        } else {
            options.setShopId(id: shopId!)
            //getShopItem()
        }
        pageMenuController = PagingMenuController(options: options)
        pageMenuController.view.frame.origin.y += 64
        pageMenuController.view.frame.size.height -= 64
        addChildViewController(pageMenuController)
        self.view.addSubview(pageMenuController.view)
    }
    
    func setupConstrains() {
//        scrollView.snp.makeConstraints { (maker) in
//            maker.top.equalTo(self.view).offset(Size.instance.statusBarHeight + Size.instance.navigationBarHeight)
//            maker.left.right.bottom.equalTo(self.view)
//        }
        imageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.view).offset(Size.instance.statusBarHeight + Size.instance.navigationBarHeight)
            maker.width.equalTo(self.view)
            maker.height.equalTo(self.view.frame.height * 0.25)
        }
        shopView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.view)
            maker.centerY.equalTo(imageView).offset(70)
            maker.width.equalTo(self.view.frame.width * 0.9)
            maker.height.equalTo(160)
        }
        shopNameLabel.snp.makeConstraints { (maker) in
            maker.top.left.equalTo(shopView).offset(8)
        }
        shopInfoView.snp.makeConstraints { (maker) in
            maker.top.equalTo(shopNameLabel.snp.bottom).offset(8)
            maker.left.equalTo(shopView).offset(8)
            maker.height.equalTo(80)
        }
        signLocationView.snp.makeConstraints { (maker) in
            maker.top.equalTo(shopInfoView.snp.bottom)
            //maker.bottom.equalTo(shopView.snp.bottom)
            maker.left.equalTo(shopView).offset(8)
            maker.right.equalTo(shopView)
            maker.width.equalTo(shopView)
            maker.height.equalTo(30)
        }
        signButtonView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(shopView)
            maker.right.equalTo(shopView).offset(-8)
            maker.width.height.equalTo(80)
        }
        pageMenuController.view.snp.makeConstraints { (maker) in
            maker.top.equalTo(shopView.snp.bottom).offset(16)
            maker.left.right.equalTo(self.view)
            //maker.height.equalTo(self.view.frame.height * 0.6)
            maker.bottom.equalTo(self.view).offset(-(Size.instance.tabBarHeight - 49))
        }
        
    }
    
    func setupData() {
        if let shopItem = shopItem {
            updateShopView()
            
        } else {
            ShopPresenter.getShopWithId(id:shopId!)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (result) in
                    if (result.code == 0) {
                        if let shopItem = result.data {
                            self.shopItem = shopItem
                            self.updateShopView()
                        }
                    } else {
                        Toast(text: result.message ?? "").show()
                    }
                })
        }
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
    }
    
    func updateShopView() {
        shopNameLabel.text = shopItem!.club_name
        shopInfoView.nameLabel.text = shopItem!.name
        shopInfoView.phoneLabel.text = shopItem!.phone
        shopInfoView.addressLabel.text = shopItem!.address
    }
    
    override func viewDidLayoutSubviews() {
        //scrollView.contentSize = CGSize(width:self.view.frame.width, height:self.view.frame.height)
    }
    
    func setupClickEvents() {
        let signTap = UITapGestureRecognizer(target: self, action: #selector(sign))
        signButtonView.addGestureRecognizer(signTap)
        let locationTap = UITapGestureRecognizer(target: self, action: #selector(location))
        signLocationView.isUserInteractionEnabled = true
        //signLocationView.updateLocationButton.isUserInteractionEnabled = true
        signLocationView.addGestureRecognizer(locationTap)
    }
    
    @objc func chooseShop() {
        if let shopItem = shopItem {
            if (shopItem.club_id == getSigningShopId()) {
                let vc = SearchViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.navigationController?.popViewController(animated: true)
            }

//        } else {
//            if (shopId! == getSigningShopId()) {
//                let vc = SearchViewController()
//                self.navigationController?.pushViewController(vc, animated: true)
//            } else {
//                self.navigationController?.popViewController(animated: true)
//            }
        }

    }
    
    @objc func sign() {
        var shopId:String = ""
        if let shopItem = shopItem {
            shopId = shopItem.club_id!
        } else {
            shopId = self.shopId!
        }
        if (onSigning) {
            VisitPresenter.sign(longitude:longitude, latitude:latitude, status:2,shopId:shopId)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (result) in
                    if (result.code == 0) {
                        self.isCounting = false
                        Toast(text:"离开打卡成功").show()
                        storeSigningShopId(shopId:"")
                        self.onSigning = false
                        self.isCounting = false
                        self.signButtonView.titleLabel.text = "到店打卡"
                        self.unSignAnimation()
                    } else {
                        Toast(text: result.message ?? "").show()
                    }
                })
            
        } else {
            VisitPresenter.sign(longitude:longitude, latitude:latitude, status:1,shopId:shopId)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (result) in
                    if (result.code == 0) {
                        Toast(text: "到店打卡成功").show()
                        if let shopItem  = self.shopItem {
                            storeSigningShopId(shopId:shopItem.club_id!)
                            let now = Date()
                            let timeInterval = now.timeIntervalSince1970
                            let timeStamp = Int(timeInterval)
                            storeSignTime(String(timeStamp))
                            CoreDataHelper.instance.saveShopItem(shopItem: shopItem)
                            self.isCounting = true
//                        } else {
//                            storeSigningShopId(shopId:self.shopId!)
                        }
                        self.onSigning = true
                        self.signButtonView.titleLabel.text = "离开打卡"
                        self.signAnimation()
                    } else {
                        Toast(text: result.message ?? "").show()
                    }
                })
            
        }
    }
    
    func signAnimation() {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(TimeInterval(1))
        //signButtonView.titleLabel.center.y = signButtonView.titleLabel.center.y - 8
        signButtonView.timeLabel.alpha = 1
        UIView.setAnimationCurve(.easeOut)
        UIView.commitAnimations()
    }
    
    func unSignAnimation() {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(TimeInterval(1))
        //signButtonView.titleLabel.center.y = signButtonView.titleLabel.center.y + 8
        signButtonView.timeLabel.alpha = 0
        UIView.setAnimationCurve(.easeOut)
        UIView.commitAnimations()
    }
    
    @objc func location() {
        Log(onSigning)
        signLocationView.titleLable.text = "定位中..."
        signLocationView.isUserInteractionEnabled = false
        locationManager.startUpdatingLocation()
    }
    
    func getLocation() {
        let status  = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        if status == .denied || status == .restricted {
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Log("signButtonView : \(signButtonView.frame.width)")
        getLocation()
        setupSignButtonState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if (isCounting) {
            isCounting = false
        }
    }
    
    func getShopItem() {
        ShopPresenter.getShopWithId(id: shopId!)
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                if (result.code == 0) {
                    self.shopItem = result.data
                    self.setupSignButtonState()
                } else {
                    Toast(text: result.message ?? "").show()
                }
            })
    }
    
    func setupSignButtonState() {
        if let shopItem = shopItem {
            if (getSigningShopId() == "") {
                signButtonView.isUserInteractionEnabled = true
                signButtonView.backgroundImage.image = UIImage(named:"background_sign")
                self.signButtonView.titleLabel.text = "到店打卡"
                onSigning = false
                isCounting = false
                unSignAnimation()
            } else if (shopItem.club_id == getSigningShopId()){
                signButtonView.isUserInteractionEnabled = true
                signButtonView.backgroundImage.image = UIImage(named:"background_sign")
                onSigning = true
                isCounting = true
                self.signButtonView.titleLabel.text = "离开打卡"
                signAnimation()
            } else {
                signButtonView.backgroundImage.image = UIImage(named:"background_sign_disable")
                signButtonView.isUserInteractionEnabled = false
            }
//        } else {
//            if (getSigningShopId() == "") {
//                signButtonView.isUserInteractionEnabled = true
//                signButtonView.backgroundImage.image = UIImage(named:"background_sign")
//                self.signButtonView.titleLabel.text = "到店打卡"
//                onSigning = false
//            } else if (shopId! == getSigningShopId()) {
//                signButtonView.isUserInteractionEnabled = true
//                signButtonView.backgroundImage.image = UIImage(named:"background_sign")
//                onSigning = true
//                self.signButtonView.titleLabel.text = "离开打卡"
//            } else {
//                signButtonView.isUserInteractionEnabled = false
//                signButtonView.backgroundImage.image = UIImage(named:"background_sign_disable")
//            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currLocation:CLLocation = locations.last!
        Log("经度：\(currLocation.coordinate.longitude)")
        Log("纬度：\(currLocation.coordinate.latitude)")
        longitude = currLocation.coordinate.longitude
        latitude = currLocation.coordinate.latitude
        if (onSigning) {
            VisitPresenter.sign(longitude:longitude, latitude:latitude, status:3,shopId:shopItem!.club_id!)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (result) in
                    if (result.code == 0) {
                        Toast(text: "更新位置成功").show()
                    } else {
                        Toast(text: result.message ?? "").show()
                    }
                })
        }
        let result = LocationTransform.wgs2gcj(wgsLat: latitude, wgsLng: longitude)
        getRealAddress(longtitude:result.gcjLng,latitude:result.gcjLat)
        
    }
    
    func getRealAddress(longtitude:Double,latitude:Double) {
        let geocoder = CLGeocoder()
        let currentLocation = CLLocation(latitude: latitude, longitude: longtitude)
        geocoder.reverseGeocodeLocation(currentLocation, completionHandler: {
            (placemarks:[CLPlacemark]?, error:Error?) -> Void in
            let array = NSArray(object: "zh-hans")
            UserDefaults.standard.set(array, forKey: "AppleLanguages")
            if error != nil {
                print("错误：\(error!.localizedDescription))")
                return
            }
            if let p = placemarks?[0]{
                var address = ""
                if let administrativeArea = p.administrativeArea {
                    address.append(administrativeArea)
                }
                if let subAdministrativeArea = p.subAdministrativeArea {
                    address.append(subAdministrativeArea)
                }
                if let locality = p.locality {
                    address.append(locality)
                }
                if let subLocality = p.subLocality {
                    address.append(subLocality)
                }
                if let thoroughfare = p.thoroughfare {
                    address.append(thoroughfare)
                }
                if let subThoroughfare = p.subThoroughfare {
                    address.append(subThoroughfare)
                }
                print(address)
                self.signLocationView.titleLable.text = address
                self.locationManager.stopUpdatingLocation()
                self.signLocationView.isUserInteractionEnabled = true
            }
        }
    )}


    
    @objc func close(_ sender:UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
}

private class PagingMenuOptions: PagingMenuControllerCustomizable {
    
    private let viewController1:NoteListController = NoteListController()
    private let viewController2:GalleryViewController = GalleryViewController()
    
    func setShopId(id:String) {
        viewController1.setShopId(id:id)
        viewController2.setShopId(id:id)
    }
    
    fileprivate var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    
    fileprivate var pagingControllers: [UIViewController] {
        return [viewController1, viewController2]
    }
    
    fileprivate struct MenuOptions: MenuViewCustomizable {
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        var focusMode: MenuFocusMode {
            return .underline(height: 1, color:UIColor(red: 0x00/255, green: 0x6d/255, blue: 0x55/255, alpha: 1), horizontalPadding: 0,verticalPadding: 0)
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem1(), MenuItem2()]
        }
    }
    fileprivate struct MenuItem1: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "备注"))
        }
    }
    fileprivate struct MenuItem2: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "照片"))
        }
    }
}
