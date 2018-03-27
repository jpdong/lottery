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
     
        self.view.backgroundColor = UIColor.white
        scrollView = UIScrollView(frame:self.view.bounds)
        imageView = UIImageView()
        imageView.backgroundColor = UIColor.gray
        shopNameLabel = UILabel()
        shopInfoView = ShopInfoView()
        signButtonView = SignButtonView()
        //signButtonView.layer.masksToBounds = true
        //signButtonView.layer.cornerRadius = 50
        signButtonView.backgroundColor = UIColor.yellow
        signLocationView = SignLocationView()
        signLocationView.backgroundColor = UIColor.yellow
        shopView = UIView()
        shopView.layer.cornerRadius = 10
        shopView.backgroundColor = UIColor.green
        shopView.addSubview(shopNameLabel)
        shopView.addSubview(shopInfoView)
        shopView.addSubview(signButtonView)
        shopView.addSubview(signLocationView)
        
        scrollView.addSubview(imageView)
        scrollView.addSubview(shopView)
        self.view.addSubview(scrollView)
        
        shopView.addSubview(shopNameLabel)
        shopView.addSubview(shopInfoView)
        shopView.addSubview(signButtonView)
        shopView.addSubview(signLocationView)
        
        let options = PagingMenuOptions()
        pageMenuController = PagingMenuController(options: options)
        pageMenuController.view.frame.origin.y += 64
        pageMenuController.view.frame.size.height -= 64
        pageMenuController.view.backgroundColor = UIColor.yellow
        addChildViewController(pageMenuController)
        scrollView.addSubview(pageMenuController.view)
    }
    
    func setupConstrains() {
        scrollView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.view).offset(Size.instance.statusBarHeight + Size.instance.navigationBarHeight)
            maker.left.right.bottom.equalTo(self.view)
        }
        imageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(scrollView)
            maker.width.equalTo(scrollView)
            maker.height.equalTo(self.view.frame.height * 0.25)
        }
        shopView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(scrollView)
            maker.centerY.equalTo(imageView).offset(100)
            maker.width.equalTo(self.view.frame.width * 0.9)
            maker.height.equalTo(imageView)
        }
        shopNameLabel.snp.makeConstraints { (maker) in
            maker.top.left.equalTo(shopView)
        }
        shopInfoView.snp.makeConstraints { (maker) in
            maker.top.equalTo(shopNameLabel.snp.bottom)
            maker.left.equalTo(shopView)
            maker.right.equalTo(signButtonView.snp.left)
            maker.height.equalTo(signButtonView)
        }
        signLocationView.snp.makeConstraints { (maker) in
            maker.top.equalTo(shopInfoView.snp.bottom)
            maker.left.equalTo(shopView)
            maker.right.equalTo(shopView)
        }
        signButtonView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(shopView)
            maker.right.equalTo(shopView)
            maker.width.height.equalTo(shopView.frame.height * 0.8)
        }
        pageMenuController.view.snp.makeConstraints { (maker) in
            maker.top.equalTo(shopView.snp.bottom).offset(16)
            maker.left.right.equalTo(self.view)
            maker.height.equalTo(self.view.frame.height * 0.6)
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
        scrollView.contentSize = CGSize(width:self.view.frame.width, height:self.view.frame.height)
    }
    
    func setupClickEvents() {
        let signTap = UITapGestureRecognizer(target: self, action: #selector(sign))
        signButtonView.addGestureRecognizer(signTap)
        let locationTap = UITapGestureRecognizer(target: self, action: #selector(location))
        signLocationView.updateLocationButton.addGestureRecognizer(locationTap)
    }
    
    @objc func sign() {
        if (onSigning) {
            VisitPresenter.sign(longitude:longitude, latitude:latitude, status:2,shopId:shopItem!.club_id!)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (result) in
                    if (result.code == 0) {
                        
                    } else {
                        Toast(text: result.message ?? "").show()
                    }
                })
            onSigning = false
        } else {
            VisitPresenter.sign(longitude:longitude, latitude:latitude, status:1,shopId:shopItem!.club_id!)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (result) in
                    if (result.code == 0) {
                        
                    } else {
                        Toast(text: result.message ?? "").show()
                    }
                })
            onSigning = true
        }
    }
    
    @objc func location() {
        VisitPresenter.sign(longitude:longitude, latitude:latitude, status:3,shopId:shopItem!.club_id!)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                
            })
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
        let longitude = currLocation.coordinate.longitude
        let latitude = currLocation.coordinate.latitude
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

private struct PagingMenuOptions: PagingMenuControllerCustomizable {
    
    private let viewController1 = NoteListController()
    private let viewController2 = GalleryViewController()
    
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
