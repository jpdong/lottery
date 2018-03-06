//
//  MeViewController.swift
//  Zhongwei
//
//  Created by eesee on 2018/1/24.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class DiscoverViewController:UITableViewController{
    
    @IBOutlet weak var scanCell: DiscoverItemView!
    @IBOutlet weak var welfareTicketCell: DiscoverItemView!
    
    
    var discoverItems = [DiscoverItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupItems()
        scanCell.accessoryType = .disclosureIndicator
        welfareTicketCell.accessoryType = .disclosureIndicator
        self.tableView.tableFooterView = UIView(frame:.zero)
    }
    
    func setupItems(){
        var scanTicket = DiscoverItem(title:"扫码兑奖",operation:DiscoverItem.scan)
        scanTicket.icon = UIImage(named:"scan")
        var welfareTicket = DiscoverItem(title:"公益票活动",detailUrl:"http://yan.eeseetech.cn/mobile/app/caipiao/",operation:DiscoverItem.show)
        welfareTicket.icon = UIImage(named:"welfare")
//        var winningInfo = DiscoverItem(title:"中奖信息公布",detailUrl:"http://yan.eeseetech.cn/resources/wechat/building.html",operation:DiscoverItem.show)
        discoverItems.append(scanTicket)
        discoverItems.append(welfareTicket)
        //discoverItems.append(winningInfo)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if (hasSid()){
            return indexPath
        } else {
            return nil
        }
    }
    
    func hasSid() -> Bool{
        let sid = getCacheSid()
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
            return false
        }
        return true
    }
    
    func hasUnionid() -> Bool{
        let unionid = getCacheUnionid()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.hidesBottomBarWhenPushed = true
    }
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return discoverItems.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cellIdentifier = "DiscoverItemCell"
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,for: indexPath) as! DiscoverItemView
//        let item = discoverItems[indexPath.row]
//        cell.title.text = item.title
//        cell.icon.image = item.icon
//        cell.accessoryType = .disclosureIndicator
//        return cell
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//        let selectedDiscoverCell = sender as! DiscoverItemView
//        let indexPath = tableView.indexPath(for: selectedDiscoverCell)
//        let selectedItem = discoverItems[indexPath!.row]
//        let detailViewController = segue.destination as! DetailViewController
//        switch selectedItem.operation {
//        case 1:
//            detailViewController.detailUrl = selectedItem.detailUrl
//            detailViewController.type = 1
//            break
//        case 2:
//            detailViewController.type = 2
//            break
//        default:
//            break
//        }
//
//    }
    
    
}
