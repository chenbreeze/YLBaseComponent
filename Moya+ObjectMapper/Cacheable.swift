//
//  Cacheable.swift
//  YLBaseComponent
//
//  Created by chenxiaofeng on 2018/8/28.
//  Copyright © 2018年 xuanlv.cgs.com. All rights reserved.
//

import Foundation

public enum RequestCachePolicy{
    
    /// 忽略缓存，仅加载网络数据
    case reloadIgnoringLocalCacheData
    
    /// 只加载缓存数据
    case retutnCacheDataDontLoad
    
    /// 先加载缓存然后网络数据
    case retutnCacheDataThenLoad
    
}

public protocol CacheType {
    
    // 是否需要缓存
    var needCache: Bool { get }
    
    // 缓存资源的标示
    var cacheId: () -> String { get }
    
    // 加载缓存策略
    var cachePolicy: RequestCachePolicy { get }
}

