//
//  XLTargetType.swift
//  YLBaseComponent
//
//  Created by chenxiaofeng on 2018/8/29.
//  Copyright © 2018年 xuanlv.cgs.com. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper

public protocol XLTargetType: TargetType, CacheType, AccessTokenAuthorizable{
    
    /// 具体业务参数
    var parameters: [String : Any]? { get }
    
}
