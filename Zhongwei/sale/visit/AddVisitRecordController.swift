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
    var pageMenuController:PagingMenuController!
    
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
        options.setShopId(id:shopItem!.club_id!)
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
        }
        signButtonView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(shopView)
            maker.right.equalTo(shopView)
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
        shopNameLabel.text = shopItem?.club_name
        shopInfoView.nameLabel.text = shopItem?.name
        shopInfoView.phoneLabel.text = shopItem?.phone
        shopInfoView.addressLabel.text = shopItem?.address
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
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
    
    @objc func sign() {
        if (onSigning) {
            VisitPresenter.sign(longitude:longitude, latitude:latitude, status:2,shopId:shopItem!.club_id!)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (result) in
                    if (result.code == 0) {
                        Toast(text:"离开打卡成功").show()
                        self.onSigning = false
                        self.signButtonView.titleLabel.text = "到店打卡"
                    } else {
                        Toast(text: result.message ?? "").show()
                    }
                })
            
        } else {
            VisitPresenter.sign(longitude:longitude, latitude:latitude, status:1,shopId:shopItem!.club_id!)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (result) in
                    if (result.code == 0) {
                        Toast(text: "到店打卡成功").show()
                        self.onSigning = true
                        self.signButtonView.titleLabel.text = "离开打卡"
                    } else {
                        Toast(text: result.message ?? "").show()
                    }
                })
            
        }
    }
    
    @objc func location() {
        Log(onSigning)
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
