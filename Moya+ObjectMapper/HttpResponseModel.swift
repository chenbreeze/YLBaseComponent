//
//  HttpResponseModel.swift
//  YLBaseComponent
//
//  Created by chenxiaofeng on 2018/8/28.
//  Copyright © 2018年 xuanlv.cgs.com. All rights reserved.
//

import Foundation
import ObjectMapper

public struct ResponseEmptyModel: Mappable {
    
    public var message : String!
    public var error   : String!
    public var code    : Int?
    
    public init?(map: Map) {
        
    }
    
    public mutating func mapping(map: Map) {
        message <- map["message"]
        error <- map["error"]
        code <- map["code"]
    }
}

/// data 是一个封装的数据类型
public struct ResponseObjectModel<T : Mappable> : Mappable {
    
    public var data : T?
    public var message : String!
    public var error   : String!
    public var code    : Int?
    
    public init?(map: Map) {
        
    }
    
    public mutating func mapping(map: Map) {
        data <- map["data"]
        message <- map["message"]
        error <- map["error"]
        code <- map["code"]
    }
    
}

/// data 是一个数组 T 遵守Mappable
public struct ResponseArrayModel<T : Mappable> : Mappable{
    public var data : [T]?
    public var message : String!
    public var error   : String!
    public var code    : Int?
    
    public  init?(map: Map) {
        
    }
    
    public mutating func mapping(map: Map) {
        data <- map["data"]
        message <- map["message"]
        error <- map["error"]
        code <- map["code"]
    }
}

/// data 基本数据类型, 字典，数组 ...
public struct ResponseOriginalModel<T> : Mappable{
    
    public var data : T?
    public var message : String!
    public var error   : String!
    public var code    : Int?
    
    public init?(map: Map) {
        
    }
    
    public mutating func mapping(map: Map) {
        data <- map["data"]
        message <- map["message"]
        error <- map["error"]
        code <- map["code"]
    }
}

