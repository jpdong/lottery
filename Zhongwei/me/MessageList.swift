//
//  MessageList.swift
//  Zhongwei
//
//  Created by eesee on 2018/1/31.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class MessageList:UITableViewController {
    
    var messageItems = [MessageItem]()
    
    override func viewDidLoad() {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        let date = dateFormatter.string(from: now)
        messageItems.append(MessageItem(title:"test",date:date))
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MessageItemCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,for: indexPath) as! MessageCellView
        let item = messageItems[indexPath.row]
        cell.title.text = item.title
        cell.date.text = item.date
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

class MessageCellView:UITableViewCell{
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    
}

