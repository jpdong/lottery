//
//  CustomerManagerList.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/9.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import SnapKit

class CustomerManagerList:UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    var businessItems = [BusinessItem]()
    var unionid:String?
    var sid:String?
    var isShopRegistered:Bool = false
    var navigationBarHeight:CGFloat?
    var statusBarHeight:CGFloat?
    var navigationBar:UINavigationBar!
    var businessNavigationItem:UINavigationItem!
    var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstrains()
        setupItems()
        tableView.tableFooterView = UIView(frame:.zero)
    }
    
    func setupViews() {
        self.view.backgroundColor = UIColor.white
        navigationBarHeight = Size.instance.navigationBarHeight
        statusBarHeight = Size.instance.statusBarHeight
        navigationBar = UINavigationBar(frame:CGRect( x:0,y:statusBarHeight!, width:self.view.frame.width, height:navigationBarHeight!))
        businessNavigationItem = UINavigationItem()
        businessNavigationItem.title = "业务"
        let closeButton = UIBarButtonItem(title:"", style:.plain, target:self, action:#selector(close))
        closeButton.image = UIImage(named:"closeButton")
        closeButton.tintColor = UIColor.black
        businessNavigationItem.setRightBarButton(closeButton, animated: true)
        navigationBar?.pushItem(businessNavigationItem, animated: true)
        self.view.addSubview(navigationBar!)
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 96
        tableView.register(BusinessItemCell.self, forCellReuseIdentifier: "BusinessItemCell")
        self.view.addSubview(tableView)
    }
    
    func setupConstrains() {
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(navigationBar.snp.bottom)
            maker.width.height.equalTo(self.view)
        }
    }
    
    func setupItems(){
        var shopOwner = BusinessItem(title:"零售店主",type:BusinessItem.shop)
        shopOwner.icon = UIImage(named:"shopOwner")
        var manager = BusinessItem(title:"客户经理",type:BusinessItem.manager)
        manager.icon = UIImage(named:"manager")
        var marketManager = BusinessItem(title:"市场经理",type:BusinessItem.marketManager)
        marketManager.icon = UIImage(named:"marketManager")
        var areaManager = BusinessItem(title:"区域经理",type:BusinessItem.areaManager)
        areaManager.icon = UIImage(named:"areaManager")
        //businessItems.append(shopOwner)
        businessItems.append(manager)
        businessItems.append(marketManager)
        businessItems.append(areaManager)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businessItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "BusinessItemCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,for: indexPath) as! BusinessItemCell
        let item = businessItems[indexPath.row]
        print("cell:\(cell)")
        //print("cell:\(cell.title)")
        cell.title = UILabel()
        cell.title.text = item.title
        cell.icon = UIImageView()
        cell.icon.contentMode = .scaleAspectFit
        cell.icon.image = item.icon
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if (indexPath.row % 2 == 0) {
            cell.type = BusinessItemCell.titleLeft
        } else {
            cell.type = BusinessItemCell.titleRight
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        if (hasSid()){
//            if (indexPath.row == 0 && !isShopRegistered){
//                let sb = UIStoryboard(name:"Business",bundle:nil)
//                let vc = sb.instantiateViewController(withIdentifier: "IDCardViewController") as! IDCardViewController
//                self.present(vc, animated: true, completion: nil)
//                return nil
//            } else {
//                return indexPath
//            }
//        } else {
//            return nil
//        }
        let sb = UIStoryboard(name:"Business",bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "BusinessDetailView") as! BusinessDetailView
        var item:BusinessItem = businessItems[indexPath.row] as! BusinessItem
        vc.type = item.type
        self.present(vc, animated: true, completion: nil)
        return indexPath
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
        super.prepare(for: segue, sender: sender)
        let selectedBusinessCell = sender as! BusinessItemView
        let indexPath = tableView.indexPath(for: selectedBusinessCell)
        let selectedItem = businessItems[indexPath!.row]
        let detailView = segue.destination as! BusinessDetailView
        detailView.type = selectedItem.type
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //        unionid = getCacheUnionid()
        //        if (unionid == nil || unionid! == ""){
        sid = getCacheSid()
        if (sid == nil || sid! == ""){
            //hideViews()
            let alertView = UIAlertController(title:"未登录", message:"前往登录", preferredStyle:.alert)
            let cancel = UIAlertAction(title:"取消", style:.cancel)
            let confirm = UIAlertAction(title:"确定", style:.default){
                action in
                //self.performSegue(withIdentifier: "showMe", sender: self)
                self.tabBarController?.tabBar.isHidden = false
                self.tabBarController?.selectedIndex = 3
            }
            alertView.addAction(cancel)
            alertView.addAction(confirm)
            present(alertView,animated: true,completion: nil)
        } else {
            checkRegisterBusinessState()
        }
    }
    
    func hasSid() -> Bool{
        sid = getCacheSid()
        if (sid == nil || sid! == ""){
            //hideViews()
            let alertView = UIAlertController(title:"未登录", message:"前往登录", preferredStyle:.alert)
            let cancel = UIAlertAction(title:"取消", style:.cancel) {
                action in
                //var idCardViewController = IDCardViewController()
                //self.navigationController?.pushViewController(idCardViewController, animated: true)
                
            }
            let confirm = UIAlertAction(title:"确定", style:.default){
                action in
                //self.performSegue(withIdentifier: "showMe", sender: self)
                self.tabBarController?.tabBar.isHidden = false
                self.tabBarController?.selectedIndex = 3
            }
            alertView.addAction(cancel)
            alertView.addAction(confirm)
            present(alertView,animated: true,completion: nil)
            return false
        }
        return true
    }
    
    func hasUnionid() -> Bool{
        unionid = getCacheUnionid()
        if (unionid == nil || unionid! == ""){
            //hideViews()
            let alertView = UIAlertController(title:"未登录", message:"前往登录", preferredStyle:.alert)
            let cancel = UIAlertAction(title:"取消", style:.cancel)
            let confirm = UIAlertAction(title:"确定", style:.default){
                action in
                //self.performSegue(withIdentifier: "showMe", sender: self)
                self.tabBarController?.tabBar.isHidden = false
                self.tabBarController?.selectedIndex = 3
            }
            alertView.addAction(cancel)
            alertView.addAction(confirm)
            present(alertView,animated: true,completion: nil)
            return false
        }
        return true
    }
    
    @objc func close(_ sender:UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
}
