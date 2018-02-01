//
//  BusinessViewController.swift
//  Zhongwei
//
//  Created by eesee on 2018/1/30.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift

class BusinessViewController:UITableViewController {
    
    var businessItems = [BusinessItem]()
    var unionid:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //var navigationBar = UINavigationBar(frame:CGRect( x:0,y:20, width:self.view.frame.width, height:44))
        //self.view.addSubview(navigationBar)
        setupItems()
        self.tableView.tableFooterView = UIView(frame:.zero)
        //self.navigationItem.title = "业务"
    }
    
    func setupItems(){
        var shopOwner = BusinessItem(title:"零售店主",type:BusinessItem.shop)
        shopOwner.icon = UIImage(named:"shopOwner")
        var manager = BusinessItem(title:"客户经理",type:BusinessItem.manager)
        manager.icon = UIImage(named:"manager")
        var areaManager = BusinessItem(title:"区域经理",type:BusinessItem.areaManager)
        areaManager.icon = UIImage(named:"areaManager")
        businessItems.append(shopOwner)
        businessItems.append(manager)
        businessItems.append(areaManager)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businessItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "BusinessItemCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,for: indexPath) as! BusinessItemView
        let item = businessItems[indexPath.row]
        cell.title.text = item.title
        cell.icon.image = item.icon
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if (hasUnionid()){
            return indexPath
        } else {
            return nil
        }
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
        } else {
            //showViews()
        }
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
}
