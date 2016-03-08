//
//  BaseModel.swift
//  MLShenZhen
//
//  Created by guchengfeng on 15/8/17.
//  Copyright (c) 2015年 HCFData. All rights reserved.
//

import UIKit

import ObjectMapper
/**
 
 继承自NSObject缘由:此类可能被oc调用 y0 2015.9.10
 */
class BaseModel: NSObject,Mappable {
    
    var code: Int?
    var msg: String = ""
    
    override init() {}
    required init?(_ map: Map) {
        super.init()
        mapping(map)
    }
    
    
    func mapping(map: Map) {
        code         <- map["code"]
        msg         <- map["msg"]
    }
    
    func toParams() -> [String: AnyObject] {
        
        return Mapper().toJSON(self)
    }
    
    class func newInstance() -> Mappable {
        return BaseModel()
    }
}

class BaseApi:NSObject {
    
    typealias CompletionHandlerType = (Result) -> Void
    
    enum Result {
        case Success(AnyObject?)
        case Failure(AnyObject?)
    }
    
    enum Error: ErrorType {
        case AuthenticationFailure
    }
    
}

