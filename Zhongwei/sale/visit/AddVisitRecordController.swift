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

class AddVisitRecordController:UIViewController,CLLocationManagerDelegate {
    var imageView:UIImageView!
    var shopView:UIView!
    var shopNameLabel:UILabel!
    var shopInfoView:ShopInfoView!
    var signButtonView:SignButtonView!
    var signLocationView:SignLocationView!
    var scrollView:UIScrollView!
    var locationManager:CLLocationManager!
    
    var shopItem:ShopItem?
    
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
        signButtonView.layer.cornerRadius = 50
        signButtonView.backgroundColor = UIColor.yellow
        signLocationView = SignLocationView()
        signLocationView.backgroundColor = UIColor.yellow
        shopView = UIView()
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
            maker.width.equalTo(self.view.frame.width * 0.8)
            maker.height.equalTo(imageView)
        }
        shopNameLabel.snp.makeConstraints { (maker) in
            maker.top.left.equalTo(shopView)
        }
        shopInfoView.snp.makeConstraints { (maker) in
            maker.top.equalTo(shopNameLabel.snp.bottom)
            maker.left.equalTo(shopView)
        }
        signLocationView.snp.makeConstraints { (maker) in
            //maker.top.equalTo(shopInfoView.snp.bottom)
            maker.bottom.equalTo(shopView)
            maker.left.equalTo(shopView)
            maker.right.equalTo(shopView)
        }
        signButtonView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(shopView)
            maker.right.equalTo(shopView)
            maker.width.height.equalTo(100)
        }
        
    }
    
    func setupData() {
        shopNameLabel.text = shopItem?.club_name
        shopInfoView.nameLabel.text = shopItem?.name
        shopInfoView.phoneLabel.text = shopItem?.phone
        shopInfoView.addressLabel.text = shopItem?.address
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.requestAlwaysAuthorization()
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.startUpdatingLocation()
            print("定位开始")
        }
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width:self.view.frame.width, height:self.view.frame.height)
    }
    
    
    
    func setupClickEvents() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Log("signButtonView : \(signButtonView.frame.width)")
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currLocation:CLLocation = locations.last!
        Log("经度：\(currLocation.coordinate.longitude)")

        Log("纬度：\(currLocation.coordinate.latitude)")
        //getRealAddress(longtitude:currLocation.coordinate.longitude,latitude:currLocation.coordinate.latitude)
        
    }
    
//    func getRealAddress(longtitude:currLocation.coordinate.longitude,latitude:currLocation.coordinate.latitude) {
//
//    }


    
    @objc func close(_ sender:UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
}
