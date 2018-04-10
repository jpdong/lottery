//
//  BusinessDetailView.swift
//  Zhongwei
//
//  Created by eesee on 2018/4/10.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import RxSwift
import Toaster

class BusinessDetailView:ClosableWebView {
    
    var unionid:String?
    var type:Int?
    var headImgUrl:String?
    var nickName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        unionid = getCacheUnionid()
        app = UIApplication.shared.delegate as! AppDelegate
        headImgUrl = app?.globalData?.headImgUrl
        nickName = app?.globalData?.nickName
        showDetail()
    }
    
    func showDetail(){
        Log("type:\(type)")
        switch type! {
        case BusinessItem.shop:
            //Presenter.getShopUrl(unionid: "o6mWl1a58jqGX_TAT6tpd2zpJ2lI")
            BusinessPresenter.getShopUrl(unionid: unionid!,headimgurl: headImgUrl!, nickname:nickName!)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext:{
                    url in
                    self.startLoad(url: url)
                })
            break
        case BusinessItem.manager:
            //Presenter.getManagerUrl(unionid: "o6mWl1a58jqGX_TAT6tpd2zpJ2lI")
            BusinessPresenter.getManagerUrl(unionid: unionid!,headimgurl: headImgUrl!, nickname:nickName!)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext:{
                    url in
                    self.startLoad(url: url)
                })
            break
        case BusinessItem.areaManager:
            //Presenter.getAreaManagerUrl(unionid: "o6mWl1a58jqGX_TAT6tpd2zpJ2lI")
            BusinessPresenter.getAreaManagerUrl(unionid: unionid!,headimgurl: headImgUrl!, nickname:nickName!)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext:{
                    url in
                    self.startLoad(url: url)
                })
            break
        case BusinessItem.marketManager:
            //Presenter.getAreaManagerUrl(unionid: "o6mWl1a58jqGX_TAT6tpd2zpJ2lI")
            BusinessPresenter.getMarketManagerUrl(unionid: unionid!,headimgurl: headImgUrl!, nickname:nickName!)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext:{
                    url in
                    self.startLoad(url: url)
                })
            break
        default:
            break
        }
    }}

