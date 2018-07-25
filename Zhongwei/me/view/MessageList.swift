//
//  MessageList.swift
//  Zhongwei
//
//  Created by eesee on 2018/1/31.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import SnapKit

class MessageList:UITableViewController {
    
    var messageItems = [Message]()
    var noMessageView:UIImageView!
    var presenter:UserPresenter!
    var disposeBag:DisposeBag!
    
    override func viewDidLoad() {
//        let now = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
//        let date = dateFormatter.string(from: now)
//        messageItems.append(MessageItem(title:"test",date:date))
        disposeBag = DisposeBag()
        presenter = UserPresenter()
        noMessageView = UIImageView(image:UIImage(named:"message_blank"))
        noMessageView.contentMode = .scaleAspectFit
        noMessageView.isHidden = true
        self.view.addSubview(noMessageView)
        self.tableView.tableFooterView = UIView(frame:.zero)
        noMessageView.snp.makeConstraints { (maker) in
            maker.width.equalTo(100)
            maker.centerX.equalTo(self.view)
            maker.top.equalTo(self.view).offset(self.view.frame.height * 0.2)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.updateMessages()
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                if (result.code == 0) {
                    self.messageItems = result.messageList!
                    print("messageItems:\(self.messageItems)")
                    self.tableView.reloadData()
                    if (self.messageItems.count == 0) {
                        self.noMessageView.isHidden = false
                    }
                }else {
                    
                }
            })
        .disposed(by: self.disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MessageItemCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,for: indexPath) as! MessageCellView
        let item = messageItems[indexPath.row]
        cell.title.text = item.msg
        cell.title.lineBreakMode = .byWordWrapping
        cell.title.numberOfLines = 0
        cell.date.text = item.time
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        segue.destination.hidesBottomBarWhenPushed = true
        guard let messageDetailVC = segue.destination as? MessageDetailView else {
            fatalError("Unexpected destination:\(segue.destination)")
        }
        guard let selectedCell = sender as? MessageCellView else {
            fatalError("Unexpected sender:\(sender)")
        }
        guard let indexPath = tableView.indexPath(for: selectedCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        let selectMessage = messageItems[indexPath.row]
        messageDetailVC.messageDetailUrl = selectMessage.url
    }
}

class MessageCellView:UITableViewCell{
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    
}

