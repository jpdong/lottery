//
//  NoteAPI.swift
//  Zhongwei
//
//  Created by eesee on 2018/7/25.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

//
//  ZhongweiAPI.swift
//  Zhongwei
//
//  Created by eesee on 2018/7/25.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import Moya

let NoteAPIProvicer = MoyaProvider<NoteAPI>()

public enum NoteAPI {
    
    private var sid:String {
        return App.globalData?.sid ?? ""
    }
    
    case notes(pageIndex:Int,num:Int,shopId:String)
    case addNote(note:String,shopId:String)
    case editNote(note:String, noteId:String)
    case getNote(id:String)
    case deleteNote(id:String)
}

extension NoteAPI:TargetType {
    
    public var baseURL: URL {
        return URL(string: "https://app.api.bjzwhz.cn/")!
    }
    
    public var path: String {
        switch self {
        case .notes:
            return "app/Lottery_manager/interviewLogList"
        case .addNote:
            return "app/Lottery_manager/addInterviewLog"
        case .editNote:
            return "app/Lottery_manager/modifyInterviewLog"
        case .getNote:
            return "app/Lottery_manager/getInterviewLogDetail"
        case .deleteNote:
            return "app/Lottery_manager/delInterviewLog"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        default:
            return .post
        }
    }
    
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        switch self {
        case .notes(let pageIndex, let num,let shopId):
            let parameters:Dictionary = ["sid":sid, "pageIndex":String(pageIndex), "entryNum":String(num),"club_id":shopId]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        case .addNote(let note, let shopId):
            let parameters:Dictionary = ["sid":sid,"club_id":shopId,"question":note]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        case .editNote(let note, let noteId):
            let parameters:Dictionary = ["sid":sid,"id":noteId,"question":note]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        case .getNote(let id):
            let parameters:Dictionary = ["sid":sid,"id":id]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        case .deleteNote(let id):
            let parameters:Dictionary = ["sid":sid,"id":id]
            return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
            
        default:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
}


