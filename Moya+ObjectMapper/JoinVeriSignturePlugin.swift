//
//  JoinVeriSignturePlugin .swift
//  BMBuyer
//
//  Created by chenxiaofeng on 2018/6/8.
//  Copyright © 2018年 shencai.cgs.com. All rights reserved.
//

import Moya
import Alamofire


/// 加入验证签名参数插件; 这个插件也可以通过修改 EndpointClosure 来实现, 由于设置token 采用插件形式（见AccessTokenPlugin.swift，故加入验证签名参数 页采用插件形式, 这个插件会改写Request
public struct JoinVeriSignaturePlugin: PluginType{
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        
        switch target.task {
        case .requestParameters(parameters: let parameter, encoding: let encoder):
            
            let newParameter = joinVeriSignature(parameter)
            
            do{
                var newReuest = try encoder.encode(request, with: newParameter)
                newReuest.timeoutInterval = 20.0
                return newReuest
            }catch{
                assertionFailure("加入验证签名出错")
                return request
            }
    
        default:
            return request
        }
    }
    
    public func joinVeriSignature(_ parameter: [String: Any] ) -> [String: Any]{
        var newPara : [String: Any] = [:]
        
        func getSignString(_ item : Any) -> String{
            
            if JSONSerialization.isValidJSONObject(item) {
                do{
                    let data = try JSONSerialization.data(withJSONObject: item, options: .prettyPrinted)
                    return String.init(data: data, encoding: .utf8)!
                }catch{
                    return ""
                }
            }
            return "\(item)"
        }
        
        for (key, value) in parameter{
            newPara[key] = value
        }
        
        
        newPara["timestamp"] = "realTimestamp"
        newPara["os"] = "ios"
        newPara["version"] = "RealVersion"
        
        newPara["imei"] = "realImei"
        newPara["osVersion"] = "currentOSVersion"
        newPara["market"] = "App Store"
        newPara["mobileType"] = "realType"
        
        newPara["channels"] = "realChannels"
        
        let orderKeys = newPara.keys.sorted(by: <)
        
        var finalString = ""
        
        for key in orderKeys {
            finalString.append(key)
            finalString.append(getSignString(newPara[key]!))
        }
        finalString.append("ServerSignKey")
        
       // newPara["sign"] = finalString.md5
        
        return newPara
    }
}
