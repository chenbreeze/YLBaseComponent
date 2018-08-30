//
//  YLTargetType+Default.swift
//  YLBaseComponent
//
//  Created by chenxiaofeng on 2018/8/29.
//  Copyright © 2018年 xuanlv.cgs.com. All rights reserved.
//

import Foundation
import Moya

/// 在这里处理默认值, 相当于以此封装
extension YLTargetType {
    var baseURL: URL {
        return URL(string: "baseurl")!
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var authorizationType: AuthorizationType {
        return AuthorizationType.bearer
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var task: Task{
        return .requestParameters(parameters: self.parameters ?? [:], encoding: URLEncoding.default)
    }
    
    var needCache: Bool {
        return false
    }
    
    var cachePolicy: RequestCachePolicy {
        return .reloadIgnoringLocalCacheData
    }
    
    var cacheId: () -> String {
        return { self.path }
    }
}



