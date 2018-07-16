//
//  HttpClient.swift
//  Zhongwei
//
//  Created by eesee on 2018/7/5.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import Alamofire

class HttpClient {
    
    public static func get(url:String,finish:@escaping(_ result:ResponseData)->Void){
        Alamofire.request(url).responseString{ response in
            let data = ResponseData()
            switch(response.result) {
            case .success(let value):
                data.result = State.success(value)
            case  .failure(let error):
                data.result = State.failure(error)
            }
            finish(data)
        }
    }
    
    public static func post(url:String,parameters:Dictionary<String,String>,finish:@escaping(_ result:ResponseData)->Void) {
        Alamofire.request(url,method:.post,parameters:parameters).responseString{ response in
            let data = ResponseData()
            switch(response.result) {
            case .success(let value):
                data.result = State.success(value)
            case  .failure(let error):
                data.result = State.failure(error)
            }
            finish(data)
        }
    }
}
