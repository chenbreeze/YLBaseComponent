//
//  YLTargetType.swift
//  YLBaseComponent
//
//  Created by chenxiaofeng on 2018/8/28.
//  Copyright © 2018年 xuanlv.cgs.com. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper

public protocol YLTargetType: TargetType, CacheType, AccessTokenAuthorizable{
    
    /// 返回数据类型, 这种写法理论上没问题，但实际用起来很麻烦，没办法批量组织api
    associatedtype responseModelType: Mappable
    
    /// 具体业务参数
    var parameters: [String : Any]? { get }
    
}



