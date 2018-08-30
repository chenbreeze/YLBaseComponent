//
//  CheckErrorCodePlugin.swift
//  BMBuyer
//
//  Created by chenxiaofeng on 2018/6/26.
//  Copyright © 2018年 shencai.cgs.com. All rights reserved.
//

import Moya
import Result

/// 用来校验服务器错误代码
struct  CheckErrorCodePlugin: PluginType{
    
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType){
        
        switch result {
        case .success(let response):
            // 检查各种code
            if let data = try? response.mapEmptyModel(), let code = data?.code, code == 403 {
                // 做相应处理
                
            }
        default:
            break
        }
        
    }
}




