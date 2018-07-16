//
//  responseData.swift
//  Zhongwei
//
//  Created by eesee on 2018/7/5.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation

class ResponseData {
    var result:State<String>?
}

public enum State<Value> {
    
    case success(Value)
    case failure(Error)
    
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    public var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}
