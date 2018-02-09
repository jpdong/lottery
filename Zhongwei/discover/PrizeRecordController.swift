//
//  PrizeRecordController.swift
//  Zhongwei
//
//  Created by eesee on 2018/2/5.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift

class PrizeRecordController:WebViewController {
    
    var closeButton:UIBarButtonItem!
    var app:AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate
        closeButton = UIBarButtonItem(title:"", style:.plain, target:self, action:#selector(close))
        closeButton.image = UIImage(named:"closeButton")
        webNavigationItem.setRightBarButton(closeButton, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Presenter.getPrizeRecordUrl()
        .observeOn(MainScheduler.instance)
        .subscribe(
            onNext:{
                result in
                print("prize record:\(result)")
                self.startLoad(url: result)
            }
        )
        //startLoad(url: "\(app!.globalData!.baseUrl)resources/wechat/scan-qr-code/redeem-record.html?1518057524824=&sid=15faf6d8779de6c0cd248e595b80d857")
    }
    
    @objc func close(_ sender:UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
        
    }
}
