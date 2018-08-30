//
//  AddTokenPlugin.swift
//  BMBuyer
//
//  Created by chenxiaofeng on 2018/6/8.
//  Copyright © 2018年 shencai.cgs.com. All rights reserved.
//

import Moya

public struct AddTokenPlugin: PluginType{
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest{
        
        guard let authable = target as? AccessTokenAuthorizable else {
            return request
        }
        
        /// 获取 token, it is demo, 修改成真正的的获取方式
        let tempToken: String? = "balblababaa...token"
        
        guard let token = tempToken, token.count > 0  else {
            return request
        }
        var request = request
        let type = authable.authorizationType
        switch type {
        case .basic, .bearer:
            let authValue = type.rawValue + " " + token
            request.addValue(authValue, forHTTPHeaderField: "Authorization")
        default:
            break;
        }
        return request
    }
    
}
