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
        var welfareTicket = DiscoverItem(title:"公益票活动",detailUrl:"http://yan.eeseetech.cn/mobile/wechat/caipiao/",operation:DiscoverItem.show)
        welfareTicket.icon = UIImage(named:"welfare")
//        var winningInfo = DiscoverItem(title:"中奖信息公布",detailUrl:"http://yan.eeseetech.cn/resources/wechat/building.html",operation:DiscoverItem.show)
        discoverItems.append(scanTicket)
        discoverItems.append(welfareTicket)
        //discoverItems.append(winningInfo)
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
